import 'package:floor/floor.dart';
import '../entity/user.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM User LIMIT 1')
  Future<User?> getUser();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUser(User user);

  @Update()
  Future<void> updateUser(User user);

  @Query('SELECT * FROM User')
  Future<List<User>> getAllUsers();
}