class Snippet {
  final int? id;
  final String title;
  final String content;
  final int createdAt;
  final int updatedAt;

  const Snippet({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Snippet copyWith({
    int? id,
    String? title,
    String? content,
    int? createdAt,
    int? updatedAt,
  }) {
    return Snippet(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Snippet.fromMap(Map<String, Object?> map) {
    return Snippet(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
  }
}
