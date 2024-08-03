import 'package:flutter/material.dart';
import 'package:hackathon_flutter_vienna/game_events/game_event.dart';
import 'package:hackathon_flutter_vienna/game_logic.dart';

class ChooseArtistScreen extends StatelessWidget {
  const ChooseArtistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController artistController = TextEditingController();
    final FocusNode nameFocusNode = FocusNode();
    final FocusNode artistFocusNode = FocusNode();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Enter your name',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: nameController,
              focusNode: nameFocusNode,
              decoration: const InputDecoration(
                hintText: 'Enter your name'
              ),
              onChanged: (value) => nameController.text = value,
              onEditingComplete: () {
                artistFocusNode.requestFocus();
              },
            ),
            const Text(
              'Choose an artist',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: artistController,
              focusNode: artistFocusNode,
              decoration: const InputDecoration(
                hintText: 'Enter an artist'
              ),
              onChanged: (value) => artistController.text = value,
              onEditingComplete: () {
                gameLogic.addEvent(SubmitArtist(
                  artist: artistController.text, 
                  name: nameController.text
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
