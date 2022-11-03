import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CharacterDetailsPage extends StatefulWidget {
  final int id;
  final String imageUrl;

  const CharacterDetailsPage({
    super.key,
    required this.id,
    required this.imageUrl,
  });

  @override
  State<StatefulWidget> createState() => _CharacterDetailsPageState();
}

class _CharacterDetailsPageState extends State<CharacterDetailsPage> {
  dynamic character;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final url = 'https://rickandmortyapi.com/api/character/${widget.id}';
    final apiResponse = await http.get(Uri.parse(url));
    if (apiResponse.statusCode == 200) {
      final jsonCharacter = jsonDecode(apiResponse.body);
      setState(() {
        character = jsonCharacter;
      });
    }

    CollectionReference characters =
        FirebaseFirestore.instance.collection('characters');
    final snapshot = await characters.doc('${widget.id}').get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        likeCount = data['likes'];
      });
    }
  }

  void like() async {
    CollectionReference characters =
        FirebaseFirestore.instance.collection('characters');
    int newLikeCount = likeCount + 1;
    setState(() {
      likeCount = newLikeCount;
    });
    await characters.doc('${widget.id}').set({'likes': likeCount});
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (character == null) {
      content = Column(
        children: [
          Hero(
              tag: widget.imageUrl,
              child: widget.imageUrl.startsWith('http')
                  ? Image.network(
                      widget.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(widget.imageUrl),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )),
          const Center(child: CircularProgressIndicator()),
        ],
      );
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: character['image'],
            child: Image.network(
              character['image'],
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text(character['name'], style: const TextStyle(fontSize: 30)),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Liked $likeCount time'),
          )
        ],
      );
    }
    return Scaffold(
      body: content,
      floatingActionButton: FloatingActionButton(
        onPressed: () => like(),
        child: const Icon(Icons.heart_broken),
      ),
    );
  }
}
