import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'user.dart';
import 'user_dao.dart';
import 'test.dart';
import 'test_dao.dart';
import 'shop.dart';
import 'shop_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [User, Test, Shop])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  TestDao get testDao;
  ShopDao get shopDao;
}