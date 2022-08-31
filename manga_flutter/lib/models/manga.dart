import 'dart:convert';

import 'chapter.dart';

class Manga {
  final int id;
  final String image;
  final String fullName;
  final List<String> tags;
  final String description;
  final List<Chapter> chapters;

  const Manga({
    required this.id,
    required this.image,
    required this.fullName,
    required this.tags,
    required this.description,
    required this.chapters,
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    // tags = json['tags']
    List<Chapter> all = [];
    if (json['chapters'] != null) {
      // chapters = new List<Chapter>;
      json['chapters'].forEach((v) {
        all.add(Chapter.fromJson(v));
      });
    }
    return Manga(
      id: json['id'],
      image: json['image'],
      fullName: json['fullname'],
      tags: List<String>.from(json['tags']),
      description: json['description'],
      chapters: all,
    );
  }

  pprint() {
    print("id: ${id}");
    print("name: $fullName");
    print("img: $image");
  }
}

List<Manga> parseMangas(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Manga>((json) => Manga.fromJson(json)).toList();
}
