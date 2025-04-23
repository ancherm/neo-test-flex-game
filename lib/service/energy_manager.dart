import 'dart:async';
import 'package:floor/floor.dart';
import 'database_helper.dart';
import '../entity/user.dart';

class EnergyManager {
  Timer? _timer;
  final int maxEnergy = 100;
  final int recoveryRate = 5; // минут

  void startEnergyRecovery() {
    _timer = Timer.periodic(Duration(minutes: recoveryRate), (timer) async {
      final db = await DatabaseHelper.database;
      final user = await db.userDao.getUser();
      if (user != null && user.energy < maxEnergy) {
        user.energy += 1;
        await db.userDao.updateUser(user);
      }
    });
  }

  void stopEnergyRecovery() {
    _timer?.cancel();
  }
}