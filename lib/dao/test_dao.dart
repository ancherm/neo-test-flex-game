import 'package:cloud_firestore/cloud_firestore.dart';
import '../entity/test.dart';

class TestDao {
  final CollectionReference<Map<String, dynamic>> _col =
  FirebaseFirestore.instance.collection('tests');

  /// Вставить один тест
  Future<void> insertTest(Test test) {
    return _col.add(test.toMap());
  }

  /// Получить все тесты
  Future<List<Test>> getAllTests() async {
    final snapshot = await _col.get();
    return snapshot.docs
        .map((doc) => Test.fromFirestore(doc))
        .toList();
  }
}
