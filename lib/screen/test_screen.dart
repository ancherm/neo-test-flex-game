import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';

import '../app_database.dart';
import '../entity/test.dart';
import '../entity/user.dart';
import '../dao/test_dao.dart';
import 'question_screen.dart';

class LevelSelectionScreen extends StatefulWidget {
  final AppDatabase database;
  const LevelSelectionScreen({required this.database, Key? key}) : super(key: key);

  @override
  _LevelSelectionScreenState createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  static const _gradientStart = Color(0xFF921C63);
  static const _gradientEnd   = Color(0xFFE8A828);

  Map<String, Map<String, List<Test>>> _testsByLevel = {};
  User? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final fb_auth.User? fbUser = fb_auth.FirebaseAuth.instance.currentUser;
    if (fbUser == null) {
      Navigator.of(context).pushReplacementNamed('/');
      return;
    }
    final user = await widget.database.userDao.getUserById(fbUser.uid);
    final allTests = await TestDao().getAllTests();

    final Map<String, Test> uniqueMap = {};
    for (var t in allTests) {
      uniqueMap['${t.testType}|${t.part}|${t.question}'] = t;
    }
    final filtered = uniqueMap.values.toList();

    final map = <String, Map<String, List<Test>>>{};
    for (var t in filtered) {
      map.putIfAbsent(t.testType, () => {});
      map[t.testType]!.putIfAbsent(t.part, () => []).add(t);
    }

    setState(() {
      _user = user;
      _testsByLevel = map;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор уровня', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF150F1E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: _testsByLevel.entries.expand((entry) {
            final type = entry.key.toUpperCase();
            return entry.value.entries.map((e) {
              final partNum = e.key.replaceAll('part', '');
              final levelKey = '${entry.key}|${e.key}';
              final done = _user!.completedLevels.contains(levelKey);
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_gradientStart, _gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text('Уровень $type, часть $partNum',
                      style: const TextStyle(color: Colors.white)),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: done ? Colors.grey : null,
                    ),
                    onPressed: done
                        ? null
                        : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuestionScreen(
                            database: widget.database,
                            levelKey: levelKey,
                            questions: e.value,
                          ),
                        ),
                      ).then((_) => _loadData());
                    },
                    child: Text(done ? 'Пройдено' : 'Пройти'),
                  ),
                ),
              );
            });
          }).toList(),
        ),
      ),
    );
  }
}
