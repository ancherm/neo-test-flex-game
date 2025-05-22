// lib/services/game_service.dart

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../dao/user_dao.dart';
import '../entity/user.dart';

class GameService {
  final UserDao _userDao;

  GameService({UserDao? userDao}) : _userDao = userDao ?? UserDao();

  /// Вспомогательный метод: получает локального пользователя по текущему Firebase UID
  Future<User?> _getCurrentUser() async {
    final fb_auth.User? fbUser = fb_auth.FirebaseAuth.instance.currentUser;
    if (fbUser == null) return null;
    return _userDao.getUserById(fbUser.uid);
  }

  /// Снимает 10 энергии, даёт 10 очков за правильный ответ
  Future<void> checkAnswer(int selectedIndex, int correctAnswer) async {
    final user = await _getCurrentUser();
    if (user != null && user.energy >= 10) {
      user.energy -= 10;
      if (selectedIndex == correctAnswer) {
        user.points += 10;
      }
      await _userDao.updateUser(user);
    }
  }

  /// Обмен 10 очков на +20 энергии
  Future<void> buyEnergy() async {
    final user = await _getCurrentUser();
    if (user != null && user.points >= 10) {
      user.points -= 10;
      user.energy += 20;
      await _userDao.updateUser(user);
    }
  }
}
