import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CardPage()),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Start'),
          ),
        ),
      ),
    );
  }
}

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  int _currentIndex = 0;
  final List<String> _cards = [
    'Card 1',
    'Card 2',
    'Card 3',
    'Card 4',
    'Card 5',
  ];

  Offset _dragOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.9;
    final cardHeight = size.height * 0.8;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: _buildDraggableCard(cardWidth, cardHeight),
      ),
    );
  }

  Widget _buildDraggableCard(double cardWidth, double cardHeight) {
    return GestureDetector(
      onVerticalDragUpdate: (details) => setState(() {
        _dragOffset += Offset(0, details.delta.dy);
      }),
      onVerticalDragEnd: (details) {
        if (_dragOffset.dy < -100) {
          setState(() {
            _currentIndex = (_currentIndex + 1) % _cards.length;
          });
        }
        setState(() => _dragOffset = Offset.zero);
      },
      child: Transform.translate(
        offset: _dragOffset,
        child: Card(
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: Center(
              child: Text(
                _cards[_currentIndex],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
