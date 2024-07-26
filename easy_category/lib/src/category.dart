class Category {
  final String id;
  final String name;
  final String? description;

  /// May be used for no of posts, no of users in the group, etc.
  final int itemCount;

  /// May be used for no of comemnts or no of reviews of the category, etc.
  final int feedCount;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.itemCount = 0,
    this.feedCount = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      itemCount: json['itemCount'] ?? 0,
      feedCount: json['feedCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'itemCount': itemCount,
      'feedCount': feedCount,
    };
  }
}
