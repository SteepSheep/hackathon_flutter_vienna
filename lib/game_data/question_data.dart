part of 'game_state.dart';

class QuestionData extends Equatable {
  const QuestionData({
    required this.songUrl,
    required this.correctAnswer,
    required this.answers,
  });

  final String songUrl;
  final String correctAnswer;
  final List<String> answers;

  @override
  List<Object?> get props => [songUrl, correctAnswer, answers];
}
