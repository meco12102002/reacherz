import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;

  const VideoPlayerScreen({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isLocalVideo = false;  // To track if we're using a local video

  @override
  void initState() {
    super.initState();
    print("Video URL: ${widget.url}"); // Print the URL being fetched
    _initializeVideo();
  }

  // Method to initialize the video controller
  void _initializeVideo() {
    // Initially use the network video
    _controller = VideoPlayerController.network(widget.url);

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // If initialization succeeds, mark that the video is not local
      setState(() {
        _isLocalVideo = false;
      });
    }).catchError((error) {
      // Handle any error, such as decoding issues or network problems
      print("Error loading video: $error");

      // In case of any error (like decoding), switch to the local video
      setState(() {
        _isLocalVideo = true;
      });

      // Switch to a lower-resolution video if there was an error
      _controller = VideoPlayerController.network('https://path/to/lower-quality/video.mp4');
      _initializeVideoPlayerFuture = _controller.initialize();
    });
  }

  // Play the local video explicitly when the play button is clicked
  void _playLocalVideo() {
    setState(() {
      _controller = VideoPlayerController.asset('assets/videos/abc.mp4');
      _initializeVideoPlayerFuture = _controller.initialize();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Player"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<void>(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Restrict video size inside a fixed window, responsive to screen size
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                    height: MediaQuery.of(context).size.height * 0.4, // 40% of screen height
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Play/Pause Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),

                  // Play Local Video Button (Overrides network video playback)
                  ElevatedButton(
                    onPressed: _playLocalVideo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Play Local Video',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),

                  // Fullscreen Button
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (MediaQuery.of(context).size.width > MediaQuery.of(context).size.height) {
                        // Landscape mode
                        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
                      } else {
                        // Portrait mode
                        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Fullscreen',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error loading video: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
