import 'package:flutter_test/flutter_test.dart';
import 'package:review_spc_clean/models/game_progress.dart';
import 'package:review_spc_clean/views/quiz_take_view.dart';

void main() {
  test(
    'recordQuizCompletion stores final accuracy and anti-cheat adjusted XP',
    () {
      final before = GameProgressStore.instance.progress;

      GameProgressStore.instance.recordQuizCompletion(
        accuracyPercent: 92,
        xpEarned: 140,
        antiCheatPenalty: 40,
        antiCheatWarnings: 2,
        wasUnderTwoMinutes: true,
      );

      final after = GameProgressStore.instance.progress;

      expect(after.quizzesCompleted, before.quizzesCompleted + 1);
      expect(after.accuracyMasterCount, before.accuracyMasterCount + 1);
      expect(after.xp, before.xp + 100);
      expect(after.level >= before.level, isTrue);
    },
  );

  test('fill blank answers accept the expected terms', () {
    expect(
      QuizTakeView.isFillBlankAnswerCorrect('Liabilities', const [
        'liabilities',
        'liability',
      ]),
      isTrue,
    );
    expect(
      QuizTakeView.isFillBlankAnswerCorrect('equity', const [
        'liabilities',
        'equity',
      ]),
      isTrue,
    );
  });
}
