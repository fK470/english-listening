import 'package:flutter/material.dart';
import '../services/card_service.dart';

class CardPage extends StatefulWidget {
  final Future<Map<String, dynamic>> initialCardFuture;
  const CardPage({super.key, required this.initialCardFuture});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  int _currentIndex = 0;
  Offset _dragOffset = Offset.zero;

  final List<Map<String, dynamic>> _cards = [];

  final _cardService = CardService();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.9;
    final cardHeight = size.height * 0.9;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: widget.initialCardFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            // 初期カードをリストに追加
            if (_cards.isEmpty) {
              _cards.add(snapshot.data!);
            }
            return _buildDraggableCard(cardWidth, cardHeight);
          },
        ),
      ),
    );
  }

  Widget _buildDraggableCard(double cardWidth, double cardHeight) {
    const double dragThreshold = 50;
    return GestureDetector(
      onVerticalDragUpdate: (details) => setState(() {
        _dragOffset += Offset(0, details.delta.dy);
      }),
      onVerticalDragEnd: (details) async {
        if (_dragOffset.dy < -dragThreshold) {
          setState(() {
            _currentIndex = (_currentIndex + 1) % _cards.length;
          });

          // 現在のカードが最後のカードの場合、次のカードを読み込む
          if (_currentIndex == _cards.length - 1) {
            Map<String, dynamic> nextCardSnapshot =
                await _cardService.loadCard(_currentIndex + 2);
            _cards.add(nextCardSnapshot);
          }
        }
        setState(() => _dragOffset = Offset.zero);
      },
      child: Transform.translate(
        offset: _dragOffset,
        child: Card(
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: Column(children: [
              FutureBuilder<String>(
                future: _cardService
                    .getImage(_cards[_currentIndex]['imageUrl'] as String),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error loading image: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // 読み込み中はインジケータを表示
                  }
                  return Image.network(
                    snapshot.data!, // 画像を表示
                    width: cardWidth * 0.9,
                    fit: BoxFit.cover,
                  );
                },
              ),
              if (_currentIndex < _cards.length)
                Text(
                  '$_currentIndex: ${_cards[_currentIndex]['questionText'] as String}',
                  style: const TextStyle(fontSize: 24),
                )
              else
                const Text('No card available'), // カードがない場合の表示
            ]),
          ),
        ),
      ),
    );
  }
}
