import 'package:flutter/foundation.dart';
import 'package:myportofolio_mobile/models/experience.dart';

/// Penyimpanan experience di memori (belum terhubung ke API Django).
///
/// Daftar dibungkus [ValueNotifier] supaya halaman daftar otomatis
/// diperbarui ketika item baru ditambahkan dari halaman form.
class ExperienceRepository {
  final ValueNotifier<List<Experience>> experiences = ValueNotifier(
    List<Experience>.unmodifiable(_seed),
  );

  /// Menambahkan item baru di urutan paling atas.
  void add(Experience experience) {
    experiences.value = List<Experience>.unmodifiable([
      experience,
      ...experiences.value,
    ]);
  }

  // Data awal diambil dari portofolio web (portfolio_data.json).
  static const List<Experience> _seed = [
    Experience(
      title: 'Vice Chairperson of IT Club 65',
      institution: 'SMAN 65 Jakarta',
      period: '2024 - 2025',
      description:
          'Assisted in coordinating IT Club activities and supporting '
          'members in learning and developing their technology skills.',
      category: ExperienceCategory.partTime,
    ),
    Experience(
      title: 'Active Participant - Young Health Program',
      institution: 'Young Health Programme (YHP)',
      period: '2023 - 2025',
      description:
          'Actively participated as a youth health cadre in health '
          'education and disease prevention campaigns.',
      category: ExperienceCategory.volunteer,
    ),
    Experience(
      title: 'Math Club Chairperson',
      institution: 'MTSN 12 Jakarta',
      period: '2019 - 2022',
      description:
          'Led the Math Club and organized activities to help members '
          'improve their mathematics skills.',
      category: ExperienceCategory.partTime,
    ),
  ];
}

/// Instance tunggal yang dipakai bersama oleh halaman daftar dan form.
final ExperienceRepository experienceRepository = ExperienceRepository();
