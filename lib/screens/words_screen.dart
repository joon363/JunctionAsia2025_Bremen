import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reelstudy/theme.dart';

final List<String> times = [
  "3 months ago",
  "3 months ago",
  "3 months ago",
  "2 months ago",
  "2 months ago",
  "2 months ago",
  "2 months ago",
  "2 months ago",
  "2 months ago",
  "1 month ago",
  "1 month ago",
  "1 month ago",
  "1 month ago",
  "1 month ago",
  "1 month ago",
  "29 days ago",
  "29 days ago",
  "29 days ago",
  "29 days ago",
  "29 days ago",
  "29 days ago",
  "29 days ago",
  "22 days ago",
  "22 days ago",
  "22 days ago",
  "21 days ago",
  "21 days ago",
  "20 days ago",
  "19 days ago",
  "19 days ago",
  "19 days ago",
  "19 days ago",
  "18 days ago",
  "13 days ago",
  "13 days ago",
  "13 days ago",
  "13 days ago",
  "13 days ago",
  "12 days ago",
  "11 days ago",
  "11 days ago",
  "10 days ago",
  "10 days ago",
  "4 days ago",
  "4 days ago",
  "3 days ago",
  "3 days ago",
  "3 days ago",
  "2 days ago",
  "1 day ago",
  "1 day ago",
  "1 day ago",
  "1 day ago",
  "1 day ago"
  "1 day ago"
];



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
    final String response = await rootBundle.loadString('assets/datas/voca_user.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
        _words = data.map((json) => Word.fromJson(json)).toList();
        _words.shuffle();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _words.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Column(
          children: [
            Column(
              children: [
                Divider(),
                Text("단어 수: 187개", style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Divider(),

              ],
            ),
            Expanded(child: ListView.builder(
                itemCount: _words.length,
                itemBuilder: (context, index) {
                  return Material(
                    elevation: 5,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: index<3?primaryMediumBlue:primaryLightBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_words[index].word, style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(times[index], style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
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
                                  Divider(),
                                  Text("뜻"),
                                  Text(_words[index].wordMeaning),
                                  Divider(),
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
                      ),
                    ),
                  );
                },
              ),)

          ],
        )
    );
  }
}

