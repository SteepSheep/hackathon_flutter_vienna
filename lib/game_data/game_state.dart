import 'package:equatable/equatable.dart';

part 'question_data.dart';

enum GamePhase {
  lobby,
  playing,
  artists,
}

class GameState extends Equatable {
  const GameState({
    this.phase = GamePhase.lobby,
    this.players = const [],
    this.answers = const {},
    this.durations = const {},
    this.currentQuestionIndex = 0,
    this.questions = const [],
  });

  factory GameState.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          'players': List<dynamic> players,
          'answers': Map<String, dynamic> answers,
          'durations': Map<String, dynamic> durations,
          'currentQuestionIndex': int currentQuestionIndex,
          'questions': List<dynamic> questions,
        } =>
          GameState(
            players: players.cast(),
            answers: answers.cast(),
            durations: durations.cast(),
            currentQuestionIndex: currentQuestionIndex,
            questions: [
              for (final question in questions) QuestionData.fromJson(question),
            ],
          ),
        _ => throw ArgumentError(),
      };

  final GamePhase phase;
  final List<String> players;
  final Map<String, int> answers;
  final Map<String, double> durations;
  final int currentQuestionIndex;
  final List<QuestionData> questions;

  QuestionData get currentQuestion => questions[currentQuestionIndex];

  @override
  List<Object?> get props =>
      [phase, players, answers, durations, currentQuestionIndex, questions];

  Map<String, dynamic> toJson() => {
        'players': players,
        'answers': answers,
        'durations': durations,
        'currentQuestionIndex': currentQuestionIndex,
        'questions': [
          for (final question in questions) question.toJson(),
        ],
      };
}
