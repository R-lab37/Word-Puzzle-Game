import 'package:flutter/material.dart';
import 'word_puzzle_game.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Puzzle Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
          headline2: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          bodyText1: TextStyle(fontSize: 16, color: Colors.black),
          button: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      home: SplashScreen(), // Set SplashScreen as the initial route
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadGameScreen();
  }

  _loadGameScreen() async {
    await Future.delayed(
        const Duration(seconds: 3)); // Simulate a delay for demonstration
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WordPuzzlePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Default background color
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9C59FE), Color(0xFF6F53FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'JUMBL',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Digitalate', // Replace with your game font
                ),
              ),
              SizedBox(
                  height: 40), // Space between game name and loading indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WordPuzzlePage extends StatefulWidget {
  const WordPuzzlePage({super.key});

  @override
  _WordPuzzlePageState createState() => _WordPuzzlePageState();
}

class _WordPuzzlePageState extends State<WordPuzzlePage> {
  final WordPuzzleGame _game = WordPuzzleGame();
  final TextEditingController _controller = TextEditingController();
  String _message = '';
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _game.startGame();
  }

  void _checkAnswer() {
    setState(() {
      if (_game.checkAnswer(_controller.text)) {
        _message = 'Correct!';
        _score += _calculateScore();
        _game.startGame();
        _controller.clear();
      } else {
        _message = 'Try Again!';
      }
    });
  }

  int _calculateScore() {
    return _game.scrambledWord.length; // Basic scoring example
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Word Puzzle Game',
          style: TextStyle(
              fontFamily: 'Digitale',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF9C59FE), // Use game-themed color
        elevation: 0, // Remove shadow for a flat design
        leading: IconButton(
          icon:
              Icon(Icons.menu, color: Colors.white), // Custom game-themed icon
          onPressed: () {
            // Implement menu functionality
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh,
                color: Colors.white), // Custom game-themed icon
            onPressed: () {
              setState(() {
                _game.startGame();
                _message = '';
                _score = 0;
                _controller.clear();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _game.scrambledWord,
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Unscramble the word',
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
              autocorrect: false,
              onChanged: (value) {
                _message = '';
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAnswer,
              child: Text('Check'),
            ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(
                  fontSize: 24,
                  color: _message == 'Correct!' ? Colors.green : Colors.red),
            ),
            SizedBox(height: 20),
            Text(
              'Score: $_score',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
