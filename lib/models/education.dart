enum DegreeLevel {
  highSchool('SMA'),
  diploma('D3'),
  bachelor('S1'),
  master('S2'),
  doctor('S3'),
  smp('MTS');

  const DegreeLevel(this.label);

  final String label;
}

class Education {
  const Education({
    this.id,
    required this.institution,
    required this.degree,
    required this.period,
    this.startDate,
    this.endDate,
    this.logo = '',
    this.website = '',
  });

  final String? id;
  final String institution;
  final String degree;
  final String period;
  final DateTime? startDate;
  final DateTime? endDate;
  final String logo;
  final String website;

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id']?.toString(),
      institution: json['institution']?.toString() ?? '',
      degree: json['degree']?.toString() ?? '',
      period: json['period']?.toString() ?? '',
      logo: json['logo']?.toString() ?? '',
      website: json['website']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'institution': institution,
      'degree': degree,
      'period': period,
      'logo': logo,
      'website': website,
    };
  }
}
