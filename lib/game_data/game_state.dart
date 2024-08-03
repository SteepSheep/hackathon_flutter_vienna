import 'package:equatable/equatable.dart';

part 'player_data.dart';
part 'question_data.dart';

class GameState extends Equatable {
  const GameState({
    this.players = const [],
    this.questions = const [],
  });

  final List<PlayerData> players;
  final List<QuestionData> questions;

  @override
  List<Object?> get props => [players, questions];
}
