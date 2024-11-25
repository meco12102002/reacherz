import 'dart:math';

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
    await _audioPlayer.setSourceAsset('sounds/$word.mp3');
    await _audioPlayer.resume();
  }

  void _startListening(String word) async {
    if (!_isListening && (_isDisabled[word] ?? false) == false) {
      setState(() {
        _isListening = true;
        _recognizedWords = ''; // Reset recognized words
        _isLoading = true; // Show loading indicator
      });

      // Play the prompt sound and wait for it to finish


      // Show the listening modal with a PNG image
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.purple.shade50, // Fun, kid-friendly background
                title: Column(
                  children: [
                    Image.asset(
                      'assets/images/boy_listening.png', // Add your PNG image here
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Say the word!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isLoading ? 'Listening... 🎤' : 'You said: $_recognizedWords',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueAccent,
                      ),
                    ),
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





  // Kid-friendly feedback dialog
  void _showFeedbackDialog(String title, String message, Color color, String feedback) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: color.withOpacity(0.2), // Light background for a playful tone
          title: Row(
            children: [
              Icon(
                feedback == 'Correct! 👍' ? Icons.thumb_up : Icons.thumb_down,
                color: color,
                size: 32,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: color,
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Got it! 😊',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }


  void _checkMatch(String word) async {
    // Play feedback sound based on whether the answer is correct or wrong
    if (_recognizedWords.toLowerCase() == word.toLowerCase()) {
      setState(() {
        _score++;
        _isDisabled[word] = true; // Disable card on correct match
      });

      // Play correct sound (You can use your own sound asset)
      await _audioPlayer.setSourceAsset('sounds/yay.mp3');
      await _audioPlayer.resume();

      // Show correct answer dialog
      _showFeedbackDialog('Great job! 🎉', 'You said: $_recognizedWords', Colors.green, 'Correct! 👍');

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

      // Play wrong sound (You can use your own sound asset)
      await _audioPlayer.setSourceAsset('sounds/aww.mp3');
      await _audioPlayer.resume();

      // Show incorrect answer dialog
      _showFeedbackDialog('Oops! 😅', 'You said: $_recognizedWords', Colors.red, 'Not quite right!');
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

  void _showCompletionDialog() async {
    // Play congratulatory sound
    await _audioPlayer.setSourceAsset('sounds/you_win.mp3');
    await _audioPlayer.resume();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.lightGreen.shade50, // Soft background color for kids
          title: Row(
            children: [
              Icon(Icons.star, color: Colors.yellow.shade700, size: 32), // Star icon for celebration
              const SizedBox(width: 8),
              const Text(
                'Yay! You did it! 🎉',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'You finished Lesson 1: Letter A!',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your Score: $_score', // Display the user's score
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Great job, superstar! 🌟',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ready for the next challenge?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _showAssessmentDialog(); // Show assessment after completion
              },
              child: const Text(
                'View Assessment and Recommendations',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }


  void _showAssessmentDialog() async{
    String assessmentMessage = "Let's see how you did, friend! 🎉\n";
    int totalAttempts = 0; // Variable to keep track of the total attempts



    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.setSource(AssetSource("sounds/back_to_school.mp3"));
    await audioPlayer.setVolume(0.5); // Set volume to a comfortable level

    // Start playing the background music
    await audioPlayer.play(AssetSource("sounds/background_music.mp3"));

    // List of possible feedback messages for different attempts
    List<String> practiceMessages = [
      "Don't worry, you'll get it soon! 🧐",
      "Try again with a bit more focus! 🧐",
      "Maybe review it once more! 📚",
      "You're doing great, just keep practicing! 👍",
      "Keep it up, you're almost there! 💪"
    ];

    List<String> almostThereMessages = [
      "You're just one step away! 👏",
      "You almost got it! 🌟",
      "A little more effort, and you'll ace it! 💪",
      "So close, don't give up now! ✨",
      "You're nearly there, don't stop! 🔥"
    ];

    List<String> nailedItMessages = [
      "Great job, keep it up! 🌟",
      "You're on fire! 🔥",
      "Excellent work, you're a star! ✨",
      "Wow, that was perfect! 😎",
      "Amazing, you're doing great! 🌈"
    ];

    // Analyze attempts for each word and add dynamic feedback
    _attempts.forEach((word, attempts) {
      print("Processing word: $word, attempts: $attempts"); // Debug line
      Random random = Random();

      String feedbackMessage = "";

      // Select a random message based on the attempts
      if (attempts >= 3) {
        feedbackMessage = practiceMessages[random.nextInt(practiceMessages.length)];
      } else if (attempts == 2) {
        feedbackMessage = almostThereMessages[random.nextInt(almostThereMessages.length)];
      } else {
        feedbackMessage = nailedItMessages[random.nextInt(nailedItMessages.length)];
      }

      print("Feedback for '$word': $feedbackMessage"); // Debug line

      // Add the dynamic feedback message
      assessmentMessage += "\n- Word: '$word'\n  Feedback: $feedbackMessage";

      // Add the number of attempts to the total score
      totalAttempts += attempts;
    });

    // Add the total score to the assessment message
    assessmentMessage += "\n\nTotal attempts: $totalAttempts";

    print("Final assessment message: $assessmentMessage"); // Debug line

    // Typing effect stream
    Stream<String> _typeText(String text) async* {
      String displayedText = '';
      for (int i = 0; i < text.length; i++) {
        await Future.delayed(const Duration(milliseconds: 60)); // Typing delay
        displayedText += text[i];
        print("Typing: $displayedText"); // Debug line
        yield displayedText;  // Ensure the stream is yielding updates

      }
      await audioPlayer.stop();
      await audioPlayer.dispose();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.pink.shade50, // Soft background for kids
          title: const Row(
            children: [
              Icon(Icons.rocket, color: Colors.blueAccent, size: 32),
              SizedBox(width: 8),
              Text(
                'Our AI friend says:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add the GIF at the top
                Image.asset(
                  'assets/images/pusa.gif', // Replace with your GIF file path
                  height: 120, // Adjust size as needed
                  width: 120,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16), // Spacing between GIF and text
                StreamBuilder<String>(
                  stream: _typeText(assessmentMessage),
                  initialData: '',
                  builder: (context, snapshot) {
                    print("StreamBuilder snapshot data: ${snapshot.data}"); // Debug line

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show a loading indicator while typing
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData) {
                      return Text('No data');
                    }

                    // Dynamic colors for different feedback
                    TextStyle textStyle;
                    if (snapshot.data!.contains("Oops!")) {
                      textStyle = const TextStyle(color: Colors.red, fontSize: 18);
                    } else if (snapshot.data!.contains("Almost there")) {
                      textStyle = const TextStyle(color: Colors.orange, fontSize: 18);
                    } else if (snapshot.data!.contains("Amazing!")) {
                      textStyle = const TextStyle(color: Colors.green, fontSize: 18);
                    } else {
                      textStyle = const TextStyle(color: Colors.black87, fontSize: 18);
                    }

                    return Text(
                      snapshot.data ?? '',
                      style: textStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 10, // Limit lines to avoid infinite scrolling
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _resetModule(); // Reset the module for a retake
                audioPlayer.stop(); // Stop audio when closing dialog
                audioPlayer.dispose(); // Dispose the audio player
              },
              child: const Text(
                'Try Again 🤔',
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.greenAccent.shade700,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
              onPressed: () {
                // Save score to Firebase before navigating
                _saveScoreToFirebase();
                _audioPlayer.stop();
                _audioPlayer.dispose();
                audioPlayer.stop(); // Stop audio when closing dialog
                audioPlayer.dispose(); // Dispose the audio player
                Navigator.of(context).pop(); // Close assessment dialog
                Navigator.of(context).pushReplacementNamed('/moduleB'); // Navigate to next module
              },
              child: const Text(
                'Next Activity 🎉',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      },
    );

  }

  void _saveScoreToFirebase() {
    final User? user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      final userId = user.uid; // Get the user's UID
      final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

      // Fetch the user's name from the 'users' node using the UID
      databaseRef.child('users/$userId').once().then((DatabaseEvent userEvent) {
        final userData = userEvent.snapshot.value as Map<dynamic, dynamic>?;
        if (userData != null && userData['name'] != null) {
          final userName = userData['name']; // Get the user's name

          // Fetch the sections data to check if the student already exists
          databaseRef.child('sections').once().then((DatabaseEvent sectionsEvent) {
            final sectionsData = sectionsEvent.snapshot.value as Map<dynamic, dynamic>?;

            if (sectionsData != null) {
              bool studentFound = false;

              // Iterate through the sections
              sectionsData.forEach((sectionKey, sectionData) {
                final sectionName = sectionData['sectionName'];
                final students = sectionData['students'];

                // Check if the student exists in this section
                if (students != null && students.containsKey(userId)) {
                  studentFound = true;

                  // Reference to the module subcollection
                  final moduleRef = databaseRef.child('sections/$sectionKey/students/$userId/module');

                  // Search for the specific module by title
                  moduleRef.orderByChild('title').equalTo('Week 1: Discovering Vowels').once().then((DatabaseEvent moduleEvent) {
                    final modules = moduleEvent.snapshot.value as Map<dynamic, dynamic>?;

                    if (modules != null && modules.isNotEmpty) {
                      // Get the first moduleId
                      final moduleId = modules.keys.first;

                      // Reference to the "Module B" node under the found moduleId
                      final studentModuleRef = moduleRef.child('$moduleId/Module A');

                      // Update or insert the score for "Module B"
                      studentModuleRef.update({
                        'title:':"Module A",
                        'score': _score, // Assuming _score is the score variable
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                      }).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Score saved successfully under "Week 1: Discovering Vowels/Module A"!')),
                        );
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to save score: $error')),
                        );
                      });
                    }
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to retrieve module: $error')),
                    );
                  });
                }
              });

              // If the student doesn't exist in any section, insert the student under the first section
              if (!studentFound) {
                final firstSectionKey = sectionsData.keys.first; // Get the first section key
                final firstSectionRef = databaseRef.child('sections/$firstSectionKey/students/$userId');

                // Insert the student under the first section with the "Week 1: Discovering Vowels" module and "Module B"
                firstSectionRef.set({
                  'name': userName, // Use the fetched user name here
                  'module': {
                    databaseRef.push().key!: { // Generate a new module ID
                      'title': 'Week 1: Discovering Vowels',
                      'Module A': {
                        'score': _score,
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                      },
                    }
                  },
                }).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Student added and score saved under "Week 1: Discovering Vowels/Module B"!')),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add student: $error')),
                  );
                });
              }
            }
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to retrieve sections: $error')),
            );
          });
        } else {
          // Handle case when user's name is not found in the 'users' node
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User name not found.')),
          );
        }
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to retrieve user data: $error')),
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
        title: const Text(
          'Level 1:Letter A Module',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.pinkAccent, // Bright color for kids
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),

            // Animals Category
            Text(
              'Animals',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
            const SizedBox(height: 16),
            WordCard(
              word: 'Ant',
              imageUrl: 'assets/images/ant.png',
              onMicPressed: () => _startListening('ant'),
              onSpeakerPressed: () => _playSound('ant'),
              isDisabled: _isDisabled['ant'] ?? false,
            ),
            const SizedBox(height: 16),

            // Animals Category
            Text(
              'Vehicle',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
            WordCard(
              word: 'Airplane',
              imageUrl: 'assets/images/airplane.png',
              onMicPressed: () => _startListening('airplane'),
              onSpeakerPressed: () => _playSound('airplane'),
              isDisabled: _isDisabled['airplane'] ?? false,
            ),
            const Divider(), // Divider between categories

            // Fruits Category
            Text(
              'Fruits',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
            const SizedBox(height: 16),
            WordCard(
              word: 'Apple',
              imageUrl: 'assets/images/apple.png',
              onMicPressed: () => _startListening('apple'),
              onSpeakerPressed: () => _playSound('apple'),
              isDisabled: _isDisabled['apple'] ?? false,
            ),
            const Divider(), // Divider after fruits category
          ],
        ),
      ),
    );
  }



  @override
  void dispose() {
    _audioPlayer.dispose();
    _speechToText.stop();
    super.dispose();
  }
}
