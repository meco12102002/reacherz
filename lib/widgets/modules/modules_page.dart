import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:reacher/widgets/modules/module_a.dart';
import 'package:reacher/widgets/modules/module_b.dart';
import 'package:reacher/widgets/modules/module_c.dart';
import 'package:reacher/widgets/modules/module_d.dart';

class ModulesPage extends StatefulWidget {
  const ModulesPage({super.key});

  @override
  _ModulesPageState createState() => _ModulesPageState();
}

class _ModulesPageState extends State<ModulesPage> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  late String currentUserId; // Declare currentUserId as late
  Map<String, List<int>> moduleScores = {};

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _fetchModuleScores();
    _getCurrentUser(); // Fetch current user ID at initialization
  }

  // Get the current logged-in user's ID
  Future<void> _getCurrentUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          currentUserId = user.uid; // Set current user ID
        });
        _fetchModuleScores(); // Fetch scores once the user ID is set
      }
    } catch (e) {
      debugPrint("Error getting current user: $e");
    }
  }

  // Fetch module scores from Firebase
  // Fetch module scores from Firebase
  Future<void> _fetchModuleScores() async {
    try {
      if (currentUserId.isEmpty) {
        throw Exception("User ID not set");
      }

      // Reference to scores in Firebase
      final scoresRef = _databaseReference
          .child('sections')
          .child('-OCGEctTeem9qJInxfCV') // Section ID
          .child('students')
          .child(currentUserId)
          .child('module');

      final snapshot = await scoresRef.get();

      if (snapshot.exists) {
        final moduleData = snapshot.value as Map<dynamic, dynamic>;

        // Make sure we clear the previous data before adding new scores
        setState(() {
          moduleScores = {}; // Reset the map before parsing

          moduleData.forEach((moduleId, moduleDetails) {
            if (moduleDetails is Map) {
              final scores = moduleDetails['scores'] as Map<dynamic, dynamic>?;
              if (scores != null) {
                final userScores = scores[currentUserId] as Map<dynamic, dynamic>?;
                if (userScores != null && userScores.containsKey('score')) {
                  final score = userScores['score'];

                  // Add score to the map for the corresponding module
                  moduleScores[moduleId] = [score]; // Save score as a list
                  debugPrint("Module: $moduleId, Score: $score"); // Debug log
                }
              }
            }
          });
        });
      } else {
        debugPrint("No module data found.");
      }
    } catch (e) {
      debugPrint("Error fetching module scores: $e");
    }
  }













  Future<void> _playBackgroundMusic(String musicAsset) async {
    try {
      if (isPlaying) {
        await _audioPlayer.stop();
      }
      await _audioPlayer.play(AssetSource(musicAsset));
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      debugPrint('Error playing background music: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  Widget _buildModuleCard(
      BuildContext context,
      String title,
      String description,
      String imageUrl,
      Widget modulePage,
      String musicAsset,
      int difficultyLevel,
      List<int>? scores,
      bool isModuleUnlocked,
      ) {
    final scoreText = (scores != null && scores.isNotEmpty)
        ? 'Score: ${scores.first}'
        : 'Not yet taken';

    return GestureDetector(
      onTap: isModuleUnlocked
          ? () {
        _playBackgroundMusic(musicAsset);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => modulePage),
        );
      }
          : null,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pinkAccent.shade100, Colors.blueAccent.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Expanded(
                child: Image.asset(imageUrl, fit: BoxFit.contain),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'ComicSans',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontFamily: 'ComicSans',
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              _buildDifficultyStars(difficultyLevel),
              const SizedBox(height: 8),
              Text(
                scoreText, // Display the fetched score or "Not yet taken"
                style: const TextStyle(
                  fontFamily: 'ComicSans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (scores != null && scores.isNotEmpty && scores.first > 0)
                ElevatedButton(
                  onPressed: () {
                    _playBackgroundMusic(musicAsset);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => modulePage),
                    );
                  },
                  child: const Text('Retake'),
                )
              else if (isModuleUnlocked)
                ElevatedButton(
                  onPressed: () {
                    _playBackgroundMusic(musicAsset);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => modulePage),
                    );
                  },
                  child: const Text('Play'),
                )
              else
                const Text(
                  'Level Locked',
                  style: TextStyle(
                    fontFamily: 'ComicSans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }




  Widget _buildDifficultyStars(int difficultyLevel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Icon(
          index < difficultyLevel ? Icons.star : Icons.star_border,
          color: Colors.yellow,
          size: 24,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Phonics Adventures',
          style: TextStyle(
            fontFamily: 'ComicSans',
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/kiddie_Bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/kids_learning.png',
                  height: 60,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Practice with us!',
                  style: TextStyle(
                    fontFamily: 'ComicSans',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildModuleCard(
                    context,
                    'Module A',
                    'Learn about the letter A',
                    'assets/images/A.png',
                    const ModuleA(),
                    'sounds/backgroundmusic.mp3',
                    1,
                    moduleScores['Module A'],
                    true, // Always unlocked
                  ),
                  _buildModuleCard(
                    context,
                    'Module B',
                    'Learn about the letter B',
                    'assets/images/B.png',
                    const ModuleB(),
                    'sounds/music_b.mp3',
                    2,
                    moduleScores['Module B'],
                      true
                  ),
                  _buildModuleCard(
                    context,
                    'Module C',
                    'Learn about the letter C',
                    'assets/images/C.png',
                    const ModuleC(),
                    'sounds/music_c.mp3',
                    3,
                    moduleScores['Module C'],
                      moduleScores['Module B'] != null && moduleScores['Module B']!.first > 0
                  ),
                  _buildModuleCard(
                    context,
                    'Module D',
                    'Learn about the letter D',
                    'assets/images/D.png',
                    const ModuleD(),
                    'sounds/music_d.mp3',
                    3,
                    moduleScores['Module D'],
                      moduleScores['Module C'] != null && moduleScores['Module C']!.first > 0
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
