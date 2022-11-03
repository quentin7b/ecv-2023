import 'package:flutter/material.dart';

class CharacterCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final bool isAlive;

  const CharacterCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.isAlive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: isAlive ? Colors.green : Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Hero(
              tag: imageUrl,
              child: Image.network(
                imageUrl,
                width: 120,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
