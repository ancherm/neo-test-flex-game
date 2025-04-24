import 'package:floor/floor.dart';

@Entity(tableName: 'Shop')
class Shop {
  @PrimaryKey(autoGenerate: true)
  final int? id;
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

  @override
  String toString() {
    return 'Shop(id: $id, name: $name, cost: $cost, type: $type)';
  }
}
