import 'package:flutter/material.dart';
import 'package:manga_flutter/consts/constants.dart';

class MangaInfoButtons extends StatelessWidget {
  final IconData icon;
  final String title;

  const MangaInfoButtons({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: Constants.lightblue,
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
