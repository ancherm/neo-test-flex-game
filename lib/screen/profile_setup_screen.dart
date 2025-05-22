import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_database.dart';
import 'auth_gate.dart';

class ProfileSetupScreen extends StatefulWidget {
  final AppDatabase database;
  final String phone;
  const ProfileSetupScreen({
    Key? key,
    required this.database,
    required this.phone,
  }) : super(key: key);

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  bool _loading = false;

  static const _gradientStart = Color(0xFF921C63);
  static const _gradientEnd   = Color(0xFFE8A828);

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final fb.User? fbUser = fb.FirebaseAuth.instance.currentUser;
    if (fbUser == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(fbUser.uid)
        .set({
      'phone': widget.phone,
      'name': _nameCtrl.text.trim(),
      'contact': _contactCtrl.text.trim(),
      'points': 10,
      'testsCompleted': 0,
      'energy': 20,
      'completedLevels': [],
    });

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => AuthGate(database: widget.database)),
          (route) => false,
    );
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
              : Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Заполните профиль', style: TextStyle(color: Colors.white)),
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
                  Icon(Icons.person_add, size: 48, color: Colors.white),
                  SizedBox(height: 12),
                  Text(
                    'Настройка профиля',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Форма
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Имя',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Введите имя' : null,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Кнопка «Сохранить»
            _buildGradientButton(
              label: 'Сохранить',
              onTap: _submitProfile,
            ),
          ],
        ),
      ),
    );
  }
}