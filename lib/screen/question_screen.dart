// lib/screens/question_screen.dart

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';

import '../app_database.dart';
import '../entity/user.dart';
import '../entity/test.dart';

class QuestionScreen extends StatefulWidget {
  final AppDatabase database;
  final String levelKey;
  final List<Test> questions;

  const QuestionScreen({
    required this.database,
    required this.levelKey,
    required this.questions,
    Key? key,
  }) : super(key: key);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  static const _gradientStart = Color(0xFF921C63);
  static const _gradientEnd   = Color(0xFFE8A828);

  int _current = 0;
  bool _energyDeductedForFinish = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final fb_auth.User? fbUser = fb_auth.FirebaseAuth.instance.currentUser;
    if (fbUser == null) {
      Navigator.of(context).pushReplacementNamed('/');
      return;
    }
    final u = await widget.database.userDao.getUserById(fbUser.uid);
    if (!mounted) return;
    setState(() => _user = u);
  }

  void _deductEnergy(int amount, String reason) async {
    if (_user == null) return;
    _user!
      ..energy -= amount;
    await widget.database.userDao.updateUser(_user!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$reason – $amount энергии')),
    );
  }

  Future<void> _onAnswer(int choice) async {
    if (_user == null) return;
    final test = widget.questions[_current];
    final correct = choice == test.correctAnswer;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(correct ? 'Правильно!' : 'Неправильно!'),
        backgroundColor: correct ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );

    if (!correct) {
      _deductEnergy(1, 'Неправильный ответ');
      return;
    }

    await Future.delayed(const Duration(milliseconds: 500));
    if (_current < widget.questions.length - 1) {
      setState(() => _current++);
    } else {
      await _finishFull();
    }
  }

  void _finishEarly() {
    if (_user == null) return;
    if (!_energyDeductedForFinish) {
      _deductEnergy(2, 'Закончено досрочно');
      _energyDeductedForFinish = true;
    }
    Navigator.pop(context);
  }

  Future<void> _finishFull() async {
    if (_user == null) return;
    if (!_user!.completedLevels.contains(widget.levelKey)) {
      _user!
        ..points += 10
        ..testsCompleted += 1
        ..completedLevels.add(widget.levelKey);
      await widget.database.userDao.updateUser(_user!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Уровень пройден! +10 очков'),
          backgroundColor: Colors.blue,
        ),
      );
    }
    Navigator.pop(context);
  }

  Widget _buildGradientButton(String text, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_gradientStart, _gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(text,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final test = widget.questions[_current];
    return Scaffold(
      appBar: AppBar(
        title: Text('Вопрос ${_current + 1}/${widget.questions.length}', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF150F1E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Вопрос в оформлении карточки
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_gradientStart, _gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                test.question,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            // Ответы
            ...List.generate(test.answers.length, (i) {
              return _buildGradientButton(
                test.answers[i],
                    () => _onAnswer(i),
              );
            }),
            const Spacer(),
            // Досрочное завершение
            _buildGradientButton('Закончить тест досрочно', _finishEarly),
          ],
        ),
      ),
    );
  }
}
