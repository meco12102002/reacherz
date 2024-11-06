import 'package:flutter/material.dart';

class WordCard extends StatelessWidget {
  final String word;
  final String imageUrl;
  final VoidCallback onMicPressed;
  final VoidCallback onSpeakerPressed;
  final bool isDisabled;

  const WordCard({
    Key? key,
    required this.word,
    required this.imageUrl,
    required this.onMicPressed,
    required this.onSpeakerPressed,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          Image.asset(
            imageUrl,
            height: 100,
            fit: BoxFit.cover,
          ),
          Text(word),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.mic),
                onPressed: isDisabled ? null : onMicPressed, // Disable if needed
              ),
              IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: isDisabled ? null : onSpeakerPressed, // Disable if needed
              ),
            ],
          ),
        ],
      ),
    );
  }
}
