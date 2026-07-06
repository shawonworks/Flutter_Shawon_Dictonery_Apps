class IeltsTopic {
  final String id;
  final String title;
  final String icon; // Material icon name, mapped in UI

  const IeltsTopic({required this.id, required this.title, required this.icon});

  factory IeltsTopic.fromJson(Map<String, dynamic> json) {
    return IeltsTopic(id: json['id'] as String, title: json['title'] as String, icon: json['icon'] as String);
  }
}