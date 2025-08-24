import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/word.dart';

class WordsViewModel extends ChangeNotifier {
  List<Word> _userWords = [];
  List<Word> _allWords = [];
  List<Word> get userWords => _userWords;
  List<Word> get allWords => _allWords;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 전체 단어와 유저 모르는 단어를 동시에 로드
  Future<void> loadAllWordsAndUserWords() async {
    _isLoading = true;
    notifyListeners();

    // 1전체 단어 로드
    final String allWordsString =
    await rootBundle.loadString('assets/datas/voca_all.json');
    final Map<String, dynamic> allWordsMap = json.decode(allWordsString);

    _allWords = allWordsMap.entries
        .map((e) => Word.fromJson(e.key, e.value as Map<String, dynamic>))
        .toList();

    // 2유저 모르는 단어 로드
    final String userWordsString =
    await rootBundle.loadString('assets/datas/user_unknown_words.json');
    final List<dynamic> userWordKeys = json.decode(userWordsString);

    _userWords = userWordKeys
        .where((key) => allWordsMap.containsKey(key))
        .map((key) =>
        Word.fromJson(key as String, allWordsMap[key] as Map<String, dynamic>))
        .toList();

    _isLoading = false;
    notifyListeners();
  }

  void toggleUserWord(String word) {
    final index = _userWords.indexWhere((w) => w.word == word);
    if (index >= 0) {
      _userWords.removeAt(index);
    } else {
      final newWord = _allWords.firstWhere((w) => w.word == word);
      _userWords.add(newWord);
    }
    notifyListeners();
  }
}
