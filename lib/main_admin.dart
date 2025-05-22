import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'admin/admin_login_screen.dart';
import 'admin/admin_panel_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // инициализируем Firebase с Web-конфигом
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AdminLoginScreen(),
      routes: {
        '/panel': (_) => const AdminPanelScreen(),
      },
    );
  }
}