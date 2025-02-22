import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Media Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MediaPlayerScreen(),
    );
  }
}

class MediaPlayerScreen extends StatefulWidget {
  const MediaPlayerScreen({super.key});

  @override
  State<MediaPlayerScreen> createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isPaused = false;
  bool _isStopped = true;

  // Example audio file URL, replace with a real file or local asset
  final String _audioUrl =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _play() async {
    await _audioPlayer.setUrl(_audioUrl);
    _audioPlayer.play();
    setState(() {
      _isPlaying = true;
      _isPaused = false;
      _isStopped = false;
    });
  }

  void _pause() async {
    _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
      _isPaused = true;
    });
  }

  void _stop() async {
    _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _isPaused = false;
      _isStopped = true;
    });
  }

  void _forward() async {
    final position = await _audioPlayer.position;
    _audioPlayer.seek(position + const Duration(seconds: 10));
  }

  void _rewind() async {
    final position = await _audioPlayer.position;
    _audioPlayer.seek(position - const Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              iconSize: 64,
              onPressed: _isPlaying ? _pause : _play,
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              iconSize: 64,
              onPressed: _stop,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.replay_10),
                  iconSize: 48,
                  onPressed: _rewind,
                ),
                IconButton(
                  icon: const Icon(Icons.forward_10),
                  iconSize: 48,
                  onPressed: _forward,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
