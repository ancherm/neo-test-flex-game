import 'package:cloud_firestore/cloud_firestore.dart';

class Test {
  final String? id;
  final String question;
  final List<String> answers;
  final int correctAnswer;
  final String testType;  // Новый: тип теста (e.g., history, flutter)
  final String part;      // Новый: часть теста (e.g., part1, part2)

  Test({
    this.id,
    required this.question,
    required this.answers,
    required this.correctAnswer,
    required this.testType,
    required this.part,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'question': question,
      'answers': answers,
      'correctAnswer': correctAnswer,
      'testType': testType,
      'part': part,
    };
    return map;
  }

  factory Test.fromMap(Map<String, dynamic> map) {
    return Test(
      id: map['id'] as String?,
      question: map['question'] as String,
      answers: List<String>.from(map['answers'] as List<dynamic>),
      correctAnswer: map['correctAnswer'] as int,
      testType: map['testType'] as String,
      part: map['part'] as String,
    );
  }

  factory Test.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Test(
      id: doc.id,
      question: data['question'] as String,
      answers: List<String>.from(data['answers'] as List<dynamic>),
      correctAnswer: data['correctAnswer'] as int,
      testType: data['testType'] as String,
      part: data['part'] as String,
    );
  }

  @override
  String toString() {
    return 'Test(id: $id, question: $question, answers: $answers, correctAnswer: $correctAnswer, testType: $testType, part: $part)';
  }
}