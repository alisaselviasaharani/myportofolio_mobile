import 'package:flutter/material.dart';

/// Kategori experience, sama dengan `EXPERIENCE_CHOICES` pada model Django.
///
/// Label dan warna disimpan di enum agar tampilan chip kategori tidak
/// membutuhkan switch/if-else di widget.
enum ExperienceCategory {
  internship('Internship', Colors.indigo),
  research('Research', Colors.teal),
  volunteer('Volunteer', Colors.pink),
  partTime('Part-Time', Colors.orange),
  fullTime('Full-Time', Colors.blue),
  freelance('Freelance', Colors.purple);

  final String label;
  final Color color;

  const ExperienceCategory(this.label, this.color);
}

/// Satu item pengalaman pada portofolio.
class Experience {
  final String title;
  final String institution;
  final String period;
  final String description;
  final ExperienceCategory category;

  const Experience({
    required this.title,
    required this.institution,
    required this.period,
    required this.description,
    required this.category,
  });
}
