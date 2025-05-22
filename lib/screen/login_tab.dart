import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../app_database.dart';
import 'code_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  final AppDatabase database;
  const LoginScreen({Key? key, required this.database}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  bool _loading = false;

  static const _gradientStart = Color(0xFF921C63);
  static const _gradientEnd   = Color(0xFFE8A828);

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _startPhoneAuth() async {
    if (!_formKey.currentState!.validate()) return;
    final phone = '+79${_phoneCtrl.text}';
    setState(() => _loading = true);
    await fb.FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (fb.PhoneAuthCredential cred) async {
        await fb.FirebaseAuth.instance.signInWithCredential(cred);
      },
      verificationFailed: (fb.FirebaseAuthException e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Ошибка: ${e.message}')));
      },
      codeSent: (String verificationId, int? token) {
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
        title: const Text('Вход по телефону', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF150F1E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            // Верхний карточный блок с лого или текстом (по аналогии с MainScreen)
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
                  Icon(Icons.phone_android, size: 48, color: Colors.white),
                  SizedBox(height: 12),
                  Text(
                    'Введите номер\nдля входа',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Форма ввода номера
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Номер телефона',
                  prefixText: '+79',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                validator: (v) {
                  if (v == null || v.length != 9) {
                    return 'Введите 9 цифр после +79';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),

            // Кнопка «Получить код»
            _buildGradientButton(
              label: 'Получить код',
              onTap: _startPhoneAuth,
            ),
          ],
        ),
      ),
    );
  }
}