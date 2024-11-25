import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:reacher/pages/pdf_view.dart';
import 'package:reacher/pages/video_player_screen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // Import Syncfusion PDF Viewer package
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'audio_player_screen.dart';
import 'image_screen_viewer.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final DatabaseReference _tasksRef = FirebaseDatabase.instance.ref('sections');
  final String _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  String _getFileType(String extension) {
    switch (extension) {
      case '.pdf':
        return 'PDF';
      case '.jpg':
      case '.jpeg':
      case '.png':
        return 'Image';
      case '.mp3':
      case '.wav':
        return 'Audio';
      case '.mp4':
      case '.mov':
        return 'Video';
      case '.doc':
      case '.docx':
        return 'Document';
      case '.pptx':
        return 'Presentation'; // New case for PPTX
      default:
        return 'File';
    }
  }

  // Map file type to appropriate icon
  IconData _getFileIcon(String extension) {
    switch (extension) {
      case '.pdf':
        return Icons.picture_as_pdf;
      case '.jpg':
      case '.jpeg':
      case '.png':
        return Icons.image;
      case '.mp3':
      case '.wav':
        return Icons.audio_file;
      case '.mp4':
      case '.mov':
        return Icons.video_file;
      case '.doc':
      case '.docx':
        return Icons.insert_drive_file;
      case '.pptx': // New icon for PPTX
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  Future<void> _fetchTasks() async {
    try {
      final snapshot = await _tasksRef.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map?;
        if (data != null) {
          List<Map<String, dynamic>> userTasks = [];
          data.forEach((sectionId, sectionData) {
            final sectionMap = sectionData as Map?;
            final students = sectionMap?['students'] as Map?;
            if (students != null && students.containsKey(_currentUserId)) {
              final userModules = students[_currentUserId]['module'] as Map?;
              if (userModules != null) {
                userModules.forEach((moduleId, moduleData) {
                  final moduleMap = moduleData as Map?;
                  if (moduleMap != null) {
                    userTasks.add({
                      "id": moduleId,
                      ...moduleMap,
                    });
                  }
                });
              }
            }
          });

          setState(() {
            _tasks = userTasks;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error fetching tasks: $error');
    }
  }

  // Function to check file type and open accordingly
  void _openFile(String url) async {
    final uri = Uri.parse(url);
    final path = uri.path;
    final fileExtension = path.split('.').last.toLowerCase();

    if (fileExtension == 'pdf') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(pdfUrl: url), // Open PDF screen
        ),
      );
    } else if (fileExtension == 'mp3') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AudioPlayerScreen(url: url), // Open MP3 audio screen
        ),
      );
    } else if (fileExtension == 'mp4') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(url: url), // Open MP4 video screen
        ),
      );
    } else if (fileExtension == 'png' || fileExtension == 'jpg' || fileExtension == 'jpeg') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageViewerScreen(url: url), // Open Image viewer
        ),
      );
    } else if (fileExtension == 'pptx') {
      // Open PPTX using WebView for Google Slides or an online viewer
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewScreen(url: url),
        ),
      );
    } else {
      debugPrint('Unsupported file type: $fileExtension');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Learning Tasks',
          style: TextStyle(fontFamily: 'Baloo', fontSize: 24),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
          ? const Center(
        child: Text(
          'No tasks available',
          style: TextStyle(
            fontFamily: 'Baloo',
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      )
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          final fileURLs = task['fileURLs'] as List<dynamic>?;

          return Card(
            margin: const EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.yellow.shade100,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          task['title'] ?? 'Untitled Task',
                          style: const TextStyle(
                            fontFamily: 'Baloo',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task['description'] ?? 'No Description',
                    style: const TextStyle(
                      fontFamily: 'Baloo',
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (task['duration'] != null)
                    Text(
                      'Duration: ${task['duration']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  const SizedBox(height: 12),
                  if (fileURLs != null && fileURLs.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: fileURLs.map((fileUrl) {
                        final fileExtension = Uri.parse(fileUrl).path.split('.').last;
                        return GestureDetector(
                          onTap: () => _openFile(fileUrl),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Icon(_getFileIcon('.$fileExtension'), color: Colors.blue),
                                const SizedBox(width: 8),
                                const Text(
                                  'Open Learning Material',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontSize: 16,
                                    fontFamily: 'Baloo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// WebViewScreen class to load PPTX in WebView

class WebViewScreen extends StatefulWidget {
  final String url;
  WebViewScreen({required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    // Initialize the WebView when the widget is created
     // Initialization call for 4.10.0
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Presentation Viewer')),
      body: WebViewWidget(
        controller: WebViewController()  // Controller initialization for WebView
          ..loadRequest(Uri.parse(widget.url))  // Load the URL passed to this screen
          ..setJavaScriptMode(JavaScriptMode.unrestricted), // Enable JavaScript
      ),
    );
  }
}
