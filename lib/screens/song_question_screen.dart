import 'package:flutter/material.dart';
import 'package:hackathon_flutter_vienna/game_events/game_event.dart';
import 'package:hackathon_flutter_vienna/game_logic.dart';
import 'package:hackathon_flutter_vienna/screens/widgets/answer_widget.dart';

class SongQuestionScreen extends StatefulWidget {
  const SongQuestionScreen({super.key});

  @override
  State<SongQuestionScreen> createState() => _SongQuestionScreenState();
}

class _SongQuestionScreenState extends State<SongQuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            'What song is this?',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Icon(Icons.music_note),
          ValueListenableBuilder(
            valueListenable: gameLogic,
            builder: (context, value, child) {
              if (value.questions.isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: value
                      .questions[value.currentQuestionIndex].answers.length,
                  itemBuilder: (context, index) {
                    String answer = value
                        .questions[value.currentQuestionIndex].answers[index];
                    return AnswerWidget(
                        answer: answer,
                        onSelected: () {
                          gameLogic
                              .addEvent(Answer(answer: index, name: 'value'));
                        });
                  },
                );
              }
              return const SizedBox();
            },
          )
        ],
      ),
    );
  }
}
