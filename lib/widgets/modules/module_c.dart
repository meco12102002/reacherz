import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:reacher/widgets/wordcart.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ModuleC extends StatefulWidget {
  const ModuleC({super.key});

  @override
  _ModuleCState createState() => _ModuleCState();
}

class _ModuleCState extends State<ModuleC> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _recognizedWords = '';
  bool _speechHeard = false; // To track if speech was heard

  int _score = 0;
  final Map<String, int> _attempts = {
    'cat': 0,
    'car': 0,
    'cake': 0,
  };

  final Map<String, bool> _isDisabled = {
    'cat': false,
    'car': false,
    'cake': false,
  };

  @override
  void initState() {
    super.initState();
    _initializeSpeechRecognition();
  }

  void _initializeSpeechRecognition() async {
    bool available = await _speechToText.initialize();
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition not available')),
      );
    }
  }

  void _playSound(String word) async {
    await _audioPlayer.setSourceAsset('assets/sounds/$word.mp3');
    await _audioPlayer.resume();
  }

  void _startListening(String word) async {
    if (!_isListening && (_isDisabled[word] ?? false) == false) {
      setState(() {
        _isListening = true;
        _recognizedWords = ''; // Reset recognized words
        _speechHeard = false; // Reset speech heard status
      });

      // Show listening modal
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Listening...'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_speechHeard ? 'Click submit to analyze.' : 'Speak now.'),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await _speechToText.stop();
                  _checkMatch(word);
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Submit'),
              ),
            ],
          );
        },
      );

      await _speechToText.listen(onResult: (result) {
        setState(() {
          _recognizedWords = result.recognizedWords;
          _speechHeard = result.hasConfidenceRating && result.confidence > 0.5; // Check if speech was recognized
        });
      });
    }
  }

  void _checkMatch(String word) {
    if (_recognizedWords.toLowerCase() == word.toLowerCase()) {
      setState(() {
        _score++;
        _isDisabled[word] = true; // Disable card on correct match
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Matched! You said: $_recognizedWords')),
      );
    } else {
      setState(() {
        _attempts[word] = (_attempts[word] ?? 0) + 1; // Increment attempt
        if ((_attempts[word] ?? 0) >= 3) {
          _isDisabled[word] = true; // Disable card on 3 wrong attempts
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Not a match! You said: $_recognizedWords')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Score: $_score'), // Display the score
            const SizedBox(height: 16),
            WordCard(
              word: 'Cat',
              imageUrl: 'assets/images/cat.png',
              onMicPressed: () => _startListening('cat'),
              onSpeakerPressed: () => _playSound('cat'),
              isDisabled: _isDisabled['cat'] ?? false, // Safe access
            ),
            const SizedBox(height: 16),
            WordCard(
              word: 'Car',
              imageUrl: 'assets/images/car.png',
              onMicPressed: () => _startListening('car'),
              onSpeakerPressed: () => _playSound('car'),
              isDisabled: _isDisabled['car'] ?? false, // Safe access
            ),
            const SizedBox(height: 16),
            WordCard(
              word: 'Cake',
              imageUrl: 'assets/images/cake.png',
              onMicPressed: () => _startListening('cake'),
              onSpeakerPressed: () => _playSound('cake'),
              isDisabled: _isDisabled['cake'] ?? false, // Safe access
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speechToText.stop();
    super.dispose();
  }
}

extension on AudioPlayer {
  setSourceAsset(String s) {}
}
