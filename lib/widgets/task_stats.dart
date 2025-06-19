import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_nandan_flutter/providers/task_provider.dart';
import 'package:todo_nandan_flutter/models/task.dart';

class TaskStats extends StatelessWidget {
  const TaskStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final totalTasks = taskProvider.tasks.length;
        final completedTasks = taskProvider.tasks.where((task) => task.isCompleted).length;
        final pendingTasks = totalTasks - completedTasks;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                icon: Icons.check_circle,
                label: 'Completed',
                value: completedTasks.toString(),
                iconColor: Theme.of(context).colorScheme.primary,
              ),
              _StatItem(
                icon: Icons.pending,
                label: 'Pending',
                value: pendingTasks.toString(),
                iconColor: Theme.of(context).colorScheme.secondary,
              ),
              _StatItem(
                icon: Icons.star,
                label: 'Priority',
                value: taskProvider.tasks.where((task) => task.priority == TaskPriority.high).length.toString(),
                iconColor: Theme.of(context).colorScheme.tertiary,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color? iconColor;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: iconColor ?? theme.colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8)),
        ),
      ],
    );
  }
} 