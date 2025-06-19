import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_nandan_flutter/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Text('Theme', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<ThemeMode>(
                        title: const Text('Light'),
                        value: ThemeMode.light,
                        groupValue: themeProvider.themeMode,
                        onChanged: (mode) => themeProvider.setThemeMode(mode!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<ThemeMode>(
                        title: const Text('Dark'),
                        value: ThemeMode.dark,
                        groupValue: themeProvider.themeMode,
                        onChanged: (mode) => themeProvider.setThemeMode(mode!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<ThemeMode>(
                        title: const Text('System'),
                        value: ThemeMode.system,
                        groupValue: themeProvider.themeMode,
                        onChanged: (mode) => themeProvider.setThemeMode(mode!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text('Customization (Coming Soon)', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Enable Custom Home Layout'),
                  value: false,
                  onChanged: null,
                ),
                const SizedBox(height: 32),
                Text('Data Management', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.file_download),
                  title: const Text('Export Tasks'),
                  subtitle: const Text('Save your tasks to a file'),
                  onTap: () {
                    // TODO: Implement export logic
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.file_upload),
                  title: const Text('Import Tasks'),
                  subtitle: const Text('Load tasks from a file'),
                  onTap: () {
                    // TODO: Implement import logic
                  },
                ),
                const Divider(height: 40),
                Text('App Info', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Version'),
                  subtitle: const Text('1.0.0'),
                ),
                ListTile(
                  leading: const Icon(Icons.build),
                  title: const Text('Build Number'),
                  subtitle: const Text('100'),
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About'),
                  subtitle: const Text('TodoNandan is your modern productivity and task management app.'),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'TodoNandan',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2024 Nandan Kumar',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 