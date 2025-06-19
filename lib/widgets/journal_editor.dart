import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JournalEditor extends StatefulWidget {
  final String? initialContent;
  final String? initialMood;
  final String? initialCategory;

  const JournalEditor({
    Key? key,
    this.initialContent,
    this.initialMood,
    this.initialCategory,
  }) : super(key: key);

  @override
  _JournalEditorState createState() => _JournalEditorState();
}

class _JournalEditorState extends State<JournalEditor> {
  final TextEditingController _contentController = TextEditingController();
  String _selectedMood = '😊';
  String _selectedCategory = 'Personal';
  bool _isDarkMode = false;
  bool _showPrompts = true;
  int _wordCount = 0;
  int _characterCount = 0;
  bool _hasUnsavedChanges = false;
  bool _isFullScreen = false;

  final List<String> _moods = ['😊', '😌', '😔', '😡', '😴', '🤔', '😎', '🥰'];
  final List<String> _categories = ['Personal', 'Work', 'Ideas', 'Gratitude', 'Goals', 'Reflection'];
  
  final List<String> _prompts = [
    "What made you smile today?",
    "What's one thing you're grateful for?",
    "What's a challenge you overcame?",
    "What's something you learned today?",
    "What are you looking forward to?",
    "What's a goal you want to achieve?",
    "What's a memory you want to cherish?",
    "What's something you want to improve?",
  ];

  @override
  void initState() {
    super.initState();
    _contentController.text = widget.initialContent ?? '';
    _selectedMood = widget.initialMood ?? '😊';
    _selectedCategory = widget.initialCategory ?? 'Personal';
    _updateCounts();
    _contentController.addListener(_updateCounts);
    _contentController.addListener(() {
      setState(() {
        _hasUnsavedChanges = _contentController.text.isNotEmpty;
      });
    });
  }

  void _updateCounts() {
    final text = _contentController.text;
    setState(() {
      _wordCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
      _characterCount = text.length;
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;
    
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('You have unsaved changes. Do you want to discard them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('DISCARD'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _saveJournal() {
    // TODO: Implement save functionality
    Navigator.pop(context, {
      'content': _contentController.text,
      'mood': _selectedMood,
      'category': _selectedCategory,
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: _isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: _isDarkMode ? Colors.white : Colors.black),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            'Write Journal',
            style: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: _isDarkMode ? Colors.black : Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.save,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: _saveJournal,
            ),
          ],
        ),
        body: Column(
          children: [
            // Mood and Category Selection
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isDarkMode ? Colors.grey[900] : Colors.grey[100],
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  // Mood Selection
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How are you feeling?',
                          style: TextStyle(
                            color: _isDarkMode ? Colors.white70 : Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _moods.map((mood) {
                              return GestureDetector(
                                onTap: () => setState(() => _selectedMood = mood),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _selectedMood == mood
                                        ? (_isDarkMode ? Colors.white24 : Colors.black12)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    mood,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Category Selection
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category',
                          style: TextStyle(
                            color: _isDarkMode ? Colors.white70 : Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: _isDarkMode ? Colors.white24 : Colors.black12,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCategory,
                              isExpanded: true,
                              dropdownColor: _isDarkMode ? Colors.grey[900] : Colors.white,
                              style: TextStyle(
                                color: _isDarkMode ? Colors.white : Colors.black,
                              ),
                              items: _categories.map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _selectedCategory = value);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Writing Area
            Expanded(
              child: Stack(
                children: [
                  // Text Editor
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      expands: true,
                      style: TextStyle(
                        color: _isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                        height: 1.5,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Start writing...',
                        hintStyle: TextStyle(
                          color: _isDarkMode ? Colors.white38 : Colors.black38,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  // Word Count
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _isDarkMode ? Colors.white24 : Colors.black12,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$_wordCount words • $_characterCount characters',
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white70 : Colors.black87,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 