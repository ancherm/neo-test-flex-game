import 'package:floor/floor.dart';

@Entity(tableName: 'User')
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  int points;
  int testsCompleted;
  int energy;

  User({
    this.id,
    required this.name,
    required this.points,
    required this.testsCompleted,
    required this.energy,
  });

  @override
  String toString() {
    return 'User(id: $id, name: $name, points: $points, testsCompleted: $testsCompleted, energy: $energy)';
  }
}