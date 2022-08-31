import 'dart:convert';

class ChapterDetail {
  final int id;
  final String name;
  final List<dynamic> images;

  const ChapterDetail(
      {required this.id, required this.name, required this.images});

  factory ChapterDetail.fromJson(Map<String, dynamic> json) {
    return ChapterDetail(
      id: json['id'],
      name: json['name'],
      images: json['images'],
    );
  }
}

List<ChapterDetail> parseChapterDetails(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<ChapterDetail>((json) => ChapterDetail.fromJson(json))
      .toList();
}
