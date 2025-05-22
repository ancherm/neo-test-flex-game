import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../app_database.dart';
import 'auth_gate.dart';

class CodeVerificationScreen extends StatefulWidget {
  final String verificationId;
  final AppDatabase database;
  const CodeVerificationScreen({
    Key? key,
    required this.verificationId,
    required this.database,
  }) : super(key: key);

  @override
  _CodeVerificationScreenState createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  final _codeCtrl = TextEditingController();
  bool _loading = false;

  static const _gradientStart = Color(0xFF921C63);
  static const _gradientEnd   = Color(0xFFE8A828);

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    final code = _codeCtrl.text.trim();
    if (code.isEmpty) return;
    setState(() => _loading = true);
    try {
      final cred = fb.PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: code,
      );
      await fb.FirebaseAuth.instance.signInWithCredential(cred);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => AuthGate(database: widget.database)),
            (route) => false,
      );
    } on fb.FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Неверный код: ${e.message}')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildGradientButton({required String label, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: _loading ? null : onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_gradientStart, _gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(2,2), blurRadius: 4)],
        ),
        child: Center(
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Подтверждение кода', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF150F1E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            // Верхний карточный блок
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_gradientStart, _gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(2,2), blurRadius: 4)],
              ),
              child: Column(
                children: const [
                  Icon(Icons.message, size: 48, color: Colors.white),
                  SizedBox(height: 12),
                  Text(
                    'Введите код\nиз SMS',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Поле ввода кода
            TextField(
              controller: _codeCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Код из SMS',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Кнопка «Подтвердить»
            _buildGradientButton(
              label: 'Подтвердить',
              onTap: _verifyCode,
            ),
          ],
        ),
      ),
    );
  }
}