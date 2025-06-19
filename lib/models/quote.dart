class Quote {
  final String id;
  final String text;
  final String author;

  Quote({
    required this.id,
    required this.text,
    required this.author,
  });

  factory Quote.fromMap(Map<String, dynamic> map, String id) {
    return Quote(
      id: id,
      text: map['text'] ?? '',
      author: map['author'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'author': author,
    };
  }
} 