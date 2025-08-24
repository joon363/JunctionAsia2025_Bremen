class Word {
  final String word;
  final String wordMeaning;
  final String exampleEng;
  final String exampleKor;
  final String? lastViewTimestamp;

  Word({
    required this.word,
    required this.wordMeaning,
    required this.exampleEng,
    required this.exampleKor,
    this.lastViewTimestamp,
  });

  // JSON에서 word를 key로 관리할 경우, value만 전달됨
  factory Word.fromJson(String wordKey, Map<String, dynamic> json) {
    return Word(
      word: wordKey, // key가 word이므로 여기서 받음
      wordMeaning: json['word_meaning'] ?? "",
      exampleEng: json['example']['example_eng'] ?? "",
      exampleKor: json['example']['example_kor'] ?? "",
      lastViewTimestamp: json['last_view_timestamp'],
    );
  }
}
