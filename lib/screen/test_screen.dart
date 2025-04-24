import 'package:flutter/material.dart';
import 'package:neo_test_flex_game/screen/profile_screen.dart';
import '../app_database.dart';
import '../entity/user.dart';

class TestScreen extends StatefulWidget {
  final AppDatabase database;

  const TestScreen({required this.database, Key? key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final Map<String, Map<String, bool>> _completedParts = {
    'history': {'part1': false, 'part2': false},
    'flutter': {'part1': false, 'part2': false},
  };

  final Map<String, Map<String, List<bool>>> _answers = {
    'history': {
      'part1': [false, false],
      'part2': [false, false],
    },
    'flutter': {
      'part1': [false, false],
      'part2': [false, false],
    },
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Тесты',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF150F1E),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen(database: widget.database)),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF921C63), Color(0xFFE8A828)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildTestBlock(
                  context,
                  'Тест по истории компании',
                  _isTestCompleted('history'),
                  [
                    _buildTestPart(context, 'Часть 1', [
                      {
                        'question': 'На чем фокусировалась компания Neoflex в 2019 году?',
                        'options': [
                          'На заказной разработке высоконагруженных бизнес-приложений в микросервисной архитектуре и внедрении сложных ИТ-систем.',
                          'На автоматизацию цифровых каналов и бизнес-процессов для заказчиков',
                          'На разработку и внедрение сложных бизнес-приложений с использование передовых и современных методологий.',
                        ],
                        'correctIndex': 0,
                      },
                      {
                        'question': 'В каких городах были открыты новые офисы компании Neoflex в 2021 году?',
                        'options': [
                          'В Москве и Саратове',
                          'В Саратове и Самаре',
                          'В Краснодаре и Самаре',
                        ],
                        'correctIndex': 2,
                      },
                    ], 'history', 'part1'),
                    const SizedBox(height: 20),
                    _buildTestPart(context, 'Часть 2', [
                      {
                        'question': 'В каком году Neoflex стал первой российской компанией, получившей членство в международной Ассоциации Поставщиков Кредитной Информации (ACCIS)?',
                        'options': ['2021', '2020', '2019'],
                        'correctIndex': 1,
                      },
                      {
                        'question': 'В каком году стартовала программа по обучению компьютерной грамотности и программированию для детей в детских домах?',
                        'options': ['2021', '2020', '2019'],
                        'correctIndex': 0,
                      },
                    ], 'history', 'part2'),
                  ],
                ),
                const SizedBox(height: 30),
                _buildTestBlock(
                  context,
                  'Тест по Flutter',
                  _isTestCompleted('flutter'),
                  [
                    _buildTestPart(context, 'Часть 1', [
                      {
                        'question': 'Какой компанией был разработан Flutter?',
                        'options': ['OpenAI', 'Microsoft', 'Google'],
                        'correctIndex': 2,
                      },
                      {
                        'question': 'В каком году был выпущен Flutter?',
                        'options': ['2012', '2014', '2016'],
                        'correctIndex': 1,
                      },
                    ], 'flutter', 'part1'),
                    const SizedBox(height: 20),
                    _buildTestPart(context, 'Часть 2', [
                      {
                        'question': 'Как называлась первая версия Flutter?',
                        'options': ['Sky', 'Blue', 'Dart'],
                        'correctIndex': 0,
                      },
                      {
                        'question': 'В какой версии Flutter была реализована поддержка создания настольных приложений для Windows, macOS, Linux и Google Fuchsia?',
                        'options': ['Flutter 2.0', 'Flutter 3.0', 'Flutter 32.0'],
                        'correctIndex': 0,
                      },
                    ], 'flutter', 'part2'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isTestCompleted(String testType) {
    return _completedParts[testType]!['part1']! && _completedParts[testType]!['part2']!;
  }

  Future<bool> _onWillPop() async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти из теста?'),
        content: const Text('Вы уверены, что хотите выйти? Ваш прогресс будет сохранен.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
    return shouldPop ?? false;
  }

  Widget _buildTestBlock(
    BuildContext context,
    String title,
    bool isTestCompleted,
    List<Widget> children,
  ) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF921C63),
                  ),
                ),
                if (isTestCompleted)
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
            const SizedBox(height: 15),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTestPart(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> questions,
    String testType,
    String part,
  ) {
    final isPartCompleted = _completedParts[testType]![part]!;
    final partAnswers = _answers[testType]![part]!;

    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isPartCompleted ? Colors.green : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isPartCompleted ? Colors.green : Color(0xFF921C63),
              ),
            ),
            const SizedBox(height: 15),
            ...List<Widget>.generate(
              questions.length,
              (index) => Column(
                children: [
                  _buildQuestionCard(
                    questions[index]['question'],
                    questions[index]['options'],
                    questions[index]['correctIndex'],
                    partAnswers[index],
                    isPartCompleted,
                    (isCorrect) {
                      _answers[testType]![part]![index] = isCorrect;
                      _checkPartCompletion(testType, part);
                    },
                  ),
                  if (index < questions.length - 1) const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(
    String question,
    List<String> options,
    int correctIndex,
    bool isCorrect,
    bool isPartCompleted,
    ValueChanged<bool> onAnswerSelected,
  ) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            ...List<Widget>.generate(
              options.length,
              (index) => RadioListTile<int>(
                title: Text(
                  options[index],
                  style: const TextStyle(color: Colors.black87),
                ),
                value: index,
                groupValue: isPartCompleted && isCorrect ? correctIndex : null,
                onChanged: isPartCompleted
                    ? null
                    : (value) {
                        final isCorrectAnswer = value == correctIndex;
                        onAnswerSelected(isCorrectAnswer);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isCorrectAnswer
                                  ? 'Правильный ответ!'
                                  : 'Неправильный ответ',
                            ),
                            backgroundColor: isCorrectAnswer
                                ? Color.fromARGB(255, 49, 138, 50)
                                : Color.fromARGB(255, 148, 21, 47), 
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkPartCompletion(String testType, String part) async {
    final partAnswers = _answers[testType]![part]!;
    final allAnswered = partAnswers.every((answer) => answer != null);
    final allCorrect = partAnswers.every((answer) => answer == true);

    if (allAnswered && !_completedParts[testType]![part]!) {
      if (allCorrect) {
        setState(() {
          _completedParts[testType]![part] = true;
        });

        final user = await widget.database.userDao.getUser();
        if (user != null) {
          final updatedUser = User(
            id: user.id,
            name: user.name,
            points: user.points,
            energy: user.energy - 5,
            testsCompleted: user.testsCompleted,
          );
          await widget.database.userDao.updateUser(updatedUser);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Часть пройдена! -5 энергии'),
              duration: const Duration(seconds: 1),
            ),
          );
        }

        if (_isTestCompleted(testType)) {
          final user = await widget.database.userDao.getUser();
          if (user != null) {
            final updatedUser = User(
              id: user.id,
              name: user.name,
              points: user.points + 20,
              energy: user.energy,
              testsCompleted: user.testsCompleted + 1,
            );
            await widget.database.userDao.updateUser(updatedUser);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Тест полностью пройден! +20 очков'),
                backgroundColor: Color.fromARGB(255, 44, 138, 25),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Часть пройдена! Завершите вторую часть для награды'),
              backgroundColor: Color.fromARGB(255, 44, 138, 25),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      }
    }
  }
}