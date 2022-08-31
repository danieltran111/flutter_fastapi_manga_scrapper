// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:manga_flutter/consts/constants.dart';

class MangaDescription extends StatefulWidget {
  final String mangaDesc;

  const MangaDescription({super.key, required this.mangaDesc});

  @override
  State<MangaDescription> createState() => _MangaDescriptionState();
}

class _MangaDescriptionState extends State<MangaDescription> {
  bool readMore = false;

  void toggleRead() {
    setState(() {
      readMore = !readMore;
    });
  }

  Widget overMultiLine() {
    return (widget.mangaDesc.trim()).split(" ").length > 1
        ? GestureDetector(
            onTap: toggleRead,
            child: Text(
              readMore ? "Read less" : "Read more",
              style: TextStyle(
                color: Constants.lightblue,
                fontSize: 14,
              ),
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          Text(
            widget.mangaDesc,
            style: TextStyle(
              color: Colors.white,
            ),
            maxLines: readMore ? 100 : 3,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.ellipsis,
          ),
          overMultiLine(),
        ],
      ),
    );
  }
}
