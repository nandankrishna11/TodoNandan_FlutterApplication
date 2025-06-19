import 'package:flutter/material.dart';

class SpecialOccasionPage extends StatefulWidget {
  const SpecialOccasionPage({Key? key}) : super(key: key);

  @override
  _SpecialOccasionPageState createState() => _SpecialOccasionPageState();
}

class _SpecialOccasionPageState extends State<SpecialOccasionPage> {
  final List<SpecialOccasion> _occasions = [];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    // Add sample occasions
    _occasions.addAll([
      SpecialOccasion(
        title: 'Mom\'s Birthday',
        date: DateTime.now().add(const Duration(days: 15)),
        category: 'Birthday',
        description: 'Don\'t forget to buy flowers and a cake!',
        reminder: true,
      ),
      SpecialOccasion(
        title: 'Team Meeting',
        date: DateTime.now().add(const Duration(days: 3)),
        category: 'Work',
        description: 'Quarterly review meeting with the team',
        reminder: true,
      ),
      SpecialOccasion(
        title: 'Anniversary',
        date: DateTime.now().add(const Duration(days: 30)),
        category: 'Personal',
        description: '5th wedding anniversary celebration',
        reminder: true,
      ),
    ]);
  }

  void _showAddOccasionDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String selectedCategory = 'Personal';
    bool reminderEnabled = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Special Occasion'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Date'),
                  subtitle: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() => selectedDate = date);
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Personal', 'Work', 'Birthday', 'Holiday']
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedCategory = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Enable Reminder'),
                  value: reminderEnabled,
                  onChanged: (value) {
                    setState(() => reminderEnabled = value);
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
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    _occasions.add(
                      SpecialOccasion(
                        title: titleController.text,
                        description: descriptionController.text,
                        date: selectedDate,
                        category: selectedCategory,
                        reminder: reminderEnabled,
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  List<SpecialOccasion> get _filteredOccasions {
    if (_selectedCategory == 'All') {
      return _occasions;
    }
    return _occasions
        .where((occasion) => occasion.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Special Occasion'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (category) {
              setState(() => _selectedCategory = category);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'All',
                child: Text('All Categories'),
              ),
              ...['Personal', 'Work', 'Birthday', 'Holiday']
                  .map((category) => PopupMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.filter_list),
                  const SizedBox(width: 4),
                  Text(_selectedCategory),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _filteredOccasions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.event,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No occasions yet',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _showAddOccasionDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add First Occasion'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredOccasions.length,
              itemBuilder: (context, index) {
                final occasion = _filteredOccasions[index];
                final daysUntil = occasion.date.difference(DateTime.now()).inDays;
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        occasion.date.day.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      occasion.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(occasion.description),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Chip(
                              label: Text(occasion.category),
                              backgroundColor:
                                  Theme.of(context).primaryColor.withOpacity(0.1),
                            ),
                            const SizedBox(width: 8),
                            if (occasion.reminder)
                              const Chip(
                                label: Text('Reminder Set'),
                                backgroundColor: Colors.green,
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${occasion.date.month}/${occasion.date.year}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              daysUntil == 0
                                  ? 'Today!'
                                  : daysUntil == 1
                                      ? 'Tomorrow'
                                      : '$daysUntil days left',
                              style: TextStyle(
                                color: daysUntil <= 7
                                    ? Colors.red
                                    : Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Occasion'),
                                content: const Text(
                                  'Are you sure you want to delete this special occasion? This action cannot be undone.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _occasions.remove(occasion);
                                      });
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddOccasionDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SpecialOccasion {
  final String title;
  final String description;
  final DateTime date;
  final String category;
  final bool reminder;

  SpecialOccasion({
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    required this.reminder,
  });
} 