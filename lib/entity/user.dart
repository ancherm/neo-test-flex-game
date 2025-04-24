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

  User copyWith({
    int? id,
    String? name,
    int? points,
    int? energy,
    int? testsCompleted,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      points: points ?? this.points,
      energy: energy ?? this.energy,
      testsCompleted: testsCompleted ?? this.testsCompleted,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, points: $points, testsCompleted: $testsCompleted, energy: $energy)';
  }
}