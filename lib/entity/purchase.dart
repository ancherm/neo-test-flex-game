import 'package:cloud_firestore/cloud_firestore.dart';

class Purchase {
  final String? id;
  final String shopItemId;
  final DateTime date;

  Purchase({
    this.id,
    required this.shopItemId,
    required this.date,
  });

  /// Преобразует в Map для записи в Firestore
  Map<String, dynamic> toMap() {
    final map = {
      'shopItemId': shopItemId,
      'date': date.toIso8601String(),
    };
    // if (id != null) {
    //   map['id'] = id;
    // }
    return map;
  }

  /// Ставим этот конструктор, если хранить покупки как вложенный список карт
  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'] as String?,
      shopItemId: map['shopItemId'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }

  /// Чтение покупки из отдельного документа
  factory Purchase.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Purchase(
      id: doc.id,
      shopItemId: data['shopItemId'] as String,
      date: DateTime.parse(data['date'] as String),
    );
  }
}