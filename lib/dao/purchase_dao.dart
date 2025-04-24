import 'package:floor/floor.dart';
import '../entity/purchase.dart';

@dao
abstract class PurchaseDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPurchase(Purchase purchase);

  @Query('SELECT * FROM Purchase')
  Future<List<Purchase>> getAllPurchases();

}
