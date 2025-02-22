import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() => runApp(const MyApp()); // Starts the app

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Media Player', // Title for the app
      theme: ThemeData(primarySwatch: Colors.blue), // Blue theme color
      debugShowCheckedModeBanner: false, // Hides the debug banner
      home: const MediaPlayerScreen(), // Home screen of the app
    );
  }
}

class AppColors {
  // Define colors for different songs and text
  static const Color song1 = Color.fromARGB(255, 133, 104, 16);
  static const Color song2 = Color.fromARGB(255, 39, 38, 38);
  static const Color song3 = Color.fromARGB(255, 15, 47, 73);
  static const Color text = Colors.white; // White text color
  static const Color slider = Colors.white; // Slider color
}

class AppSizes {
  static const double padding = 40.0; // Padding around the page
}

class PageWrapper extends StatelessWidget {
  final Widget child;
  const PageWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.padding, vertical: 40.0), // Adds padding
      child: child, // Content of the page
    );
  }
}

class MediaPlayerScreen extends StatefulWidget {
  const MediaPlayerScreen({super.key});

  @override
  State<MediaPlayerScreen> createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player to play music
  bool _isPlaying = false; // Tracks whether the song is playing
  Duration _currentPosition = Duration.zero; // Current song position
  int _currentSongIndex = 0; // Index of the current song

  final List<Map<String, dynamic>> _songs = [
    // List of songs with details like URL, title, artist, image, and background color
    {
      'url': 'android/app/assets/sound/spotify_1.mp3',
      'title': 'Bad Memories',
      'artist': 'MEDUZA, James Carter',
      'image': 'android/app/assets/images/spotify_1.jpg',
      'color': AppColors.song1,
    },
    {
      'url': 'android/app/assets/sound/spotify_2.mp3',
      'title': 'BABY IM BACK',
      'artist': 'The Kid LAROI',
      'image': 'android/app/assets/images/spotify_2.jpg',
      'color': AppColors.song2,
    },
    {
      'url': 'android/app/assets/sound/spotify_3.mp3',
      'title': 'I like the way you kiss me',
      'artist': 'Artemas',
      'image': 'android/app/assets/images/spotify_3.jpg',
      'color': AppColors.song3,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Listen to the current song position and update UI
    _audioPlayer.positionStream.listen((position) {
      setState(() => _currentPosition = position);
    });

    // When the song ends, change to the next song
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _changeSong(1); // Go to next song when current one finishes
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Clean up the audio player when done
    super.dispose();
  }

  void _play() async {
    // Play the selected song
    await _audioPlayer.setAsset(_songs[_currentSongIndex]['url']);
    _audioPlayer.play();
    setState(() => _isPlaying = true); // Update playing state
  }

  void _pause() async {
    // Pause the song
    _audioPlayer.pause();
    setState(() => _isPlaying = false); // Update playing state
  }

  void _changeSong(int step) {
    // Change the song (next or previous)
    setState(() {
      _currentSongIndex = (_currentSongIndex + step) % _songs.length;
      _play(); // Play the new song
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = _songs[_currentSongIndex]; // Get current song details
    return Scaffold(
      backgroundColor: currentSong['color'], // Set background color
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: AppBar(
            backgroundColor: currentSong['color'], // Set app bar color
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(color: AppColors.text),
                const Expanded(
                  child: Center(
                    child: Text('Playing Now', // Title in the center
                        style: TextStyle(color: AppColors.text, fontSize: 18)),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert,
                      color: AppColors.text), // Options button
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
      body: PageWrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(currentSong['image'],
                  height: 300, width: 300, fit: BoxFit.cover), // Song image
            ),
            const SizedBox(height: 16),
            Text(currentSong['title'],
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text)), // Song title
            Text(currentSong['artist'],
                style: const TextStyle(
                    fontSize: 16, color: AppColors.text)), // Artist name
            const SizedBox(height: 16),
            Slider(
              value: _currentPosition.inSeconds.toDouble(),
              min: 0.0,
              max: _audioPlayer.duration?.inSeconds.toDouble() ?? 1.0,
              activeColor: AppColors.slider, // Slider color
              inactiveColor: AppColors.slider.withOpacity(0.5),
              onChanged: (value) => _audioPlayer.seek(
                  Duration(seconds: value.toInt())), // Change position of song
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Skip previous song
                IconButton(
                    icon:
                        const Icon(Icons.skip_previous, color: AppColors.text),
                    iconSize: 44,
                    onPressed: () => _changeSong(-1)),
                // Play or pause the song
                IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppColors.text),
                    iconSize: 58,
                    onPressed: _isPlaying ? _pause : _play),
                // Skip next song
                IconButton(
                    icon: const Icon(Icons.skip_next, color: AppColors.text),
                    iconSize: 44,
                    onPressed: () => _changeSong(1)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
