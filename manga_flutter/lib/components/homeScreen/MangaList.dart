// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:manga_flutter/components/homeScreen/MangaCard.dart';
import 'package:manga_flutter/consts/constants.dart';
import 'package:manga_flutter/models/manga.dart';

class MangaList extends StatelessWidget {
  final List<Manga> mangaList;
  final List<Map<String, dynamic>> mangaUrlList;
  const MangaList(
      {super.key, required this.mangaList, required this.mangaUrlList});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height,
      width: double.infinity,
      color: Constants.black,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Wrap(
          children: [
            Container(
              width: double.infinity,
              height: 30,
              alignment: Alignment.centerLeft,
              child: Text("${mangaList.length.toString()} mangas"),
            ),
            for (int i = 0; i < mangaList.length; i++)
              MangaCard(
                image: mangaList[i].image,
                title: mangaList[i].fullName,
                url: mangaUrlList[i]['attributes']['href'],
                id: (mangaList[i].id).toString(),
              ),
          ],
        ),
      ),
    );
  }
}
