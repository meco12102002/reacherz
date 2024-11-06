import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:reacher/widgets/wordcart.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Database

class ModuleA extends StatefulWidget {
  const ModuleA({super.key});

  @override
  _ModuleAState createState() => _ModuleAState();
}

class _ModuleAState extends State<ModuleA> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _recognizedWords = '';
  bool _isLoading = false; // Track loading state

  int _score = 0;
  final Map<String, int> _attempts = {
    'apple': 0,
    'airplane': 0,
    'ant': 0,
  };

  final Map<String, bool> _isDisabled = {
    'apple': false,
    'airplane': false,
    'ant': false,
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
        _isLoading = true; // Show loading indicator
      });

      // Show listening modal
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text('Listening...'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_isLoading ? 'Speak now.' : 'You said: $_recognizedWords'),
                    if (_isLoading) // Show loading indicator
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              );
            },
          );
        },
      );

      // Start listening and update recognized words in real-time
      await _speechToText.listen(onResult: (result) async {
        setState(() {
          _recognizedWords = result.recognizedWords; // Update recognized words
          _isLoading = false; // Hide loading indicator

          // Check if the recognized words match the target word
          if (result.finalResult) {
            Navigator.of(context).pop(); // Close the dialog on final result
            _checkMatch(word);

            // Reset listening state
            _isListening = false; // Allow listening again
            _speechToText.stop(); // Stop the speech recognition
          }
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

      // Check if all cards have been answered
      if (_isDisabled.values.every((element) => element)) {
        _showCompletionDialog();
      }
    } else {
      setState(() {
        _attempts[word] = (_attempts[word] ?? 0) + 1; // Increment attempt
        if ((_attempts[word] ?? 0) >= 3) {
          _isDisabled[word] = true; // Disable card on 3 wrong attempts
          _showMaxAttemptsDialog(); // Show dialog for max attempts
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Not a match! You said: $_recognizedWords')),
      );
    }
  }

// New dialog for max attempts reached
  void _showMaxAttemptsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Maximum Attempts Reached'),
          content: const Text('You have reached the maximum attempts. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _resetModule(); // Reset the module to try again
              },
              child: const Text('Try Again'),
            ),
          ],
        );
      },
    );
  }


  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('You finished Lesson 1: Letter A'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _resetModule(); // Reset the module
              },
              child: const Text('Retake this Module'),
            ),
            TextButton(
              onPressed: () {
                // Save score to Firebase before navigating
                _saveScoreToFirebase();
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushReplacementNamed('/moduleB'); // Navigate to Module B
              },
              child: const Text('Go to Next Activity'),
            ),
          ],
        );
      },
    );
  }

  void _saveScoreToFirebase() {
    final User? user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      final userId = user.uid; // Get user ID
      final DatabaseReference scoresRef = FirebaseDatabase.instance.ref('scores/$userId').child("Module A"); // Reference to the scores node

      scoresRef.set({
        'score': _score, // Set score
        'timestamp': DateTime.now().millisecondsSinceEpoch, // Optionally save timestamp
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Score saved successfully!')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save score: $error')),
        );
      });
    }
  }

  void _resetModule() {
    setState(() {
      _score = 0;
      _attempts.forEach((key, value) => _attempts[key] = 0); // Reset attempts
      _isDisabled.forEach((key, value) => _isDisabled[key] = false); // Re-enable cards
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Letter A Module'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Score: $_score',
              style: Theme.of(context).textTheme.titleLarge,
            ), // Display the score
            const SizedBox(height: 16),
            WordCard(
              word: 'Apple',
              imageUrl: 'assets/images/apple.png',
              onMicPressed: () => _startListening('apple'),
              onSpeakerPressed: () => _playSound('apple'),
              isDisabled: _isDisabled['apple'] ?? false,
            ),
            const SizedBox(height: 16),
            WordCard(
              word: 'Airplane',
              imageUrl: 'assets/images/airplane.png',
              onMicPressed: () => _startListening('airplane'),
              onSpeakerPressed: () => _playSound('airplane'),
              isDisabled: _isDisabled['airplane'] ?? false,
            ),
            const SizedBox(height: 16),
            WordCard(
              word: 'Ant',
              imageUrl: 'assets/images/ant.png',
              onMicPressed: () => _startListening('ant'),
              onSpeakerPressed: () => _playSound('ant'),
              isDisabled: _isDisabled['ant'] ?? false,
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
