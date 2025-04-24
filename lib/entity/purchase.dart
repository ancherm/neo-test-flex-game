import 'package:floor/floor.dart';

@Entity(tableName: 'Purchase')
class Purchase {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int shopItemId; 
  final DateTime date;  

  Purchase({this.id, required this.shopItemId, required this.date});

  @override
  String toString() {
    return 'Purchase{id: $id, shopItemId: $shopItemId, date: ${date.toIso8601String()}}';
  }
}
