import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Theme Settings
          _buildSection(
            context,
            'Appearance',
            [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Toggle dark/light theme'),
                    value: themeProvider.isDarkMode,
                    onChanged: (bool value) {
                      themeProvider.toggleTheme();
                    },
                  );
                },
              ),
            ],
          ),

          // Notification Settings
          _buildSection(
            context,
            'Notifications',
            [
              SwitchListTile(
                title: const Text('Task Reminders'),
                subtitle: const Text('Get notified about upcoming tasks'),
                value: true,
                onChanged: (bool value) {
                  // TODO: Implement notification toggle
                },
              ),
              SwitchListTile(
                title: const Text('Due Date Alerts'),
                subtitle: const Text('Get notified when tasks are due'),
                value: true,
                onChanged: (bool value) {
                  // TODO: Implement due date alerts toggle
                },
              ),
            ],
          ),

          // Data Management
          _buildSection(
            context,
            'Data Management',
            [
              ListTile(
                title: const Text('Export Tasks'),
                subtitle: const Text('Save your tasks to a file'),
                leading: const Icon(Icons.file_download),
                onTap: () {
                  // TODO: Implement task export
                },
              ),
              ListTile(
                title: const Text('Import Tasks'),
                subtitle: const Text('Load tasks from a file'),
                leading: const Icon(Icons.file_upload),
                onTap: () {
                  // TODO: Implement task import
                },
              ),
              ListTile(
                title: const Text('Clear All Data'),
                subtitle: const Text('Delete all tasks and settings'),
                leading: const Icon(Icons.delete_forever),
                onTap: () {
                  _showClearDataDialog(context);
                },
              ),
            ],
          ),

          // About
          _buildSection(
            context,
            'About',
            [
              ListTile(
                title: const Text('Version'),
                subtitle: const Text('1.0.0'),
                leading: const Icon(Icons.info),
              ),
              ListTile(
                title: const Text('Privacy Policy'),
                leading: const Icon(Icons.privacy_tip),
                onTap: () {
                  // TODO: Show privacy policy
                },
              ),
              ListTile(
                title: const Text('Terms of Service'),
                leading: const Icon(Icons.description),
                onTap: () {
                  // TODO: Show terms of service
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Data'),
          content: const Text(
            'Are you sure you want to delete all tasks and settings? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                // TODO: Implement data clearing
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
} 