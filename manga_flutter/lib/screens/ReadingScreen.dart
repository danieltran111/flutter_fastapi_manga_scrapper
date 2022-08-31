import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:manga_flutter/models/chapter_detail.dart';
import 'package:http/http.dart' as http;

class ReadingScreen extends StatefulWidget {
  final int mangaId, chapterId;
  const ReadingScreen(
      {Key? key, required this.mangaId, required this.chapterId})
      : super(key: key);

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  late List<ChapterDetail> chapter_details;
  late ChapterDetail currentChapter;
  bool loaded = false;

  void getChaptersInfo() async {
    var response = await http.get(Uri.parse(
        "http://127.0.0.1:8000/mangas/${widget.mangaId}/${widget.chapterId}"));
    // chapter_details = parseChapterDetails(response.body);
    currentChapter = ChapterDetail.fromJson(jsonDecode(response.body));
    print(currentChapter.images);
    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getChaptersInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loaded
          ? Container(
              child: ListView.builder(
                  itemCount: currentChapter.images.length,
                  itemBuilder: (context, index) {
                    return Image.network(currentChapter.images[index]);
                  }),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
