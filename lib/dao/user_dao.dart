import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../entity/user.dart';

class UserDao {
  final CollectionReference<Map<String, dynamic>> _col =
  FirebaseFirestore.instance.collection('users');

  /// Получить пользователя по его UID
  Future<User?> getUserById(String uid) async {
    final doc = await _col.doc(uid).get();
    if (!doc.exists) return null;
    return User.fromFirestore(doc);
  }

  /// Получить «текущего» пользователя, если он залогинен в Firebase Auth
  /// (возвращает null, если нет авторизации или документ не найден)
  Future<User?> getCurrentUser() async {
    final fb.User? fbUser = fb.FirebaseAuth.instance.currentUser;
    if (fbUser == null) return null;
    return getUserById(fbUser.uid);
  }

  /// Вставить нового пользователя или обновить существующего по его id
  Future<void> insertUser(User user) async {
    final id = user.id ?? (throw ArgumentError('User.id is required to insert'));
    await _col.doc(id).set(user.toMap(), SetOptions(merge: true));
  }

  /// Обновить поля существующего пользователя
  Future<void> updateUser(User user) async {
    final id = user.id ?? (throw ArgumentError('Cannot update User without id'));
    await _col.doc(id).update(user.toMap());
  }

  /// Получить всех пользователей (если необходимо)
  Future<List<User>> getAllUsers() async {
    final snap = await _col.get();
    return snap.docs.map((doc) => User.fromFirestore(doc)).toList();
  }

  /// Следить за списком всех пользователей
  Stream<List<User>> watchAllUsers() {
    return _col.snapshots().map((snap) =>
        snap.docs.map((d) => User.fromFirestore(d)).toList());
  }

  /// Удалить всех пользователей из коллекции (используйте осторожно!)
  Future<void> deleteAllUsers() async {
    final batch = FirebaseFirestore.instance.batch();
    final snap = await _col.get();
    for (var doc in snap.docs) {
      batch.delete(_col.doc(doc.id));
    }
    await batch.commit();
  }
}
