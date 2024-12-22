import 'package:flutter/material.dart';
import '../services/card_service.dart';
import 'card_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _cardService = CardService();
  late Future<Map<String, dynamic>> _initialCardFuture;
  @override
  void initState() {
    super.initState();
    _initialCardFuture = _cardService.loadCard(1);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              textStyle: const TextStyle(fontSize: 24),
              padding: const EdgeInsets.symmetric(vertical: 32),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CardPage(initialCardFuture: _initialCardFuture)),
            ),
            child: const Text('Start'),
          ),
        ),
      ),
    );
  }
}
