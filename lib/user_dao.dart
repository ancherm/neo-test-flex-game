import 'package:floor/floor.dart';
import 'user.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM User')
  Future<User?> getUser();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUser(User user);

  @Update()
  Future<void> updateUser(User user);
}