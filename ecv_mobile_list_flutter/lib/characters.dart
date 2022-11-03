import 'dart:convert';

import 'package:ecv_mobile_list_flutter/character_add.dart';
import 'package:ecv_mobile_list_flutter/character_card.dart';
import 'package:ecv_mobile_list_flutter/character_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  List<dynamic> characters = [];
  int _currentLoadedPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchData(_currentLoadedPage);
    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter < 500) {
        _currentLoadedPage++;
        fetchData(_currentLoadedPage);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void fetchData(int pageNumber) async {
    final apiResponse = await http.get(Uri.parse(
        'https://rickandmortyapi.com/api/character?page=$pageNumber'));
    if (apiResponse.statusCode == 200) {
      final json = jsonDecode(apiResponse.body);
      final List<dynamic> jsonCharacters = json['results'];
      setState(() {
        characters.addAll(jsonCharacters);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personnages'),
      ),
      body: ListView.builder(
          controller: _scrollController,
          itemCount: characters.length,
          itemBuilder: (BuildContext context, int index) {
            dynamic e = characters[index];
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CharacterDetailsPage(
                      id: e['id'] as int,
                      imageUrl: e['image'] as String,
                    ),
                  ),
                );
              },
              child: CharacterCard(
                imageUrl: e['image'] as String,
                title: e['name'] as String,
                isAlive: e['status'] == 'Alive',
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final String? newImagePath = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CharacterAddPage()),
          );
          if (newImagePath != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => CharacterDetailsPage(
                        id: 0,
                        imageUrl: newImagePath,
                      )),
            );
          }
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
