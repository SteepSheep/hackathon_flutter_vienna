import 'package:equatable/equatable.dart';

part 'player_data.dart';

class GameState extends Equatable {
  const GameState({
    this.players = const [],
  });

  final List<PlayerData> players;

  @override
  List<Object?> get props => [players];
}
