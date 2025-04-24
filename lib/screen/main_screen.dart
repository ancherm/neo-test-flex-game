import 'dart:async';

import 'package:flutter/material.dart';
import '../app_database.dart';
import '../entity/user.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  final AppDatabase database;

  const MainScreen({Key? key, required this.database}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  User? _user;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _loadUser();
    });
  }

  Future<void> _loadUser() async {
    final u = await widget.database.userDao.getUser();
    if (mounted) {
      setState(() {
        _user = u;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gradientStart = Color(0xFF921C63);
    const gradientEnd = Color(0xFFE8A828);

    if (_user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Главное меню', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF150F1E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(database: widget.database),
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [gradientStart, gradientEnd],
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
                            'Привет, ${_user!.name}!',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _buildMetric(Icons.star, _user!.points.toString()),
                              const SizedBox(width: 16),
                              _buildMetric(Icons.bolt, _user!.energy.toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
            Expanded(
              child: ListView(
                children: [
                  _buildGradientButton(
                    icon: Icons.quiz,
                    label: 'Тесты',
                    onTap: () => Navigator.pushNamed(context, '/tests'),
                    colors: [gradientStart, gradientEnd],
                  ),
                  const SizedBox(height: 35),
                  _buildGradientButton(
                    icon: Icons.store,
                    label: 'Магазин',
                    onTap: () => Navigator.pushNamed(context, '/shop'),
                    colors: [gradientStart, gradientEnd],
                  ),
                  const SizedBox(height: 35),
                  _buildGradientButton(
                    icon: Icons.history,
                    label: 'История\nНеофлекс',
                    onTap: () => Navigator.pushNamed(context, '/history'),
                    colors: [gradientStart, gradientEnd],
                  ),
                ],
              ),
            ),
          ],
        ),
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildGradientButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required List<Color> colors,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4),
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
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}