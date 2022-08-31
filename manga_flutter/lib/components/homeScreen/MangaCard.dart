// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:manga_flutter/consts/constants.dart';
import 'dart:io';

import 'package:manga_flutter/screens/DetailScreen.dart';

class MangaCard extends StatelessWidget {
  final String image, title, url, id;

  const MangaCard({
    super.key,
    required this.image,
    required this.title,
    required this.url,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 130,
      child: GestureDetector(
        onTap: () {
          print(image);
          print(title);
          print(url);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailScreen(
                      img: image, title: title, link: url, id: id)));
        },
        child: Column(
          children: [
            Expanded(
              flex: 70,
              child: Container(
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  // loadingBuilder: (context, child, loadingProgress) {
                  //   if (loadingProgress == null) return child;
                  //   return Center(
                  //     child: CircularProgressIndicator(),
                  //   );
                  // },
                ),
              ),
            ),
            Expanded(
              flex: 30,
              child: Container(
                alignment: Alignment.centerLeft,
                color: Constants.darkgray,
                child: Text(
                  title,
                  style: TextStyle(color: Colors.amber.shade50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
