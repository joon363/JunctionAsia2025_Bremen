import 'package:flutter/material.dart';
import 'package:reelstudy/theme.dart';
import 'package:provider/provider.dart';
import '../viewmodels/words_view_model.dart';

class WordListPage extends StatefulWidget {
  const WordListPage({super.key});

  @override
  State<WordListPage> createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {

  @override
  Widget build(BuildContext context) {
    final wordsVM = context.watch<WordsViewModel>();
    final userWords = wordsVM.userWords;

    return Scaffold(
      appBar: AppBar(
        title: Text('WordBook',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black
          ),
        ),
      ),
      body: userWords.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Column(
          children: [
            Column(
              children: [
                Divider(thickness: 0.5,),
                Text("단어 수: 187개", style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Divider(thickness: 0.5,),

              ],
            ),
            Expanded(child: ListView.builder(
                itemCount: userWords.length,
                itemBuilder: (context, index) {
                  return Material(
                    elevation: 5,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: index < 3 ? primaryMediumBlue : primaryLightBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(userWords[index].word, style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(userWords[index].lastViewTimestamp ?? "", style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(userWords[index].wordMeaning, overflow: TextOverflow.ellipsis,),
                        onTap: () {
                          showDialog(context: context, builder: (dialogContext) =>
                            AlertDialog(
                              backgroundColor: Colors.white,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 4,
                                children: [
                                  Text(userWords[index].word, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                                  Divider(),
                                  Text("뜻"),
                                  Text(userWords[index].wordMeaning),
                                  Divider(),
                                  Text("예문", style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("• ${userWords[index].exampleEng}"),
                                  Text("• ${userWords[index].exampleKor}"),
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

