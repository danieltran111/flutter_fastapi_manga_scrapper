// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:manga_flutter/components/homeScreen/MangaCard.dart';
import 'package:manga_flutter/components/homeScreen/MangaList.dart';
import 'package:manga_flutter/consts/constants.dart';
import 'package:manga_flutter/models/manga.dart';
import 'package:manga_flutter/widgets/BottomNavItem.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedNavIndex = 0;

  bool mangaLoaded = false;
  late List<Map<String, dynamic>> mangaList;
  late List<Map<String, dynamic>> mangaUrlList;

  late List<Manga> mangaLs;
  void navBarTap(int index) {
    setState(() {
      selectedNavIndex = index;
    });
  }

  List<Manga> parseMangas(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Manga>((json) => Manga.fromJson(json)).toList();
  }

  void fetchManga() async {
    final webScraper = WebScraper(Constants.baseUrl);

    if (await webScraper.loadWebPage('')) {
      // mangaList = webScraper.getElement(
      //   'div.bg-white.storyitem > div.fl-l > a > img',
      //   ['src', 'alt'],
      // );

      mangaUrlList = webScraper.getElement(
        'div.bg-white.storyitem > div.fl-l > a',
        ['href'],
      );

      // setState(() {
      //   mangaLoaded = true;
      // });
    }
    var response = await http.get(Uri.parse("http://127.0.0.1:8000/mangas/"));
    // print(parseMangas(response.body).toList()[0].id);
    mangaLs = parseMangas(response.body).toList();
    print(mangaLs[0].pprint());
    setState(() {
      mangaLoaded = true;
      // print()
    });
  }

  @override
  void initState() {
    super.initState();
    fetchManga();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Reader"),
        backgroundColor: Constants.darkgray,
        // flexibleSpace: GestureDetector(
        //   onTap: fetchManga,
        // ),
      ),
      body: mangaLoaded
          // ? MangaList(
          //     mangaList: mangaList,
          //     mangaUrlList: mangaUrlList,
          //   )
          ? MangaList(
              mangaList: mangaLs,
              mangaUrlList: mangaUrlList,
            )
          // ? Center(child: CircularProgressIndicator())
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Constants.darkgray,
        selectedItemColor: Constants.lightblue,
        unselectedItemColor: Colors.white,
        currentIndex: selectedNavIndex,
        onTap: navBarTap,
        items: [
          bottomNavItem(Icons.explore_outlined, "EXPLORE"),
          bottomNavItem(Icons.favorite, "EXPLORE"),
          bottomNavItem(Icons.watch_later, "EXPLORE"),
          bottomNavItem(Icons.more_horiz, "MORE"),
        ],
      ),
    );
  }
}
