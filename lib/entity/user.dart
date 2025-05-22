import 'package:cloud_firestore/cloud_firestore.dart';
import 'purchase.dart';

class User {
  final String? id;
  final String name;
  final String phone;
  int points;
  int testsCompleted;
  int energy;
  final List<Purchase>? purchases;
  List<String> completedLevels;

  User({
    this.id,
    required this.phone,
    required this.name,
    required this.points,
    required this.testsCompleted,
    required this.energy,
    this.purchases,
    this.completedLevels = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'name': name,
      'points': points,
      'testsCompleted': testsCompleted,
      'energy': energy,
      // если null — поле не запишется
      if (purchases != null)
        'purchases': purchases!.map((p) => p.toMap()).toList(),
      'completedLevels': completedLevels,
    };
  }

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    // читаем вложённый список карт
    final raw = data['purchases'] as List<dynamic>?;
    final purchases = raw
        ?.map((e) => Purchase.fromMap(e as Map<String, dynamic>))
        .toList();

    return User(
      id: doc.id,
      phone: data['phone'] as String,
      name: data['name'] as String,
      points: data['points'] as int,
      testsCompleted: data['testsCompleted'] as int,
      energy: data['energy'] as int,
      purchases: purchases,
      completedLevels: List<String>.from(data['completedLevels'] ?? []),
    );
  }

  @override
  String toString() {
    return 'User(id: $id, phone: $phone, name: $name, points: $points, testsCompleted: $testsCompleted, energy: $energy, completedLevels: $completedLevels)';
  }
}
