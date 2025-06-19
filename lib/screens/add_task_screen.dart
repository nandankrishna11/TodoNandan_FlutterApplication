import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_nandan_flutter/models/task.dart';
import 'package:todo_nandan_flutter/providers/task_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../models/subtask.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;

  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDate;
  late TaskPriority _priority;
  late TaskCategory _category;
  List<SubTask> _subtasks = [];
  bool _isRecurring = false;
  String? _recurrenceRule;
  DateTime? _reminder;
  List<String> _attachments = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _dueDate = widget.task?.dueDate ?? DateTime.now();
    _priority = widget.task?.priority ?? TaskPriority.medium;
    _category = widget.task?.category ?? TaskCategory.personal;
    _subtasks = widget.task?.subtasks ?? [];
    _isRecurring = widget.task?.isRecurring ?? false;
    _recurrenceRule = widget.task?.recurrenceRule;
    _reminder = widget.task?.reminder;
    _attachments = widget.task?.attachments ?? [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final task = Task(
        id: widget.task?.id ?? DateTime.now().toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate,
        priority: _priority,
        category: _category,
        isCompleted: widget.task?.isCompleted ?? false,
        createdAt: widget.task?.createdAt,
        completedAt: widget.task?.completedAt,
        subtasks: _subtasks,
        isRecurring: _isRecurring,
        recurrenceRule: _recurrenceRule,
        reminder: _reminder,
        attachments: _attachments,
        commentIds: widget.task?.commentIds ?? [],
      );

      if (widget.task != null) {
        taskProvider.updateTask(task);
      } else {
        taskProvider.addTask(task);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.task != null ? 'Edit Task' : 'Add New Task',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Due Date'),
                  subtitle: Text(
                    '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _dueDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _dueDate = date;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TaskPriority>(
                  value: _priority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                  items: TaskPriority.values.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(priority.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _priority = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TaskCategory>(
                  value: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: TaskCategory.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _category = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                Text('Subtasks', style: Theme.of(context).textTheme.titleMedium),
                ..._subtasks.map((s) => ListTile(
                  title: Text(s.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() => _subtasks.remove(s));
                    },
                  ),
                )),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Subtask'),
                  onPressed: () async {
                    final controller = TextEditingController();
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('New Subtask'),
                        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Subtask Title')),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                          TextButton(onPressed: () {
                            if (controller.text.isNotEmpty) {
                              setState(() => _subtasks.add(SubTask(id: DateTime.now().toString(), title: controller.text)));
                            }
                            Navigator.pop(context);
                          }, child: const Text('Add')),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Recurring Task'),
                  value: _isRecurring,
                  onChanged: (val) => setState(() => _isRecurring = val),
                ),
                if (_isRecurring)
                  DropdownButtonFormField<String>(
                    value: _recurrenceRule,
                    decoration: const InputDecoration(labelText: 'Recurrence'),
                    items: ['Daily', 'Weekly', 'Monthly'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (val) => setState(() => _recurrenceRule = val),
                  ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Reminder'),
                  subtitle: Text(_reminder != null ? '${_reminder!.day}/${_reminder!.month}/${_reminder!.year} ${_reminder!.hour}:${_reminder!.minute}' : 'No reminder set'),
                  trailing: const Icon(Icons.alarm),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _reminder ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_reminder ?? DateTime.now()),
                      );
                      if (time != null) {
                        setState(() {
                          _reminder = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                        });
                      }
                    }
                  },
                ),
                const SizedBox(height: 16),
                Text('Attachments', style: Theme.of(context).textTheme.titleMedium),
                Wrap(
                  spacing: 8,
                  children: _attachments.map((a) => Chip(label: Text(a.split('/').last))).toList(),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Add Attachment'),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles();
                    if (result != null && result.files.isNotEmpty) {
                      setState(() => _attachments.add(result.files.first.path!));
                    }
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.task != null ? 'Update Task' : 'Add Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 