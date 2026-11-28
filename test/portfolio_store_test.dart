import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/data/portfolio_store.dart';
import 'package:myportofolio_mobile/models/achievement.dart';
import 'package:myportofolio_mobile/models/education.dart';

void main() {
  final store = PortfolioStore.instance;

  setUp(store.clear);

  test('addEducation menambah data dan memberi tahu listener', () {
    var notified = 0;
    store.educations.addListener(() => notified++);

    store.addEducation(
      Education(
        institution: 'Universitas Indonesia',
        degree: 'S1 - Ilmu Komputer',
        startDate: DateTime(2023, 9, 1),
        endDate: DateTime(2027, 6, 1),
        period: '1 Sep 2023 - 1 Jun 2027',
      ),
    );

    expect(store.educations.value, hasLength(1));
    expect(store.educations.value.first.institution, 'Universitas Indonesia');
    expect(notified, 1);
  });

  test('addAchievement dan addExperience menambah jumlah', () {
    store.addAchievement(
      const Achievement(
        title: 'Juara 1',
        period: '5 Nov 2026',
        description: 'Mencintai Diri Sendiri',
        category: AchievementCategory.competition,
      ),
    );
    store.addExperience();
    store.addExperience();

    expect(store.achievements.value, hasLength(1));
    expect(store.experienceCount.value, 2);
  });

  test('clear mengosongkan semua data', () {
    store.addExperience();
    store.clear();

    expect(store.educations.value, isEmpty);
    expect(store.achievements.value, isEmpty);
    expect(store.experienceCount.value, 0);
  });

  test('updateEducation mengganti item di posisi yang sama', () {
    final old = Education(
      institution: 'UI',
      degree: 'S1 - Ilmu Komputer',
      startDate: DateTime(2023, 9, 1),
      period: 'Sep 2023',
    );
    final other = Education(
      institution: 'SMA 8',
      degree: 'SMA',
      startDate: DateTime(2020, 7, 1),
      period: 'Jul 2020',
    );
    store
      ..addEducation(old)
      ..addEducation(other);

    final updated = Education(
      institution: 'Universitas Indonesia',
      degree: 'S1 - Ilmu Komputer',
      startDate: DateTime(2023, 9, 1),
      period: 'Sep 2023',
    );
    store.updateEducation(old, updated);

    expect(store.educations.value, hasLength(2));
    expect(store.educations.value.first.institution, 'Universitas Indonesia');
    expect(store.educations.value.last.institution, 'SMA 8');
  });

  test('updateEducation mengabaikan item yang tidak ada', () {
    final ghost = Education(
      institution: 'X',
      degree: 'S1',
      startDate: DateTime(2023, 9, 1),
      period: 'Sep 2023',
    );
    store.updateEducation(ghost, ghost);

    expect(store.educations.value, isEmpty);
  });

  test('toggleFavorite menambah lalu menghapus favorit', () {
    final e = Education(
      institution: 'UI',
      degree: 'S1',
      startDate: DateTime(2023, 9, 1),
      period: 'Sep 2023',
    );

    store.toggleFavorite(e);
    expect(store.isFavorite(e), isTrue);
    expect(store.favorites.value, hasLength(1));

    store.toggleFavorite(e);
    expect(store.isFavorite(e), isFalse);
    expect(store.favorites.value, isEmpty);
  });

  test('updateEducation memindahkan status favorit ke versi baru', () {
    final old = Education(
      institution: 'UI',
      degree: 'S1',
      startDate: DateTime(2023, 9, 1),
      period: 'Sep 2023',
    );
    final updated = Education(
      institution: 'Universitas Indonesia',
      degree: 'S1',
      startDate: DateTime(2023, 9, 1),
      period: 'Sep 2023',
    );
    store
      ..addEducation(old)
      ..toggleFavorite(old)
      ..updateEducation(old, updated);

    expect(store.isFavorite(old), isFalse);
    expect(store.isFavorite(updated), isTrue);
  });
}
