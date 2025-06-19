import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_nandan_flutter/models/task.dart';
import 'package:todo_nandan_flutter/providers/task_provider.dart';

class TaskFilters extends StatelessWidget {
  const TaskFilters({super.key});

  // Example icons for categories and priorities (customize as needed)
  IconData _categoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'work':
        return Icons.work;
      case 'personal':
        return Icons.person;
      case 'shopping':
        return Icons.shopping_cart;
      case 'health':
        return Icons.favorite;
      default:
        return Icons.category;
    }
  }

  IconData _priorityIcon(String name) {
    switch (name.toLowerCase()) {
      case 'high':
        return Icons.priority_high;
      case 'medium':
        return Icons.trending_up;
      case 'low':
        return Icons.low_priority;
      default:
        return Icons.flag;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Card(
          color: Theme.of(context).colorScheme.surfaceVariant,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category filters
                Text(
                  'Categories',
                  style: theme.textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: const Text('All'),
                          avatar: const Icon(Icons.all_inclusive, size: 18),
                          selected: taskProvider.selectedCategory == 'All',
                          onSelected: (selected) {
                            taskProvider.setCategoryFilter(null);
                          },
                        ),
                      ),
                      ...TaskCategory.values.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category.name),
                            avatar: Icon(_categoryIcon(category.name), size: 18),
                            selected: taskProvider.selectedCategory == category.name,
                            onSelected: (selected) {
                              taskProvider.setCategoryFilter(selected ? category : null);
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Priority filters
                Text(
                  'Priority',
                  style: theme.textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: const Text('All'),
                          avatar: const Icon(Icons.all_inclusive, size: 18),
                          selected: taskProvider.selectedPriority == 'All',
                          onSelected: (selected) {
                            taskProvider.setPriorityFilter(null);
                          },
                        ),
                      ),
                      ...TaskPriority.values.map((priority) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(priority.name),
                            avatar: Icon(_priorityIcon(priority.name), size: 18),
                            selected: taskProvider.selectedPriority == priority.name,
                            onSelected: (selected) {
                              taskProvider.setPriorityFilter(selected ? priority : null);
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Sort options
                Text(
                  'Sort By',
                  style: theme.textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Priority'),
                      selected: taskProvider.sortBy == 'Priority',
                      onSelected: (selected) {
                        if (selected) taskProvider.setSortBy('Priority');
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Due Date'),
                      selected: taskProvider.sortBy == 'Due Date',
                      onSelected: (selected) {
                        if (selected) taskProvider.setSortBy('Due Date');
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Name'),
                      selected: taskProvider.sortBy == 'Name',
                      onSelected: (selected) {
                        if (selected) taskProvider.setSortBy('Name');
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Status'),
                      selected: taskProvider.sortBy == 'Status',
                      onSelected: (selected) {
                        if (selected) taskProvider.setSortBy('Status');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 