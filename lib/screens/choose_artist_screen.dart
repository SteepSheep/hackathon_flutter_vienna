import 'package:flutter/material.dart';

class ChooseArtistScreen extends StatelessWidget {
  const ChooseArtistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController artistController = TextEditingController();
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
              decoration: const InputDecoration(
                hintText: 'Enter your name'
              ),
              onChanged: (value) => nameController.text = value,
              onEditingComplete: () {
                
              },
            ),
            const Text(
              'Choose an artist',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: artistController,
              decoration: const InputDecoration(
                hintText: 'Enter an artist'
              ),
              onChanged: (value) => artistController.text = value,
              onEditingComplete: () {
                
              },
            ),
          ],
        ),
      ),
    );
  }
}
