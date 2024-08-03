part of 'game_state.dart';

class QuestionData extends Equatable {
  const QuestionData.fake()
      : this(
          songUrl: 'https://youtu.be/9-Qkx9TAM10?si=hXVS6lW-8mzd17CW',
          songPositionSeconds: 1,
          correctAnswer: 2,
          answers: const [
            'First answer',
            'second answer',
            'third answer',
            'fourth answer',
          ],
        );

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
  final int correctAnswer;
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
