import 'package:floor/floor.dart';
import '../entity/shop.dart';

@dao
abstract class ShopDao {
  @Query('SELECT * FROM Shop')
  Future<List<Shop>> getAllShopItems();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertShopItem(Shop shop);
}