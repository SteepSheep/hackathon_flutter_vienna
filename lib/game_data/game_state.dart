import 'package:equatable/equatable.dart';

part 'question_data.dart';

class GameState extends Equatable {
  const GameState({
    this.players = const [],
    this.answers = const {},
    this.durations = const {},
    this.currentQuestionIndex = 0,
    this.questions = const [],
  });

  factory GameState.fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();

  final List<String> players;
  final Map<String, int> answers;
  final Map<String, double> durations;
  final int currentQuestionIndex;
  final List<QuestionData> questions;

  @override
  List<Object?> get props =>
      [players, answers, durations, currentQuestionIndex, questions];

  Map<String, dynamic> toJson() => {};
}
