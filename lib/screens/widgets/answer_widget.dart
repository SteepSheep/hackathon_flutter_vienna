import 'package:flutter/material.dart';

class AnswerWidget extends StatelessWidget {
  final String answer;
  final void Function() onSelected;
  const AnswerWidget({
    super.key,
    required this.answer,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onSelected,
        style: const ButtonStyle(),
        child: Text(answer),
      ),
    );
  }
}
