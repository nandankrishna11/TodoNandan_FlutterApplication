import 'package:flutter/material.dart';
import '../models/category.dart';
import '../utils/constants.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  List<Category> _categories = [];

  void _addCategory() async {
    String name = '';
    Color color = AppConstants.categoryColors.first;
    IconData icon = AppConstants.categoryIcons.first;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (v) => name = v,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Color>(
              value: color,
              decoration: const InputDecoration(labelText: 'Color'),
              items: AppConstants.categoryColors.map((c) => DropdownMenuItem(value: c, child: CircleAvatar(backgroundColor: c))).toList(),
              onChanged: (c) => color = c!,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<IconData>(
              value: icon,
              decoration: const InputDecoration(labelText: 'Icon'),
              items: AppConstants.categoryIcons.map((i) => DropdownMenuItem(value: i, child: Icon(i))).toList(),
              onChanged: (i) => icon = i!,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () {
            if (name.isNotEmpty) {
              setState(() => _categories.add(Category(id: DateTime.now().toString(), userId: 'me', name: name, color: color, icon: icon)));
            }
            Navigator.pop(context);
          }, child: const Text('Add')),
        ],
      ),
    );
  }

  void _deleteCategory(String id) {
    setState(() => _categories.removeWhere((c) => c.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Categories')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._categories.map((c) => Card(
            child: ListTile(
              leading: CircleAvatar(backgroundColor: c.color, child: Icon(c.icon, color: Colors.white)),
              title: Text(c.name),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteCategory(c.id),
              ),
            ),
          )),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Category'),
            onPressed: _addCategory,
          ),
        ],
      ),
    );
  }
} 