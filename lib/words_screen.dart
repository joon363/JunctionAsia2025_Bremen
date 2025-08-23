import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 단어 데이터 모델 클래스
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

  // JSON 데이터로부터 Word 객체를 생성하는 팩토리 생성자
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      wordMeaning: json['word_meaning'],
      exampleEng: json['example']['example_eng'],
      exampleKor: json['example']['example_kor'],
    );
  }
}

// 단어 목록 페이지
class WordListPage extends StatefulWidget {
  const WordListPage({super.key});

  @override
  State<WordListPage> createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  // 단어 목록을 저장할 리스트
  List<Word> _words = [];

  @override
  void initState() {
    super.initState();
    _loadWordData(); // 위젯이 생성될 때 JSON 데이터 로드
  }

  // assets/voca_user.json 파일에서 단어 데이터를 불러오는 함수
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
        ? const Center(child: CircularProgressIndicator()) // 로딩 중 표시
        : ListView.builder(
          itemCount: _words.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_words[index].word),
              subtitle: Text(_words[index].wordMeaning, overflow: TextOverflow.ellipsis,),
              onTap: () {
                // 단어를 탭하면 상세 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordDetailPage(word: _words[index]),
                  ),
                );
              },
            );
          },
        ),
    );
  }
}

// 단어 상세 정보 페이지
class WordDetailPage extends StatelessWidget {
  final Word word;

  const WordDetailPage({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(word.word), // 앱바에 현재 단어 표시
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
