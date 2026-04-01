import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../models/duo_project.dart';
import '../services/duo_project_service.dart';
import '../ui/app_background.dart';
import '../widgets/chat_tab_with_search.dart';
import '../widgets/glass_icon_button.dart';
import 'create_duo_project_screen.dart';
import 'duo_project_detail_screen.dart';

/// Страница «Сообщество» (Чат) — поиск, чаты и дуо-проекты
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  bool _segmentChats = true;

  List<DuoProject> _duoProjects = [];
  bool _loadingDuo = true;

  @override
  void initState() {
    super.initState();
    _loadDuoProjects();
  }

  Future<void> _loadDuoProjects() async {
    setState(() => _loadingDuo = true);
    final list = await DuoProjectService.instance.loadProjects();
    if (!mounted) return;
    setState(() {
      _duoProjects = list;
      _loadingDuo = false;
    });
  }

  List<DuoProject> get _sortedDuoProjects {
    final list = List<DuoProject>.from(_duoProjects);
    list.sort((a, b) {
      if (a.isCritical != b.isCritical) return a.isCritical ? -1 : 1;
      if (a.isUrgent != b.isUrgent) return a.isUrgent ? -1 : 1;
      return a.deadline.compareTo(b.deadline);
    });
    return list;
  }

  void _openProjectDetail(DuoProject project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DuoProjectDetailScreen(project: project),
      ),
    );
  }

  Future<void> _openCreateProject() async {
    final project = await Navigator.push<DuoProject>(
      context,
      MaterialPageRoute(builder: (context) => const CreateDuoProjectScreen()),
    );
    if (project == null || !mounted) return;
    final synced = await DuoProjectService.instance.saveProject(project);
    if (!mounted) return;
    if (!synced) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Проект сохранён локально. Не удалось отправить в облако — проверьте вход и правила Firestore для duo_projects.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Проект опубликован и сохранён'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    await _loadDuoProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    GlassIconButton(
                      icon: Icons.menu_rounded,
                      onTap: () => Scaffold.of(context).openDrawer(),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Чат',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
                const SizedBox(height: 12),
                _SegmentedTabs(
                  isChats: _segmentChats,
                  onChatsTap: () => setState(() => _segmentChats = true),
                  onDuoTap: () => setState(() => _segmentChats = false),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _segmentChats
                      ? const ChatTabWithSearch()
                      : ListView(
                          padding: EdgeInsets.zero,
                          children: _buildDuoProjectsContent(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDuoProjectsContent() {
    return [
      const SizedBox(height: 14),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xFF6A63FF), Color(0xFF915BFF)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6A63FF).withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: _openCreateProject,
            icon: const Icon(Icons.add_photo_alternate_rounded, size: 22),
            label: const Text('Создать свой проект', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Или присоединись к открытым проектам',
        style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 12),
      ),
      const SizedBox(height: 14),
      const Text(
        'Открытые дуо-проекты',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
      ),
      const SizedBox(height: 10),
      if (_loadingDuo)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(child: CircularProgressIndicator(color: Colors.white54)),
        )
      else if (_sortedDuoProjects.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: Text(
            'Пока нет открытых проектов. Нажми «Создать свой проект» — он сохранится и появится здесь после входа в аккаунт.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 13, height: 1.4),
          ),
        )
      else ...[
        for (final p in _sortedDuoProjects) ...[
          _DuoProjectCard(
            project: p,
            onTap: () => _openProjectDetail(p),
          ),
          const SizedBox(height: 12),
        ],
      ],
    ];
  }
}

class _SegmentedTabs extends StatelessWidget {
  final bool isChats;
  final VoidCallback onChatsTap;
  final VoidCallback onDuoTap;

  const _SegmentedTabs({
    required this.isChats,
    required this.onChatsTap,
    required this.onDuoTap,
  });

