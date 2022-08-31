// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:manga_flutter/components/detailScreen/MangaChapters.dart';
import 'package:manga_flutter/components/detailScreen/MangaDescription.dart';
import 'package:manga_flutter/components/detailScreen/MangaInfo.dart';
import 'package:manga_flutter/consts/constants.dart';
import 'package:manga_flutter/widgets/HorizontalDivider.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:http/http.dart' as http;
import 'package:manga_flutter/models/manga.dart';

class DetailScreen extends StatefulWidget {
  final String img, title, link;
  final String id;

  const DetailScreen({
    super.key,
    required this.img,
    required this.title,
    required this.link,
    required this.id,
  });

  // const DetailScreen({Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool loaded = false;
  late String mangaDesc;
  late List<Map<String, dynamic>> mangaDescs;
  late List<Map<String, dynamic>> mangaChapters;
  // late List<Map<String, dynamic>> mandaDescs;
  late Manga currentManga;
  void getMangaInfos() async {
    // String url = (Constants.baseUrl + widget.link);
    // // print(widget.link);
    // final webScraper = WebScraper(Constants.baseUrl);

    // //manga descriptions
    // if (await webScraper.loadWebPage(widget.link)) {
    //   mangaDescs = webScraper.getElement(
    //     'div.detail > div.content > div',
    //     [],
    //   );
    //   mangaDesc = mangaDescs[0]['title'];

    //   mangaChapters =
    //       webScraper.getElement('div.list-wrap > p > span > a', ['href']);

    //   // print(mangaChapters);
    // }
    var response =
        await http.get(Uri.parse("http://127.0.0.1:8000/mangas/${widget.id}"));
    currentManga = Manga.fromJson(jsonDecode(response.body));
    print(currentManga.image);
    setState(() {
      loaded = true;
    });

    //manga
    // print(mangaDescs[0]['title']);
  }

  @override
  void initState() {
    super.initState();
    getMangaInfos();
  }

// https://blogtruyen.vn//13907/ookami-to-koushinryou-13907
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Constants.lightgray,
      ),
      body: loaded
          ? Container(
              height: screenSize.height,
              width: screenSize.width,
              color: Constants.darkgray,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MangaInfo(
                      img: widget.img,
                    ),
                    HorizontalDivider(),
                    MangaDescription(
                      mangaDesc: currentManga.description,
                    ),
                    MangaChapters(
                      mangaChapters: currentManga.chapters,
                    ),
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
