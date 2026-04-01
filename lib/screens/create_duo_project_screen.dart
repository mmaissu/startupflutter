import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/duo_project.dart';

/// Экран создания дуо-проекта: фото, срок, размер команды, описания
class CreateDuoProjectScreen extends StatefulWidget {
  const CreateDuoProjectScreen({super.key});

  @override
  State<CreateDuoProjectScreen> createState() => _CreateDuoProjectScreenState();
}

class _CreateDuoProjectScreenState extends State<CreateDuoProjectScreen> {
  final _titleCtrl = TextEditingController();
  final _typeCtrl = TextEditingController();
  final _shortCtrl = TextEditingController();
  final _fullCtrl = TextEditingController();

  Uint8List? _coverBytes;
  DateTime _deadline = DateTime.now().add(const Duration(days: 14));
  double _teamSize = 4;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _typeCtrl.dispose();
    _shortCtrl.dispose();
    _fullCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 88,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() => _coverBytes = bytes);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF6A63FF),
              surface: Color(0xFF252A3F),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  void _submit() {
    final title = _titleCtrl.text.trim();
    final short = _shortCtrl.text.trim();
    final full = _fullCtrl.text.trim();
    if (title.isEmpty || short.isEmpty || full.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните название и оба описания')),
      );
      return;
    }
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final project = DuoProject(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      type: _typeCtrl.text.trim().isEmpty ? 'Проект' : _typeCtrl.text.trim(),
      shortDescription: short,
      fullDescription: full,
      deadline: _deadline,
      teamSizeTarget: _teamSize.round().clamp(2, 20),
      participantNames: const ['Вы'],
      coverImageBytes: _coverBytes,
      creatorUid: uid,
    );
    Navigator.pop(context, project);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141824),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            stretch: true,
            backgroundColor: const Color(0xFF1A1D2E),
            leading: IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Новый проект',
                style: TextStyle(fontWeight: FontWeight.w700, shadows: [Shadow(blurRadius: 8, color: Colors.black54)]),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF6A63FF).withValues(alpha: 0.9),
                          const Color(0xFFFF5AA5).withValues(alpha: 0.75),
                          const Color(0xFF141824),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                  if (_coverBytes != null)
                    Image.memory(
                      _coverBytes!,
                      fit: BoxFit.cover,
                      color: Colors.black.withValues(alpha: 0.35),
                      colorBlendMode: BlendMode.darken,
                    ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Text(
                      'Добавь обложку, срок и команду',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _pickImage,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _coverBytes == null ? Icons.add_photo_alternate_rounded : Icons.edit_rounded,
                              color: const Color(0xFF9D97FF),
                              size: 36,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _coverBytes == null ? 'Загрузить обложку' : 'Изменить фото',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'JPG, PNG — по желанию',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _label('Название'),
                  _field(_titleCtrl, 'Например: Бот для расписания'),
                  const SizedBox(height: 14),
                  _label('Направление'),
                  _field(_typeCtrl, 'Python · Боты, UI/UX…'),
                  const SizedBox(height: 14),
                  _label('Кратко о задаче'),
                  _field(_shortCtrl, 'Одно–два предложения', maxLines: 2),
                  const SizedBox(height: 14),
                  _label('Полное описание'),
                  _field(_fullCtrl, 'Роли, стек, ожидания…', maxLines: 5),
                  const SizedBox(height: 20),
                  _label('Срок сдачи'),
                  const SizedBox(height: 8),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                          color: Colors.white.withValues(alpha: 0.07),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2DD4BF).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.event_rounded, color: Color(0xFF2DD4BF), size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_deadline.day.toString().padLeft(2, '0')}.'
                                    '${_deadline.month.toString().padLeft(2, '0')}.'
                                    '${_deadline.year}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'Нажми, чтобы изменить',
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.calendar_month_rounded, color: Colors.white.withValues(alpha: 0.5)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  _label('Сколько человек в команде'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                      color: Colors.white.withValues(alpha: 0.07),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_teamSize.round()} чел.',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'включая тебя',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 12),
                            ),
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: const Color(0xFF6A63FF),
                            inactiveTrackColor: Colors.white.withValues(alpha: 0.12),
                            thumbColor: Colors.white,
                            overlayColor: const Color(0xFF6A63FF).withValues(alpha: 0.25),
                          ),
                          child: Slider(
                            min: 2,
                            max: 12,
                            divisions: 10,
                            value: _teamSize,
                            onChanged: (v) => setState(() => _teamSize = v),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _submit,
                      child: const Text('Опубликовать проект', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _label(String t) {
    return Text(
      t,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.55),
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _field(TextEditingController c, String hint, {int maxLines = 1}) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.07),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF6A63FF), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
