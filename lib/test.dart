import 'package:floor/floor.dart';

@Entity(tableName: 'Tests')
class Test {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String question;
  final String answers; // Храним как JSON-строку
  final int correctAnswer;

  Test({
    this.id,
    required this.question,
    required this.answers,
    required this.correctAnswer,
  });
}