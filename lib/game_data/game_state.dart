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
          'phase': int phase,
          'players': List<dynamic> players,
          'answers': Map<String, dynamic> answers,
          'durations': Map<String, dynamic> durations,
          'currentQuestionIndex': int currentQuestionIndex,
          'questions': List<dynamic> questions,
        } =>
          GameState(
            phase: GamePhase.values[phase],
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

  String? get winner {
    if (answers.length != players.length) {
      return null;
    }

    var bestTime = double.maxFinite;
    String? winner;
    for (final MapEntry(key: player, value: answer) in answers.entries) {
      if (answer == currentQuestion.correctAnswer &&
          bestTime > (durations[player] ?? double.maxFinite)) {
        winner = player;
      }
    }
    return winner;
  }

  @override
  List<Object?> get props =>
      [phase, players, answers, durations, currentQuestionIndex, questions];

  GameState copyWith({
    GamePhase? phase,
    List<String>? players,
    Map<String, int>? answers,
    Map<String, double>? durations,
    int? currentQuestionIndex,
    List<QuestionData>? questions,
  }) =>
      GameState(
        phase: phase ?? this.phase,
        players: players ?? this.players,
        answers: answers ?? this.answers,
        durations: durations ?? this.durations,
        currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
        questions: questions ?? this.questions,
      );

  Map<String, dynamic> toJson() => {
        'phase': phase.index,
        'players': players,
        'answers': answers,
        'durations': durations,
        'currentQuestionIndex': currentQuestionIndex,
        'questions': [
          for (final question in questions) question.toJson(),
        ],
      };
}
