import 'dart:async';
import 'package:flutter/material.dart';
import '../app_database.dart';
import '../entity/purchase.dart';
import '../entity/shop.dart';
import '../entity/user.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  final AppDatabase database;

  ProfileScreen({required this.database});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  List<Purchase> _purchases = [];
  Map<int, Shop> _shopMap = {};
  bool _loading = true;
  Timer? _timer;

  static const _gradientColors = [
    Color(0xFF921C63),
    Color(0xFFE8A828),
  ];

  @override
  void initState() {
    super.initState();
    _loadAll();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _loadAll());
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    final u  = await widget.database.userDao.getUser();
    final ps = await widget.database.purchaseDao.getAllPurchases();
    final ss = await widget.database.shopDao.getAllShopItems();
    setState(() {
      _user = u;
      _purchases = ps;
      _shopMap = { for (var s in ss) s.id! : s };
      _loading = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF150F1E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: _gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2,2))
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white24,
                      child: Text(
                        _user!.name.isNotEmpty ? _user!.name[0].toUpperCase() : '?',
                        style: const TextStyle(fontSize: 32, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _user!.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMetric('Очки', _user!.points.toString(), Icons.star),
                        _buildMetric('Энергия', _user!.energy.toString(), Icons.bolt),
                        _buildMetric('Тесты', _user!.testsCompleted.toString(), Icons.check),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Ваши покупки',
                  style: Theme.of(context).textTheme.headlineMedium!
                      .copyWith(color: Colors.black87)),
            ),
            const SizedBox(height: 12),

            _purchases.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text('Покупки отсутствуют', style: TextStyle(color: Colors.grey[600])),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _purchases.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (ctx, i) {
                      final p    = _purchases[i];
                      final item = _shopMap[p.shopItemId];
                      final date = DateFormat('dd.MM.yyyy HH:mm').format(p.date);
                      return Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: _gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(1,1))
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: item != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(item.imageUrl,
                                      width: 40, height: 40, fit: BoxFit.cover),
                                )
                              : const Icon(Icons.shopping_bag, color: Colors.white),
                          title: Text(item?.name ?? '—',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          subtitle: Text(date, style: const TextStyle(color: Colors.white70)),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
