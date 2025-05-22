import 'package:cloud_firestore/cloud_firestore.dart';
import '../entity/purchase.dart';

class PurchaseDao {
  final CollectionReference<Map<String, dynamic>> _col;

  /// При создании DAO передаёшь ID пользователя,
  /// под которым будут храниться его покупки.
  PurchaseDao(String userId)
      : _col = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('purchases');

  /// Вставить новую покупку
  Future<void> insertPurchase(Purchase purchase) async {
    await _col.add(purchase.toMap());
  }

  /// Получить все покупки пользователя
  Future<List<Purchase>> getAllPurchases() async {
    final snap = await _col.get();
    return snap.docs
        .map((doc) => Purchase.fromFirestore(doc))
        .toList();
  }

  /// (опционально) Следить в реальном времени за покупками
  Stream<List<Purchase>> watchAllPurchases() {
    return _col.snapshots().map((snap) =>
        snap.docs.map((d) => Purchase.fromFirestore(d)).toList());
  }
}
