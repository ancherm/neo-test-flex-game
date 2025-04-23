import 'package:floor/floor.dart';
import '../entity/test.dart';

@dao
abstract class TestDao {
  @Query('SELECT * FROM Tests')
  Future<List<Test>> getAllTests();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTest(Test test);
}