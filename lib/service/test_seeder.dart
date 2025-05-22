import 'package:shared_preferences/shared_preferences.dart';
import '../dao/test_dao.dart';
import '../entity/test.dart';

class TestSeeder {
  static const _seedKey = 'testsSeeded';

  /// Если ещё не сеяли — вставляет все тесты из списка
  static Future<void> seedInitialTests(List<Test> initialTests) async {
    final prefs = await SharedPreferences.getInstance();
    final already = prefs.getBool(_seedKey) ?? false;
    if (already) return;

    final dao = TestDao();
    for (var t in initialTests) {
      await dao.insertTest(t);
    }
    await prefs.setBool(_seedKey, true);
  }
}
