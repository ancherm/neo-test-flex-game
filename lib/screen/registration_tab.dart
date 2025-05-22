import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../app_database.dart';
import 'code_verification_screen.dart';

class RegistrationTab extends StatefulWidget {
  final AppDatabase database;
  const RegistrationTab({Key? key, required this.database}) : super(key: key);

  @override
  _RegistrationTabState createState() => _RegistrationTabState();
}

class _RegistrationTabState extends State<RegistrationTab> {
  final _phoneCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _startPhoneAuth() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите номер телефона')),
      );
      return;
    }
    setState(() => _loading = true);
    await fb.FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (fb.PhoneAuthCredential credential) async {
        // Авто-вход (Android)
        await fb.FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (fb.FirebaseAuthException e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Ошибка: ${e.message}')));
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CodeVerificationScreen(
            verificationId: verificationId,
            database: widget.database,
          ),
        ));
      },
      codeAutoRetrievalTimeout: (_) {},
    );
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Телефон'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _startPhoneAuth,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Получить код'),
            ),
          ],
        ),
      ),
      if (_loading) const Center(child: CircularProgressIndicator()),
    ]);
  }
}