import 'package:flutter/material.dart';

class DayTaskPage extends StatefulWidget {
  const DayTaskPage({Key? key}) : super(key: key);

  @override
  _DayTaskPageState createState() => _DayTaskPageState();
}

class _DayTaskPageState extends State<DayTaskPage> {
  final List<DayTask> _tasks = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    // TODO: Load tasks from storage
    setState(() {
      _tasks.addAll([
        DayTask(
          title: 'Morning Meeting',
          description: 'Daily team sync-up',
          dueDate: DateTime.now(),
          priority: 'High',
          status: 'Pending',
          category: 'Work',
          completed: false,
          time: '09:00 AM',
        ),
        DayTask(
          title: 'Gym Session',
          description: 'Evening workout routine',
          dueDate: DateTime.now(),
          priority: 'Medium',
          status: 'Pending',
          category: 'Health',
          completed: false,
          time: '06:00 PM',
        ),
        DayTask(
          title: 'Grocery Shopping',
          description: 'Weekly groceries and supplies',
          dueDate: DateTime.now(),
          priority: 'Low',
          status: 'Completed',
          category: 'Shopping',
          completed: true,
          time: '04:00 PM',
        ),
      ]);
    });
  }

  void _showAddTaskDialog() {
    String title = '';
    String description = '';
    String priority = 'Medium';
    String category = 'Work';
    DateTime dueDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => title = value,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) => description = value,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                value: priority,
                items: ['High', 'Medium', 'Low'].map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Text(p),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) priority = value;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                value: category,
                items: ['Work', 'Personal', 'Health', 'Shopping'].map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Text(c),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) category = value;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Due Date'),
                subtitle: Text(
                  '${dueDate.day}/${dueDate.month}/${dueDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    dueDate = date;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (title.isNotEmpty) {
                setState(() {
                  _tasks.add(DayTask(
                    title: title,
                    description: description,
                    dueDate: dueDate,
                    priority: priority,
                    status: 'Pending',
                    category: category,
                    completed: false,
                    time: '${dueDate.hour}:${dueDate.minute}',
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TaskSearchDelegate(_tasks),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(task.time),
                const SizedBox(width: 8),
                Icon(
                  task.completed ? Icons.check_circle : Icons.circle_outlined,
                  color: task.completed ? Colors.green : Colors.grey,
                ),
              ],
            ),
            onTap: () {
              setState(() {
                task.completed = !task.completed;
                task.status = task.completed ? 'Completed' : 'Pending';
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DayTask {
  final String title;
  final String description;
  final DateTime dueDate;
  final String priority;
  String status;
  final String category;
  bool completed;
  final String time;

  DayTask({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.category,
    required this.completed,
    required this.time,
  });
}

class TaskSearchDelegate extends SearchDelegate {
  final List<DayTask> tasks;

  TaskSearchDelegate(this.tasks);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = tasks.where((task) {
      return task.title.toLowerCase().contains(query.toLowerCase()) ||
          task.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final task = results[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(task.time),
              const SizedBox(width: 8),
              Icon(
                task.completed ? Icons.check_circle : Icons.circle_outlined,
                color: task.completed ? Colors.green : Colors.grey,
              ),
            ],
          ),
        );
      },
    );
  }
} 