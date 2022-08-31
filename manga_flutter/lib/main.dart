// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:manga_flutter/screens/DetailScreen.dart';
import 'package:manga_flutter/screens/HomeScreen.dart';
import 'package:manga_flutter/screens/ReadingScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // home: HomeScreen(),
      // home: DetailScreen(
      //     img: 'lib/assets/mangaCoverImages/59006.jpg',
      //     title: "haha",
      //     link: "/13907/ookami-to-koushinryou-13907",
      //     id: "59006"),
      home: ReadingScreen(
        mangaId: 67612,
        chapterId: 892205,
      ),
      // home: Image.asset("lib/assets/mangaCoverImages/61131.jpg"),
      // home:
    );
  }
}
