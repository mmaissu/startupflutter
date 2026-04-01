import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/duo_project.dart';

class DuoProjectDetailScreen extends StatelessWidget {
  final DuoProject project;

  const DuoProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final urgent = project.isUrgent;
    final critical = project.isCritical;
    final slots = project.slotsOpen;

    return Scaffold(
      backgroundColor: const Color(0xFF12151F),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFF1A1D2E),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _buildHeaderImage(project.coverImageBytes, critical),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF12151F).withValues(alpha: 0.3),
                          const Color(0xFF12151F),
                        ],
                      ),
                    ),
                  ),
                  if (critical || urgent)
                    Positioned(
                      top: MediaQuery.paddingOf(context).top + 8,
                      right: 16,
                      child: _UrgentChip(critical: critical),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white, height: 1.2),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Tag(icon: Icons.category_rounded, label: project.type),
                      _Tag(icon: Icons.event_rounded, label: project.deadlineLabel, accent: urgent),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _SectionTitle('Команда'),
                  const SizedBox(height: 12),
                  _TeamProgressBar(
                    current: project.currentMemberCount,
                    target: project.teamSizeTarget,
                    slotsOpen: slots,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    slots == 0
                        ? 'Команда набрана'
                        : 'Нужно ещё $slots ${slots == 1 ? 'человек' : _peopleWord(slots)}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: slots == 0 ? const Color(0xFF2DD4BF) : Colors.white.withValues(alpha: 0.92),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final name in project.participantNames)
                        _ParticipantChip(name: name),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _SectionTitle('О проекте'),
                  const SizedBox(height: 10),
                  Text(
                    project.fullDescription,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.88), fontSize: 15, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _peopleWord(int n) {
    final m = n % 10;
    final m100 = n % 100;
    if (m100 >= 11 && m100 <= 14) return 'человек';
    if (m == 1) return 'человека';
    if (m >= 2 && m <= 4) return 'человека';
    return 'человек';
  }

  static Widget _buildHeaderImage(Uint8List? bytes, bool critical) {
    if (bytes != null) {
      return Image.memory(bytes, fit: BoxFit.cover);
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: critical
              ? [const Color(0xFFE85D04), const Color(0xFF9D174D), const Color(0xFF1A1D2E)]
              : [const Color(0xFF6A63FF), const Color(0xFFFF5AA5), const Color(0xFF1A1D2E)],
        ),
      ),
      child: Center(
        child: Icon(Icons.groups_rounded, size: 72, color: Colors.white.withValues(alpha: 0.35)),
      ),
    );
  }
}

class _UrgentChip extends StatelessWidget {
  final bool critical;

  const _UrgentChip({required this.critical});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: critical ? const Color(0xFFE85D04) : const Color(0xFFFFB020),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (critical ? const Color(0xFFE85D04) : const Color(0xFFFFB020)).withValues(alpha: 0.45),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(critical ? Icons.priority_high_rounded : Icons.schedule_rounded, color: Colors.black87, size: 16),
          const SizedBox(width: 6),
          Text(
            critical ? 'Срочно' : 'Скоро дедлайн',
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool accent;

  const _Tag({required this.icon, required this.label, this.accent = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: accent ? const Color(0xFFFFB020).withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent ? const Color(0xFFFFB020).withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: accent ? const Color(0xFFFFB020) : Colors.white70),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: accent ? const Color(0xFFFFE0A3) : Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 18, decoration: BoxDecoration(color: const Color(0xFF6A63FF), borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
      ],
    );
  }
}

class _TeamProgressBar extends StatelessWidget {
  final int current;
  final int target;
  final int slotsOpen;

  const _TeamProgressBar({
    required this.current,
    required this.target,
    required this.slotsOpen,
  });

  @override
  Widget build(BuildContext context) {
    final t = target <= 0 ? 1 : target;
    final p = (current / t).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: p,
            minHeight: 10,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
              slotsOpen == 0 ? const Color(0xFF2DD4BF) : const Color(0xFF6A63FF),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$current из $target в команде',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 12),
        ),
      ],
    );
  }
}

class _ParticipantChip extends StatelessWidget {
  final String name;

  const _ParticipantChip({required this.name});

  @override
  Widget build(BuildContext context) {
    final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFF6A63FF).withValues(alpha: 0.6),
            child: Text(letter, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
          const SizedBox(width: 8),
          Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}
