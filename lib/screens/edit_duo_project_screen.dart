import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/duo_project.dart';
import '../services/duo_project_service.dart';

/// Редактирование дуо-проекта (только для создателя).
class EditDuoProjectScreen extends StatefulWidget {
  final DuoProject project;

  const EditDuoProjectScreen({super.key, required this.project});

  @override
  State<EditDuoProjectScreen> createState() => _EditDuoProjectScreenState();
}

class _EditDuoProjectScreenState extends State<EditDuoProjectScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _typeCtrl;
  late final TextEditingController _shortCtrl;
  late final TextEditingController _fullCtrl;

  Uint8List? _coverBytes;
  DateTime _deadline = DateTime.now();
  double _teamSize = 4;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.project;
    _titleCtrl = TextEditingController(text: p.title);
    _typeCtrl = TextEditingController(text: p.type);
    _shortCtrl = TextEditingController(text: p.shortDescription);
    _fullCtrl = TextEditingController(text: p.fullDescription);
    _coverBytes = p.coverImageBytes;
    _deadline = p.deadline;
    _teamSize = p.teamSizeTarget.toDouble().clamp(2, 12);
  }

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

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    final short = _shortCtrl.text.trim();
    final full = _fullCtrl.text.trim();
    if (title.isEmpty || short.isEmpty || full.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните название и оба описания')),
      );
      return;
    }

    setState(() => _saving = true);
    final ok = await DuoProjectService.instance.updateProject(widget.project.id, {
      'title': title,
      'type': _typeCtrl.text.trim().isEmpty ? 'Проект' : _typeCtrl.text.trim(),
      'shortDescription': short,
      'fullDescription': full,
      'deadline': Timestamp.fromDate(_deadline),
      'teamSizeTarget': _teamSize.round().clamp(2, 20),
      // coverImageBase64 обновляется через saveProject обычно, но здесь оставим как есть:
      // в сервисе уже ограничение по размеру, поэтому отправим через saveProject, если меняли картинку.
    });

    if (!mounted) return;
    setState(() => _saving = false);

    if (ok) {
      // Если обновили обложку, используем saveProject чтобы записать coverImageBase64 с лимитом.
      if (_coverBytes != widget.project.coverImageBytes) {
        final updated = DuoProject(
          id: widget.project.id,
          title: title,
          type: _typeCtrl.text.trim().isEmpty ? 'Проект' : _typeCtrl.text.trim(),
          shortDescription: short,
          fullDescription: full,
          deadline: _deadline,
          teamSizeTarget: _teamSize.round().clamp(2, 20),
          memberUids: widget.project.memberUids,
          participantNames: widget.project.participantNames,
          coverImageBytes: _coverBytes,
          creatorUid: widget.project.creatorUid,
        );
        await DuoProjectService.instance.saveProject(updated);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Изменения в проекте сохранены'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось сохранить изменения'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _delete() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2235),
        title: const Text('Удалить проект?', style: TextStyle(color: Colors.white)),
        content: const Text('Действие необратимо.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Отмена')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Удалить', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (yes != true) return;
    setState(() => _saving = true);
    final ok = await DuoProjectService.instance.deleteProject(widget.project.id);
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Проект удалён'), behavior: SnackBarBehavior.floating),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось удалить проект'), behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141824),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1D2E),
        foregroundColor: Colors.white,
        title: const Text('Редактировать'),
        actions: [
          IconButton(
            onPressed: _saving ? null : _delete,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
      body: AbsorbPointer(
        absorbing: _saving,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                      const Icon(Icons.event_rounded, color: Color(0xFF2DD4BF), size: 22),
                      const SizedBox(width: 12),
                      Text(
                        '${_deadline.day.toString().padLeft(2, '0')}.'
                        '${_deadline.month.toString().padLeft(2, '0')}.'
                        '${_deadline.year}',
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
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
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                      Text('включая тебя', style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 12)),
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
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                    : const Text('Сохранить', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
          ],
        ),
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

