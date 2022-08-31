import 'dart:convert';

class Chapter {
  final int id;
  final String name;

  const Chapter({
    required this.id,
    required this.name,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      name: json['name'],
    );
  }
}

List<Chapter> parseChapters(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Chapter>((json) => Chapter.fromJson(json)).toList();
}
