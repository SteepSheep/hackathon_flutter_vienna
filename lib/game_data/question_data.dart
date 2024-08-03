part of 'game_state.dart';

class QuestionData extends Equatable {
  const QuestionData({
    required this.songUrl,
    required this.answers,
  });

  final String songUrl;
  final List<String> answers;

  @override
  List<Object?> get props => [songUrl, answers];
}
