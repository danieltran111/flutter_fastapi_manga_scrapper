// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:manga_flutter/consts/constants.dart';
import 'package:manga_flutter/widgets/MangaInfoButtons.dart';

class MangaInfo extends StatelessWidget {
  final String img;

  const MangaInfo({super.key, required this.img});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      width: double.infinity,
      color: Constants.darkgray,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: 300,
                    width: 250,
                    child: Image.network(
                      img,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    "By me",
                    style: TextStyle(
                      color: Colors.amber.shade700,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            // color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MangaInfoButtons(
                    icon: Icons.play_arrow_outlined, title: "Read"),
                MangaInfoButtons(
                    icon: Icons.format_list_bulleted, title: "Chapters"),
                MangaInfoButtons(
                    icon: Icons.favorite_border_outlined, title: "Favorite"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
