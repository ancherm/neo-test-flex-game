import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {
  final String? id;
  final String name;
  final int cost;
  final String type;
  final String description;
  final String imageUrl;

  Shop({
    this.id,
    required this.name,
    required this.cost,
    required this.type,
    required this.description,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'cost': cost,
      'type': type,
      'description': description,
      'imageUrl': imageUrl,
    };
    // if (id != null) {
    //   map['id'] = id;
    // }
    return map;
  }

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      id: map['id'] as String?,
      name: map['name'] as String,
      cost: map['cost'] as int,
      type: map['type'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

  factory Shop.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Shop(
      id: doc.id,
      name: data['name'] as String,
      cost: data['cost'] as int,
      type: data['type'] as String,
      description: data['description'] as String,
      imageUrl: data['imageUrl'] as String,
    );
  }
}
