part of '../game_logic.dart';

class GameState extends Equatable {
  const GameState({
    this.players = const [],
  });

  final List<PlayerData> players;

  @override
  List<Object?> get props => [players];
}

class PlayerData extends Equatable {
  const PlayerData({
    required this.name,
    required this.points,
  });

  final String name;
  final int points;

  @override
  List<Object?> get props => [name, points];
}
