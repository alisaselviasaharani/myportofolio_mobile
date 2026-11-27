enum AchievementCategory {
  academic('Academic'),
  competition('Competition'),
  certification('Certification'),
  award('Award'),
  other('Other');

  const AchievementCategory(this.label);

  final String label;
}

class Achievement {
  const Achievement({
    this.id,
    required this.title,
    required this.period,
    required this.description,
    required this.category,
    this.imageUrl = '',
  });

  final String? id;
  final String title;
  final String period;
  final String description;
  final AchievementCategory category;
  final String imageUrl;

  factory Achievement.fromJson(Map<String, dynamic> json) {
    final categoryValue = json['category']?.toString() ?? 'Other';

    final category = AchievementCategory.values.firstWhere(
      (item) => item.label.toLowerCase() == categoryValue.toLowerCase(),
      orElse: () => AchievementCategory.other,
    );

    return Achievement(
      id: json['id']?.toString(),
      title: json['title']?.toString() ?? '',
      period: json['period']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: category,
      imageUrl: json['achievements_image_url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'period': period,
      'description': description,
      'category': category.label,
      'achievements_image_url': imageUrl,
    };
  }
}
