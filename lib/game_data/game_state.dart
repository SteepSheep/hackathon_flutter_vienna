import 'package:equatable/equatable.dart';

part 'question_data.dart';

class GameState extends Equatable {
  const GameState({
    this.players = const [],
    this.questions = const [],
    this.durations = const {},
    this.answers = const {},
  });

  final List<String> players;
  final Map<String, int> answers;
  final Map<String, double> durations;
  final List<QuestionData> questions;

  @override
  List<Object?> get props => [players, answers, durations, questions];
}
