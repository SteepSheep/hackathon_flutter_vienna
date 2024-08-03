part of 'game_state.dart';

class QuestionData extends Equatable {
  const QuestionData({
    required this.songUrl,
    required this.correctAnswer,
    required this.answers,
  });

  QuestionData.fromJson(Map<String, dynamic> json)
      : this(
          songUrl: json['songUrl'],
          correctAnswer: json['correctAnswer'],
          answers: List.of(json['answers']),
        );

  final String songUrl;
  final String correctAnswer;
  final List<String> answers;

  @override
  List<Object?> get props => [songUrl, correctAnswer, answers];

  Map<String, dynamic> toJson() => {
        'songUrl': songUrl,
        'correctAnswer': correctAnswer,
        'answers': answers,
      };
}
