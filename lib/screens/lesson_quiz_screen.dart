import 'package:flutter/material.dart';

import '../models/lesson_models.dart';
import 'quiz_results_screen.dart';

/// Тест урока: все вопросы подряд, затем экран результатов.
class LessonQuizScreen extends StatefulWidget {
  final LessonDefinition lesson;

  const LessonQuizScreen({
    super.key,
    required this.lesson,
  });

  @override
  State<LessonQuizScreen> createState() => _LessonQuizScreenState();
}

class _LessonQuizScreenState extends State<LessonQuizScreen> {
  late List<int?> _answers;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _answers = List<int?>.filled(widget.lesson.questions.length, null);
  }

  List<QuizQuestion> get _questions => widget.lesson.questions;

  QuizQuestion get _q => _questions[_index];

  int? get _selected => _answers[_index];

  void _setSelected(int i) {
    setState(() => _answers[_index] = i);
  }

  Future<void> _goNext() async {
    if (_selected == null) return;
    if (_index < _questions.length - 1) {
      setState(() => _index++);
      return;
    }
    final passed = await Navigator.push<bool?>(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultsScreen(
          lesson: widget.lesson,
          selectedIndices: List<int?>.from(_answers),
        ),
      ),
    );
    if (!mounted) return;
    // null — вернулись с экрана результатов «Назад», остаёмся в тесте
    if (passed == null) return;
    Navigator.pop(context, passed);
  }

  void _goBack() {
    if (_index > 0) {
      setState(() => _index--);
    } else {
      // null — вышли из теста без результата (не путать с «тест провален»)
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _questions.length;
    final q = _q;
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: _goBack,
        ),
        title: Text(
          'Вопрос ${_index + 1} из $total',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.lesson.title,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 12),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (_index + 1) / total,
                minHeight: 6,
                backgroundColor: Colors.white.withValues(alpha: 0.12),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white70),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              q.question,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ...List.generate(q.options.length, (i) {
                    final selected = _selected == i;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _setSelected(i),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: selected ? Colors.white.withValues(alpha: 0.14) : Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: selected ? Colors.white.withValues(alpha: 0.45) : Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                                    color: selected ? Colors.white.withValues(alpha: 0.2) : null,
                                  ),
                                  child: selected
                                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    q.options[i],
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.92),
                                      fontSize: 14,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _selected == null ? null : _goNext,
                child: Text(
                  _index < total - 1 ? 'Далее' : 'Завершить и посмотреть результат',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
