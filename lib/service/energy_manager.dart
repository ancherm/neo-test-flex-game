import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../dao/user_dao.dart';
import '../entity/user.dart';

class EnergyManager {
  static const _prefsKey = 'lastEnergyUpdate';

  final UserDao _userDao;
  final SharedPreferences _prefs;
  final int maxEnergy    = 20;
  final int recoveryRate = 1; // в минутах

  Timer? _timer;

  EnergyManager(this._userDao, this._prefs);

  /// Получаем текущего локального пользователя по его Firebase UID
  Future<User?> _getCurrentLocalUser() async {
    final fb_auth.User? fbUser = fb_auth.FirebaseAuth.instance.currentUser;
    if (fbUser == null) return null;
    return _userDao.getUserById(fbUser.uid);
  }

  /// Пересчитывает энергию оффлайн — сколько минут прошло с последнего запуска
  Future<void> recoverOffline() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final last = _prefs.getInt(_prefsKey) ?? now;
    final minutesGone =
    ((now - last) / Duration.millisecondsPerMinute).floor();

    if (minutesGone > 0) {
      final user = await _getCurrentLocalUser();
      if (user != null && user.energy < maxEnergy) {
        final canRecover = maxEnergy - user.energy;
        final recovered  = (minutesGone ~/ recoveryRate).clamp(0, canRecover);
        if (recovered > 0) {
          user.energy += recovered;
          await _userDao.updateUser(user);
        }
      }
      // Обновляем точку отсчёта
      await _prefs.setInt(_prefsKey, now);
    }
  }

  /// Запускает таймер восстановления энергии в фоне, пока приложение активно
  void startEnergyRecovery() {
    _timer = Timer.periodic(
      Duration(minutes: recoveryRate),
          (timer) async {
        final user = await _getCurrentLocalUser();
        if (user != null && user.energy < maxEnergy) {
          user.energy += 1;
          await _userDao.updateUser(user);
        }
        // Обновляем время последнего обновления
        await _prefs.setInt(
          _prefsKey,
          DateTime.now().millisecondsSinceEpoch,
        );
      },
    );
  }

  /// Останавливает таймер восстановления
  void stopEnergyRecovery() {
    _timer?.cancel();
  }
}
