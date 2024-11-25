import 'package:flutter/material.dart';

class ImageViewerScreen extends StatelessWidget {
  final String url;

  const ImageViewerScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Material")),
      body: Center(
        child: Image.network(url),
      ),
    );
  }
}