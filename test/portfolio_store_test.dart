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
        description: 'Hackathon',
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
}
