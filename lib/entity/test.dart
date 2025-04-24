import 'package:floor/floor.dart';

@Entity(tableName: 'Tests')
class Test {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String question;
  final String answers; 
  final int correctAnswer;

  Test({
    this.id,
    required this.question,
    required this.answers,
    required this.correctAnswer,
  });

  @override
  String toString() {
    return 'Test(id: $id, question: $question, answers: $answers, correctAnswer: $correctAnswer)';
  }

}