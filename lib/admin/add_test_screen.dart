// lib/screens/add_test_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTestScreen extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>>? doc; // если НЕ null — мы редактируем

  const AddTestScreen({Key? key, this.doc}) : super(key: key);

  @override
  _AddTestScreenState createState() => _AddTestScreenState();
}

class _AddTestScreenState extends State<AddTestScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _questionCtrl;
  late final List<TextEditingController> _answerCtrls;
  late final TextEditingController _typeCtrl;
  late final TextEditingController _partCtrl;
  int _correctIndex = 0;
  String? _error;

  bool get _isEditing => widget.doc != null;

  @override
  void initState() {
    super.initState();
    _questionCtrl = TextEditingController();
    _answerCtrls = List.generate(3, (_) => TextEditingController());
    _typeCtrl = TextEditingController();
    _partCtrl = TextEditingController();

    if (_isEditing) {
      final data = widget.doc!.data()!;
      _questionCtrl.text = data['question'] as String;
      final answers = List<String>.from(data['answers'] as List<dynamic>);
      for (var i = 0; i < 3; i++) {
        _answerCtrls[i].text = answers[i];
      }
      _correctIndex = data['correctAnswer'] as int;
      _typeCtrl.text = data['testType'] as String;
      _partCtrl.text = data['part'] as String;
    }
  }

  @override
  void dispose() {
    _questionCtrl.dispose();
    _answerCtrls.forEach((c) => c.dispose());
    _typeCtrl.dispose();
    _partCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveTest() async {
    if (!_formKey.currentState!.validate()) return;

    final testData = {
      'question': _questionCtrl.text.trim(),
      'answers': _answerCtrls.map((c) => c.text.trim()).toList(),
      'correctAnswer': _correctIndex,
      'testType': _typeCtrl.text.trim(),
      'part': _partCtrl.text.trim(),
    };

    try {
      final coll = FirebaseFirestore.instance.collection('tests');
      if (_isEditing) {
        await coll.doc(widget.doc!.id).update(testData);
      } else {
        await coll.add(testData);
      }
      Navigator.pop(context);
    } catch (e) {
      setState(() => _error = 'Ошибка сохранения: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Редактировать тест' : 'Добавить тест'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Вопрос
              TextFormField(
                controller: _questionCtrl,
                decoration: const InputDecoration(labelText: 'Вопрос'),
                validator: (v) => v!.isEmpty ? 'Введите вопрос' : null,
              ),
              const SizedBox(height: 16),

              // Три варианта ответа
              ...List.generate(3, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: _answerCtrls[i],
                    decoration: InputDecoration(labelText: 'Вариант ${i + 1}'),
                    validator: (v) =>
                    v!.isEmpty ? 'Введите вариант ${i + 1}' : null,
                  ),
                );
              }),

              const SizedBox(height: 8),
              Text('Правильный ответ:',
                  style: Theme.of(context).textTheme.titleMedium),

              // Радиокнопки для выбора правильного варианта
              ...List.generate(3, (i) {
                return RadioListTile<int>(
                  title: Text('Вариант ${i + 1}'),
                  value: i,
                  groupValue: _correctIndex,
                  onChanged: (v) => setState(() => _correctIndex = v!),
                );
              }),

              const SizedBox(height: 16),
              // Тип теста
              TextFormField(
                controller: _typeCtrl,
                decoration: const InputDecoration(labelText: 'Тип теста'),
                validator: (v) => v!.isEmpty ? 'Введите тип теста' : null,
              ),

              const SizedBox(height: 16),
              // Часть
              TextFormField(
                controller: _partCtrl,
                decoration: const InputDecoration(labelText: 'Часть теста'),
                validator: (v) => v!.isEmpty ? 'Введите часть теста' : null,
              ),

              // Ошибка
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveTest,
                child: Text(_isEditing ? 'Сохранить' : 'Добавить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
