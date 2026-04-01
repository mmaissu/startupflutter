import 'package:flutter/material.dart';

import '../models/lesson_models.dart';

/// Итоги теста: верно/неверно, зачёт от 70%, список ошибок.
class QuizResultsScreen extends StatelessWidget {
  final LessonDefinition lesson;
  final List<int?> selectedIndices;

  const QuizResultsScreen({
    super.key,
    required this.lesson,
    required this.selectedIndices,
  });

  int get _correct {
    var n = 0;
    for (var i = 0; i < lesson.questions.length; i++) {
      if (selectedIndices[i] == lesson.questions[i].correctIndex) n++;
    }
    return n;
  }

  int get _wrong => lesson.questions.length - _correct;

  bool get _passed => lesson.isPassingScore(_correct);

  List<int> get _wrongQuestionIndices {
    final list = <int>[];
    for (var i = 0; i < lesson.questions.length; i++) {
      if (selectedIndices[i] != lesson.questions[i].correctIndex) list.add(i);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final mistakes = _wrongQuestionIndices;
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Результат теста',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 12),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _StatChip(
                      label: 'Верно',
                      value: '$_correct',
                      color: const Color(0xFF2DD4BF),
                    ),
                    const SizedBox(width: 10),
                    _StatChip(
                      label: 'Неверно',
                      value: '$_wrong',
                      color: const Color(0xFFF87171),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _passed ? Icons.check_circle_rounded : Icons.cancel_rounded,
                        color: _passed ? const Color(0xFF2DD4BF) : const Color(0xFFF87171),
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _passed
                              ? 'Урок засчитан (не менее 70% верных ответов).'
                              : 'Набери не менее 70% верных ответов, чтобы засчитать урок.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.92),
                            fontSize: 14,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: mistakes.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Ошибок нет — отличная работа.',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    children: [
                      Text(
                        'Где ошибся',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...mistakes.map((qi) {
                        final q = lesson.questions[qi];
                        final userIdx = selectedIndices[qi];
                        final userText = userIdx == null ? '— не выбран ответ' : q.optionText(userIdx);
                        final correctText = q.optionText(q.correctIndex);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  q.question,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Твой ответ: $userText',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.75),
                                    fontSize: 13,
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Верно: $correctText',
                                  style: const TextStyle(
                                    color: Color(0xFF2DD4BF),
                                    fontSize: 13,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(context, _passed),
                child: const Text('Готово', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
