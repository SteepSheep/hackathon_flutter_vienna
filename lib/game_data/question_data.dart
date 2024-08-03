part of 'game_state.dart';

class QuestionData extends Equatable {
  const QuestionData({
    required this.songUrl,
    this.songPositionSeconds = 0,
    required this.correctAnswer,
    required this.answers,
  });

  QuestionData.fromJson(Map<String, dynamic> json)
      : this(
          songUrl: json['songUrl'],
          correctAnswer: json['correctAnswer'],
          answers: json['answers'].cast(),
        );

  final String songUrl;
  final int songPositionSeconds;
  final String correctAnswer;
  final List<String> answers;

  @override
  List<Object?> get props =>
      [songUrl, songPositionSeconds, correctAnswer, answers];

  Map<String, dynamic> toJson() => {
        'songUrl': songUrl,
        'correctAnswer': correctAnswer,
        'answers': answers,
      };
}
