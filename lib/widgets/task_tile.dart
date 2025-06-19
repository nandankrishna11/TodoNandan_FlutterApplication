import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_nandan_flutter/models/task.dart';
import 'package:todo_nandan_flutter/providers/task_provider.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../models/comment.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool _expanded = false;
  List<Comment> _comments = [];
  final TextEditingController _commentController = TextEditingController();

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  IconData _getCategoryIcon(TaskCategory category) {
    switch (category) {
      case TaskCategory.work:
        return Icons.work;
      case TaskCategory.personal:
        return Icons.person;
      case TaskCategory.shopping:
        return Icons.shopping_cart;
      case TaskCategory.health:
        return Icons.favorite;
      case TaskCategory.education:
        return Icons.school;
    }
  }

  void _showTaskDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24, right: 24, top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.task.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(widget.task.description, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                Text('Comments', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ..._comments.map((c) => ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(c.content),
                  subtitle: Text('${c.createdAt.hour}:${c.createdAt.minute}'),
                )),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(hintText: 'Add a comment'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (_commentController.text.isNotEmpty) {
                          setState(() {
                            _comments.add(Comment(
                              id: DateTime.now().toString(),
                              userId: 'me',
                              taskId: widget.task.id,
                              content: _commentController.text,
                              createdAt: DateTime.now(),
                            ));
                            _commentController.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final theme = Theme.of(context);
    // TODO: Replace with real subtasks, reminders, attachments, comments
    final List<String> subtasks = ["Subtask 1", "Subtask 2", "Subtask 3"];
    final int completedSubtasks = 1;
    final bool isRecurring = false; // TODO
    final bool hasReminder = false; // TODO
    final bool hasAttachment = false; // TODO
    final int commentCount = 2; // TODO

    return Semantics(
      label: 'Task card: ${task.title}',
      container: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: task.isCompleted ? theme.colorScheme.primary.withOpacity(0.08) : theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.surfaceVariant,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Colored sidebar for priority
            Container(
              width: 8,
              height: double.infinity,
              decoration: BoxDecoration(
                color: _getPriorityColor(task.priority),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () => _showTaskDetails(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
            Row(
              children: [
                          Semantics(
                            label: task.isCompleted ? 'Mark as incomplete' : 'Mark as complete',
                            button: true,
                            child: GestureDetector(
                              onTap: () {
                                taskProvider.toggleTaskCompletion(task.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(task.isCompleted ? 'Task marked incomplete' : 'Task completed!'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Tooltip(
                                message: task.isCompleted ? 'Mark as incomplete' : 'Mark as complete',
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                                  child: task.isCompleted
                                      ? Lottie.asset('assets/icons/checkmark.json', key: const ValueKey('checked'), height: 32, repeat: false)
                                      : Icon(Icons.radio_button_unchecked, key: const ValueKey('unchecked'), color: theme.colorScheme.primary, size: 32),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              task.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                            child: Semantics(
                              label: _expanded ? 'Collapse details' : 'Expand details',
                              button: true,
                              child: Tooltip(
                                message: _expanded ? 'Collapse details' : 'Expand details',
                                child: IconButton(
                                  key: ValueKey(_expanded),
                                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                                  onPressed: () => setState(() => _expanded = !_expanded),
                                  iconSize: 28,
                                  padding: const EdgeInsets.all(10),
                                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Chips for category and priority
                      Padding(
                        padding: const EdgeInsets.only(left: 44, top: 8, bottom: 4),
                        child: Row(
                          children: [
                            Semantics(
                              label: 'Category: ${task.category.toString().split('.').last}',
                              child: Tooltip(
                                message: 'Category: ${task.category.toString().split('.').last}',
                                child: Chip(
                                  avatar: Icon(_getCategoryIcon(task.category), size: 16, color: theme.colorScheme.onPrimary),
                                  label: Text(task.category.toString().split('.').last),
                                  backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                                ),
                              ),
                ),
                const SizedBox(width: 8),
                            Semantics(
                              label: 'Priority: ${task.priority.toString().split('.').last}',
                              child: Tooltip(
                                message: 'Priority: ${task.priority.toString().split('.').last}',
                                child: Chip(
                                  avatar: Icon(Icons.flag, size: 16, color: _getPriorityColor(task.priority)),
                                  label: Text(task.priority.toString().split('.').last),
                                  backgroundColor: _getPriorityColor(task.priority).withOpacity(0.15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(_getCategoryIcon(task.category), size: 18, color: theme.colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(task.category.toString().split('.').last, style: theme.textTheme.bodySmall),
                      const SizedBox(width: 12),
                      Icon(Icons.calendar_today, size: 16, color: theme.colorScheme.primary),
                      const SizedBox(width: 2),
                      Text(DateFormat('MMM d').format(task.dueDate), style: theme.textTheme.bodySmall),
                      const SizedBox(width: 12),
                      if (isRecurring)
                        Tooltip(message: 'Recurring', child: Icon(Icons.repeat, size: 16, color: Theme.of(context).colorScheme.secondary)),
                      if (hasReminder)
                        Tooltip(message: 'Reminder set', child: Icon(Icons.notifications_active, size: 16, color: Theme.of(context).colorScheme.primary)),
                      if (hasAttachment)
                        Tooltip(message: 'Attachment', child: Icon(Icons.attach_file, size: 16, color: Theme.of(context).colorScheme.tertiary)),
                      if (commentCount > 0)
                        Tooltip(message: 'Comments', child: Row(children: [Icon(Icons.comment, size: 16, color: Theme.of(context).colorScheme.secondary), Text(' $commentCount', style: theme.textTheme.bodySmall)])),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 