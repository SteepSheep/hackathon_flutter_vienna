part of 'game_state.dart';

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
