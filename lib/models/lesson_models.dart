/// Состояние урока в списке курса
enum LessonStatus {
  locked,
  available,
  inProgress,
  completed,
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  String optionText(int index) => options[index];
}

/// Один урок: теория, блоки про ПО и установку, список вопросов (обычно 10)
class LessonDefinition {
  final String id;
  final String title;
  final String theory;
  final String softwareSection;
  final String installationGuide;
  final List<QuizQuestion> questions;

  const LessonDefinition({
    required this.id,
    required this.title,
    required this.theory,
    required this.softwareSection,
    required this.installationGuide,
    required this.questions,
  });

  /// Порог зачёта урока: не менее 70% верных ответов
  bool isPassingScore(int correctCount) {
    if (questions.isEmpty) return false;
    return correctCount >= (questions.length * 0.7).ceil();
  }
}
