import 'package:equatable/equatable.dart';
import 'hero.dart';
import 'pawn.dart';

class GachaResult extends Equatable {
  final bool isHero;
  final Hero? hero;
  final Pawn? pawn;
  final int rarityLevel;

  const GachaResult({
    required this.isHero,
    this.hero,
    this.pawn,
    required this.rarityLevel,
  });

  @override
  List<Object?> get props => [isHero, rarityLevel];
}
