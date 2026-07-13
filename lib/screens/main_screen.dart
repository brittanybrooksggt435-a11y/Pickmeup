import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade900.withOpacity(0.3),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Верхняя панель
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '🏝️ Остров',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.money, color: Colors.amber),
                        SizedBox(width: 4),
                        Text(
                          '100',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.flag, color: Colors.blue),
                        SizedBox(width: 4),
                        Text(
                          'Ур. 1',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Меню
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildMenuCard(
                      context,
                      icon: Icons.casino,
                      label: 'Гача',
                      onTap: () => _showComingSoon(context, 'Гача'),
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.sword,
                      label: 'Подземелье',
                      onTap: () => _showComingSoon(context, 'Подземелье'),
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.people,
                      label: 'Отряд',
                      onTap: () => _showComingSoon(context, 'Отряд'),
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.build,
                      label: 'Остров',
                      onTap: () => _showComingSoon(context, 'Остров'),
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.backpack,
                      label: 'Инвентарь',
                      onTap: () => _showComingSoon(context, 'Инвентарь'),
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.insights,
                      label: 'Журнал',
                      onTap: () => _showComingSoon(context, 'Журнал'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.grey.shade900.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🛠️ $feature — скоро будет!'),
        backgroundColor: Colors.purple.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
