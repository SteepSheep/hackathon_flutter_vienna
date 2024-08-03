part of 'game_state.dart';

class QuestionData extends Equatable {
  const QuestionData.fake()
      : this(
          songUrl: 'https://youtu.be/W8tbQgXyn1c?si=sv_1hZv6spv3xkrz',
          songPositionSeconds: 130,
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
          songPositionSeconds: json['songPositionSeconds'],
          correctAnswer: json['correctAnswer'],
          answers: List.from(json['answers']),
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
        'songPositionSeconds': songPositionSeconds,
        'correctAnswer': correctAnswer,
        'answers': answers,
      };
}
