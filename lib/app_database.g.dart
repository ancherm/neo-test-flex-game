// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  TestDao? _testDaoInstance;

  ShopDao? _shopDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `points` INTEGER NOT NULL, `testsCompleted` INTEGER NOT NULL, `energy` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Tests` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `question` TEXT NOT NULL, `answers` TEXT NOT NULL, `correctAnswer` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Shop` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `cost` INTEGER NOT NULL, `type` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  TestDao get testDao {
    return _testDaoInstance ??= _$TestDao(database, changeListener);
  }

  @override
  ShopDao get shopDao {
    return _shopDaoInstance ??= _$ShopDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'points': item.points,
                  'testsCompleted': item.testsCompleted,
                  'energy': item.energy
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'points': item.points,
                  'testsCompleted': item.testsCompleted,
                  'energy': item.energy
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  @override
  Future<User?> getUser() async {
    return _queryAdapter.query('SELECT * FROM User',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            name: row['name'] as String,
            points: row['points'] as int,
            testsCompleted: row['testsCompleted'] as int,
            energy: row['energy'] as int));
  }

  @override
  Future<void> insertUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.abort);
  }
}

class _$TestDao extends TestDao {
  _$TestDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _testInsertionAdapter = InsertionAdapter(
            database,
            'Tests',
            (Test item) => <String, Object?>{
                  'id': item.id,
                  'question': item.question,
                  'answers': item.answers,
                  'correctAnswer': item.correctAnswer
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Test> _testInsertionAdapter;

  @override
  Future<List<Test>> getAllTests() async {
    return _queryAdapter.queryList('SELECT * FROM Tests',
        mapper: (Map<String, Object?> row) => Test(
            id: row['id'] as int?,
            question: row['question'] as String,
            answers: row['answers'] as String,
            correctAnswer: row['correctAnswer'] as int));
  }

  @override
  Future<void> insertTest(Test test) async {
    await _testInsertionAdapter.insert(test, OnConflictStrategy.replace);
  }
}

class _$ShopDao extends ShopDao {
  _$ShopDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _shopInsertionAdapter = InsertionAdapter(
            database,
            'Shop',
            (Shop item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'cost': item.cost,
                  'type': item.type
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Shop> _shopInsertionAdapter;

  @override
  Future<List<Shop>> getAllShopItems() async {
    return _queryAdapter.queryList('SELECT * FROM Shop',
        mapper: (Map<String, Object?> row) => Shop(
            id: row['id'] as int?,
            name: row['name'] as String,
            cost: row['cost'] as int,
            type: row['type'] as String));
  }

  @override
  Future<void> insertShopItem(Shop shop) async {
    await _shopInsertionAdapter.insert(shop, OnConflictStrategy.replace);
  }
}
