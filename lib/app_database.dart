import 'dart:async';
import 'package:neo_test_flex_game/dao/purchase_dao.dart';
import 'package:neo_test_flex_game/entity/purchase.dart';
import 'entity/user.dart';
import 'dao/user_dao.dart';
import 'entity/test.dart';
import 'dao/test_dao.dart';
import 'entity/shop.dart';
import 'dao/shop_dao.dart';


class AppDatabase {
  final UserDao userDao = UserDao();
  final ShopDao shopDao = ShopDao();
  final TestDao testDao = TestDao();

  /// Для покупок нужно передать userId
  PurchaseDao purchaseDao(String userId) => PurchaseDao(userId);
}