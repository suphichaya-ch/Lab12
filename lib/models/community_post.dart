class CommunityPost {
  int? id;
  String title;
  String detail;
  String category;

  CommunityPost({
    this.id,
    required this.title,
    required this.detail,
    required this.category,
  });

  factory CommunityPost.fromMap(Map<String, dynamic> map) {
    return CommunityPost(
      id: map['id'],
      title: map['title'],
      detail: map['detail'],
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'detail': detail,
      'category': category,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}