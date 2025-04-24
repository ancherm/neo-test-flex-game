import 'package:flutter/material.dart';
import 'package:neo_test_flex_game/app_database.dart';
import 'package:neo_test_flex_game/entity/user.dart';
import 'package:neo_test_flex_game/screen/profile_screen.dart';

class MainScreen extends StatelessWidget {
  final AppDatabase database;

  MainScreen({required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Главное меню',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF150F1E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<User?>(
        future: database.userDao.getUser(),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = snap.data;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(database: database),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/neoflex-logo.png',
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user != null
                                      ? 'Привет, ${user.name}!'
                                      : 'Добро пожаловать!',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    _buildMetric(Icons.star,
                                        user?.points.toString() ?? '0'),
                                    const SizedBox(width: 16),
                                    _buildMetric(Icons.bolt,
                                        user?.energy.toString() ?? '0'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _buildGradientButton(
                        icon: Icons.quiz,
                        label: 'Тесты',
                        onTap: () => Navigator.pushNamed(context, '/tests'),
                      ),
                      _buildGradientButton(
                        icon: Icons.store,
                        label: 'Магазин',
                        onTap: () => Navigator.pushNamed(context, '/shop'),
                      ),
                      _buildGradientButton(
                        icon: Icons.history,
                        label: 'История\nНеофлекс',
                        onTap: () => Navigator.pushNamed(context, '/history'),
                      ),
                      _buildGradientButton(
                        icon: Icons.logout,
                        label: 'Выйти',
                        gradientColors: const [Colors.redAccent, Colors.red],
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, '/welcome'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetric(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.amber),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildGradientButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    List<Color>? gradientColors,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors ??
                const [Color(0xFF921c63), Color(0xFFe8a828)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
