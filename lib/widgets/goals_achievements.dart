import 'package:flutter/material.dart';

class GoalsAchievements extends StatelessWidget {
  const GoalsAchievements({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final goals = [
      {'title': 'Complete 5 tasks today', 'progress': 0.6},
      {'title': 'Finish weekly report', 'progress': 0.3},
    ];
    final achievements = [
      {'label': '7-Day Streak', 'icon': Icons.local_fire_department, 'color': Colors.orange},
      {'label': 'First Task', 'icon': Icons.emoji_events, 'color': Colors.amber},
    ];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Goals', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...goals.map((g) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(g['title'] as String, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(value: g['progress'] as double),
                ],
              ),
            )),
            const SizedBox(height: 20),
            Text('Achievements', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: achievements.map((a) => Chip(
                label: Text(a['label'] as String),
                avatar: Icon(a['icon'] as IconData, color: a['color'] as Color),
                backgroundColor: (a['color'] as Color).withOpacity(0.1),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
} 