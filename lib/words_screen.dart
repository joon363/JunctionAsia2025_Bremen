import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Word {
  final String word;
  final String wordMeaning;
  final String exampleEng;
  final String exampleKor;

  Word({
    required this.word,
    required this.wordMeaning,
    required this.exampleEng,
    required this.exampleKor,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      wordMeaning: json['word_meaning'],
      exampleEng: json['example']['example_eng'],
      exampleKor: json['example']['example_kor'],
    );
  }
}

class WordListPage extends StatefulWidget {
  const WordListPage({super.key});

  @override
  State<WordListPage> createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  List<Word> _words = [];

  @override
  void initState() {
    super.initState();
    _loadWordData();
  }

  Future<void> _loadWordData() async {
    final String response = await rootBundle.loadString('assets/voca_user.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
        _words = data.map((json) => Word.fromJson(json)).toList();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _words.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemCount: _words.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_words[index].word, style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(_words[index].wordMeaning, overflow: TextOverflow.ellipsis,),
              onTap: () {
                showDialog(context: context, builder: (dialogContext) =>
                  AlertDialog(
                    backgroundColor: Colors.white,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(_words[index].word, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                        SizedBox(height: 4,),
                        Text(_words[index].wordMeaning),
                        SizedBox(height: 8,),
                        Text("예문", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("• ${_words[index].exampleEng}"),
                        Text("• ${_words[index].exampleKor}"),
                      ],
                    ),
                    actions: [
                      Column(
                        children: [
                          Divider(),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            child: const Text('OK', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )
                    ],
                    actionsAlignment: MainAxisAlignment.center,
                  )
                );

              },
            );
          },
        ),
    );
  }
}

class WordDetailPage extends StatelessWidget {
  final Word word;

  const WordDetailPage({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(word.word),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              word.word,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              word.wordMeaning,
              style: const TextStyle(fontSize: 18),
            ),
            const Divider(height: 40),
            const Text(
              'Example',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              word.exampleEng,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              word.exampleKor,
              style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}