  @override
  Widget build(BuildContext context) {
    const h = 40.0;
    const r = 12.0;
    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onChatsTap,
              borderRadius: BorderRadius.circular(r),
              child: Container(
                height: h,
                decoration: BoxDecoration(
                  color: isChats ? Colors.white : Colors.white.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(r),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Чаты',
                  style: TextStyle(
                    color: isChats ? Colors.black : Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onDuoTap,
              borderRadius: BorderRadius.circular(r),
              child: Container(
                height: h,
                decoration: BoxDecoration(
                  color: !isChats ? Colors.white : Colors.white.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(r),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Дуо проекты',
                  style: TextStyle(
                    color: !isChats ? Colors.black : Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DuoProjectCard extends StatelessWidget {
  final DuoProject project;
  final VoidCallback onTap;

  const _DuoProjectCard({required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final critical = project.isCritical;
    final urgent = project.isUrgent;
    final slots = project.slotsOpen;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              width: critical ? 2 : 1,
              color: critical
                  ? const Color(0xFFE85D04).withValues(alpha: 0.95)
                  : urgent
                      ? const Color(0xFFFFB020).withValues(alpha: 0.55)
                      : Colors.white.withValues(alpha: 0.12),
            ),
            boxShadow: critical
                ? [
                    BoxShadow(
                      color: const Color(0xFFE85D04).withValues(alpha: 0.25),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 112,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _CardCover(bytes: project.coverImageBytes, critical: critical),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              const Color(0xFF1A1D2E).withValues(alpha: 0.85),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 10,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                project.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
                                ),
                              ),
                            ),
                            if (critical || urgent) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: critical ? const Color(0xFFE85D04) : const Color(0xFFFFB020),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  critical ? 'Срочно' : 'Скоро срок',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.type,
                        style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.6), fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        project.shortDescription,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85), height: 1.35),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _MiniAvatarRow(names: project.participantNames.take(4).toList()),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${project.currentMemberCount}/${project.teamSizeTarget} в команде',
                              style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.event_rounded, size: 14, color: Colors.white.withValues(alpha: 0.55)),
                          const SizedBox(width: 4),
                          Text(
                            project.deadlineLabel,
                            style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.65)),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: slots == 0
                                  ? const Color(0xFF2DD4BF).withValues(alpha: 0.2)
                                  : const Color(0xFF6A63FF).withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              slots == 0
                                  ? 'Команда набрана'
                                  : 'Нужно ещё $slots ${_slotsWord(slots)}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: slots == 0 ? const Color(0xFF2DD4BF) : Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.chevron_right_rounded, size: 20, color: Colors.white.withValues(alpha: 0.45)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _slotsWord(int n) {
    final m = n % 10;
    final m100 = n % 100;
    if (m100 >= 11 && m100 <= 14) return 'чел.';
    if (m == 1) return 'чел.';
    if (m >= 2 && m <= 4) return 'чел.';
    return 'чел.';
  }
}

class _CardCover extends StatelessWidget {
  final Uint8List? bytes;
  final bool critical;

  const _CardCover({required this.bytes, required this.critical});

  @override
  Widget build(BuildContext context) {
    if (bytes != null) {
      return Image.memory(bytes!, fit: BoxFit.cover);
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: critical
              ? [const Color(0xFF8B2500), const Color(0xFF4A0E4E)]
              : [const Color(0xFF3D2B8C), const Color(0xFF6A2F5B)],
        ),
      ),
    );
  }
}

class _MiniAvatarRow extends StatelessWidget {
  final List<String> names;

  const _MiniAvatarRow({required this.names});

  static const _avatarColors = [
    Color(0xFF6A63FF),
    Color(0xFF915BFF),
    Color(0xFF2DD4BF),
    Color(0xFFFF8A3D),
  ];

  @override
  Widget build(BuildContext context) {
    final shown = names.take(4).toList();
    return SizedBox(
      height: 28,
      width: 26 + (shown.length > 1 ? (shown.length - 1) * 16.0 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < shown.length; i++)
            Positioned(
              left: i * 16.0,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _avatarColors[i % _avatarColors.length],
                  border: Border.all(color: const Color(0xFF1A1D2E), width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  shown[i].isNotEmpty ? shown[i][0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
