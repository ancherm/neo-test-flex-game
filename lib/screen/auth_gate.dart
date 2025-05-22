import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../app_database.dart';
import '../entity/user.dart';
import 'login_tab.dart';
import 'main_screen.dart';
import 'profile_setup_screen.dart';

class AuthGate extends StatelessWidget {
  final AppDatabase database;
  const AuthGate({Key? key, required this.database}) : super(key: key);

  /// Проверяем, есть ли документ пользователя в Firestore
  Future<bool> _userExists(fb.User fbUser) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(fbUser.uid)
        .get();
    return doc.exists;
  }

  /// Синхронизируем локальную БД из Firestore
  Future<void> _syncLocalUser(fb.User fbUser) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(fbUser.uid)
        .get();
    final remote = User.fromFirestore(doc);
    final dao = database.userDao;
    final existing = await dao.getUserById(fbUser.uid);
    if (existing == null) {
      await dao.insertUser(remote);
    } else {
      await dao.updateUser(remote);
    }
  }

  /// Если в локальной БД остался пользователь с другим UID — очищаем
  Future<void> _handleNewUser(fb.User fbUser) async {
    final dao = database.userDao;
    final old = await dao.getUserById(fbUser.uid);
    if (old != null && old.id != fbUser.uid) {
      // Удаляем старого пользователя
      await dao.deleteAllUsers();
      // Удаляем все покупки старого пользователя
      // Предполагается, что purchaseDao принимает userId
      // await database.purchaseDao(old.id!).deleteAllPurchases();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<fb.User?>(
      stream: fb.FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final fbUser = snap.data;
        if (fbUser == null) {
          // Не залогинен → экран ввода телефона
          return LoginScreen(database: database);
        }

        // Пользователь залогинен → сначала обрабатываем смену аккаунта
        return FutureBuilder<void>(
          future: _handleNewUser(fbUser),
          builder: (ctx2, hSnap) {
            if (hSnap.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            // После очистки/ничего → проверяем, есть ли профиль в Firestore
            return FutureBuilder<bool>(
              future: _userExists(fbUser),
              builder: (ctx3, eSnap) {
                if (eSnap.connectionState != ConnectionState.done) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                final exists = eSnap.data ?? false;
                if (exists) {
                  // Профиль есть → синхронизируем и показываем MainScreen
                  return FutureBuilder<void>(
                    future: _syncLocalUser(fbUser),
                    builder: (ctx4, sSnap) {
                      if (sSnap.connectionState != ConnectionState.done) {
                        return const Scaffold(
                          body: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return MainScreen(database: database);
                    },
                  );
                } else {
                  // Новая учётка → показываем экран заполнения профиля
                  return ProfileSetupScreen(
                    database: database,
                    phone: fbUser.phoneNumber!,
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
