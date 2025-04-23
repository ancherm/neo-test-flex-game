import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'entity/user.dart';
import 'dao/user_dao.dart';
import 'entity/test.dart';
import 'dao/test_dao.dart';
import 'entity/shop.dart';
import 'dao/shop_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [User, Test, Shop])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  TestDao get testDao;
  ShopDao get shopDao;
}