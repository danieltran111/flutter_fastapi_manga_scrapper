import 'package:flutter/material.dart';
import 'package:manga_flutter/consts/constants.dart';
import 'package:manga_flutter/models/chapter.dart';

class MangaChapters extends StatelessWidget {
  final List<Chapter> mangaChapters;

  const MangaChapters({super.key, required this.mangaChapters});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: mangaChapters.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            height: 50,
            width: double.infinity,
            child: Material(
              color: Constants.lightgray,
              child: InkWell(
                onTap: () => print("${mangaChapters[index].id}"),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    mangaChapters[index].name,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
