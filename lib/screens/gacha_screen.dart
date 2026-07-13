import 'dart:math';
import 'package:flutter/material.dart';
import '../models/hero.dart';
import '../models/pawn.dart';
import '../models/gacha_result.dart';

class GachaScreen extends StatefulWidget {
  const GachaScreen({super.key});

  @override
  State<GachaScreen> createState() => _GachaScreenState();
}

class _GachaScreenState extends State<GachaScreen> {
  int gold = 100;
  int currentRolls = 0;
  List<GachaResult> history = [];
  bool isRolling = false;
  
  final Random _random = Random();
  
  final List<String> heroNames = [
    'Ариэль', 'Торн', 'Эльза', 'Дрейк', 'Мия',
    'Каин', 'Люна', 'Зевс', 'Сера', 'Феникс',
  ];
  
  final List<String> pawnNames = [
    'Кузнец Брон', 'Шахтёр Рок', 'Алхимик Мор',
    'Повар Сладкий', 'Торговец Финн',
  ];
  
  void _rollGacha() async {
    if (gold < 100) {
      _showMessage('Недостаточно золота!');
      return;
    }
    
    setState(() {
      isRolling = true;
    });
    
    gold -= 100;
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    final bool isHero = _random.nextDouble() < 0.6;
    final int rarity = _getRarity();
    
    GachaResult result;
    if (isHero) {
      final hero = Hero(
        id: 'hero_${DateTime.now().millisecondsSinceEpoch}',
        name: heroNames[_random.nextInt(heroNames.length)],
        heroClass: HeroClass.values[_random.nextInt(HeroClass.values.length)],
        rarity: _rarityFromInt(rarity),
        personality: HeroPersonality.values[_random.nextInt(HeroPersonality.values.length)],
        strength: 5 + rarity * 3,
        defense: 5 + rarity * 2,
        agility: 5 + rarity * 2,
        intelligence: 5 + rarity * 2,
        will: 30 + rarity * 10,
        morality: 30 + rarity * 10,
        trust: 20 + rarity * 5,
      );
      result = GachaResult(
        isHero: true,
        hero: hero,
        rarityLevel: rarity,
      );
    } else {
      final pawn = Pawn(
        id: 'pawn_${DateTime.now().millisecondsSinceEpoch}',
        name: pawnNames[_random.nextInt(pawnNames.length)],
        role: PawnRole.values[_random.nextInt(PawnRole.values.length)],
        rarity: PawnRarity.values[_random.nextInt(3)],
        personality: PawnPersonality.values[_random.nextInt(PawnPersonality.values.length)],
        will: 20 + rarity * 5,
        trust: 20 + rarity * 5,
        efficiency: 30 + rarity * 10,
      );
      result = GachaResult(
        isHero: false,
        pawn: pawn,
        rarityLevel: rarity,
      );
    }
    
    setState(() {
      history.add(result);
      currentRolls++;
      isRolling = false;
    });
    
    _showResult(result);
  }
  
  int _getRarity() {
    final roll = _random.nextDouble();
    if (roll < 0.4) return 1;
    if (roll < 0.7) return 2;
    if (roll < 0.85) return 3;
    if (roll < 0.95) return 4;
    return 5;
  }
  
  HeroRarity _rarityFromInt(int value) {
    switch (value) {
      case 1: return HeroRarity.oneStar;
      case 2: return HeroRarity.twoStar;
      case 3: return HeroRarity.threeStar;
      case 4: return HeroRarity.fourStar;
      case 5: return HeroRarity.fiveStar;
      default: return HeroRarity.oneStar;
    }
  }
  
  void _showResult(GachaResult result) {
    final stars = '⭐' * result.rarityLevel;
    final type = result.isHero ? 'Герой' : 'Пешка';
    final name = result.isHero ? result.hero!.name : result.pawn!.name;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Row(
          children: [
            Text(
              result.isHero ? '⚔️' : '🔨',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$type получен!',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: TextStyle(
                color: _getColorByRarity(result.rarityLevel),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              stars,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 10),
            Text(
              result.isHero 
                ? 'Класс: ${result.hero!.heroClass.name}'
                : 'Роль: ${result.pawn!.role.name}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отлично!', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }
  
  Color _getColorByRarity(int rarity) {
    switch (rarity) {
      case 1: return Colors.grey;
      case 2: return Colors.green;
      case 3: return Colors.blue;
      case 4: return Colors.purple;
      case 5: return Colors.amber;
      default: return Colors.white;
    }
  }
  
  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }
  
  void _showHeroList() {
    final heroes = history.where((h) => h.isHero && h.hero != null).toList();
    if (heroes.isEmpty) {
      _showMessage('Пока нет героев. Совершите ролл!');
      return;
    }
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  '📋 Мои герои',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: heroes.length,
                    itemBuilder: (context, index) {
                      final h = heroes[index].hero!;
                      return Card(
                        color: Colors.grey.shade800,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _getColorByRarity(h.rarity.index + 1).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _getColorByRarity(h.rarity.index + 1),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${h.rarity.index + 1}',
                                style: TextStyle(
                                  color: _getColorByRarity(h.rarity.index + 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            h.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${h.heroClass.name} | Ур. ${h.level} | ❤️ ${h.trust}% | 🧠 ${h.will}%',
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                          trailing: Text(
                            '⭐' * (h.rarity.index + 1),
                            style: const TextStyle(fontSize: 16),
                          ),
                          onTap: () => _showHeroDetails(h),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  void _showHeroDetails(Hero hero) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          hero.name,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow('Класс', hero.heroClass.name),
            _buildStatRow('Уровень', '${hero.level}'),
            _buildStatRow('Сила', '${hero.strength}'),
            _buildStatRow('Защита', '${hero.defense}'),
            _buildStatRow('Ловкость', '${hero.agility}'),
            _buildStatRow('Интеллект', '${hero.intelligence}'),
            _buildStatRow('Воля', '${hero.will}%'),
            _buildStatRow('Мораль', '${hero.morality}%'),
            _buildStatRow('Доверие', '${hero.trust}%'),
            _buildStatRow('Редкость', '⭐' * (hero.rarity.index + 1)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          '🎰 Гача',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.money, color: Colors.amber, size: 30),
                    const SizedBox(width: 10),
                    Text(
                      '$gold золота',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              if (isRolling) ...[
                const CircularProgressIndicator(color: Colors.amber),
                const SizedBox(height: 10),
                const Text(
                  '🎲 Бросаем...',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ] else ...[
                ElevatedButton.icon(
                  onPressed: gold >= 100 ? _rollGacha : null,
                  icon: const Icon(Icons.casino, size: 30),
                  label: const Text(
                    'Ролл (100 золота)',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Text(
                'Роллов: $currentRolls',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: _showHeroList,
                icon: const Icon(Icons.people, color: Colors.blue),
                label: const Text(
                  'Посмотреть героев',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
