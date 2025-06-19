import 'package:flutter/material.dart';
import 'journal_editor.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final List<Map<String, dynamic>> _entries = [];

  void _addNewEntry() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const JournalEditor(),
      ),
    );

    if (result != null) {
      setState(() {
        _entries.insert(0, {
          'content': result['content'],
          'mood': result['mood'],
          'category': result['category'],
          'date': DateTime.now(),
        });
      });
    }
  }

  void _editEntry(int index) async {
    final entry = _entries[index];
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEditor(
          initialContent: entry['content'],
          initialMood: entry['mood'],
          initialCategory: entry['category'],
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _entries[index] = {
          'content': result['content'],
          'mood': result['mood'],
          'category': result['category'],
          'date': entry['date'],
        };
      });
    }
  }

  void _deleteEntry(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _entries.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Journal'),
      ),
      body: _entries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_note,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No entries yet',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start writing your thoughts',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () => _editEntry(index),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                entry['mood'],
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  entry['category'],
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _deleteEntry(index),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            entry['content'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${entry['date'].day}/${entry['date'].month}/${entry['date'].year}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewEntry,
        child: const Icon(Icons.add),
      ),
    );
  }
} 