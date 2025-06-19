import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  File? profileImage;
  String? profileImagePath;
  final picker = ImagePicker();
  bool _isEditing = false;
  String _originalName = '';
  String _originalEmail = '';
  String _originalBio = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _bioController = TextEditingController();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('profile_name') ?? 'Nandan Kumar';
    final email = prefs.getString('profile_email') ?? 'nandan@example.com';
    final bio = prefs.getString('profile_bio') ?? 'Productivity enthusiast. Love to build and organize!';
    final imagePath = prefs.getString('profile_image_path');
    setState(() {
      _nameController.text = name;
      _emailController.text = email;
      _bioController.text = bio;
      _originalName = name;
      _originalEmail = email;
      _originalBio = bio;
      profileImagePath = imagePath;
      if (profileImagePath != null && profileImagePath!.isNotEmpty) {
        profileImage = File(profileImagePath!);
      } else {
        profileImage = null;
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
        profileImagePath = pickedFile.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_name', _nameController.text);
      await prefs.setString('profile_email', _emailController.text);
      await prefs.setString('profile_bio', _bioController.text);
      if (profileImagePath != null) {
        await prefs.setString('profile_image_path', profileImagePath!);
      }
      setState(() {
        _isEditing = false;
        _originalName = _nameController.text;
        _originalEmail = _emailController.text;
        _originalBio = _bioController.text;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved!')),
      );
    }
  }

  void _startEdit() {
    setState(() {
      _isEditing = true;
    });
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _nameController.text = _originalName;
      _emailController.text = _originalEmail;
      _bioController.text = _originalBio;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Demo stats
    const int tasksCompleted = 128;
    const int currentStreak = 7;
    const int goalsAchieved = 12;
    const int categoriesCreated = 5;
    const int daysActive = 42;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top profile card with gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _isEditing ? _pickImage : null,
                    child: CircleAvatar(
                      radius: 54,
                      backgroundColor: colorScheme.onPrimary.withOpacity(0.15),
                      backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
                      child: profileImage == null
                          ? Icon(Icons.person, color: colorScheme.onPrimary, size: 54)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _isEditing
                      ? Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  border: const OutlineInputBorder(),
                                  labelStyle: TextStyle(color: colorScheme.onPrimary),
                                  filled: true,
                                  fillColor: colorScheme.onPrimary.withOpacity(0.08),
                                ),
                                style: TextStyle(color: colorScheme.onPrimary),
                                validator: (value) => value == null || value.isEmpty ? 'Enter your name' : null,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: const OutlineInputBorder(),
                                  labelStyle: TextStyle(color: colorScheme.onPrimary),
                                  filled: true,
                                  fillColor: colorScheme.onPrimary.withOpacity(0.08),
                                ),
                                style: TextStyle(color: colorScheme.onPrimary),
                                validator: (value) => value == null || value.isEmpty ? 'Enter your email' : null,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _bioController,
                                decoration: InputDecoration(
                                  labelText: 'Bio',
                                  border: const OutlineInputBorder(),
                                  labelStyle: TextStyle(color: colorScheme.onPrimary),
                                  filled: true,
                                  fillColor: colorScheme.onPrimary.withOpacity(0.08),
                                ),
                                style: TextStyle(color: colorScheme.onPrimary),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Text(
                              _nameController.text,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _emailController.text,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimary.withOpacity(0.85),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _bioController.text,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onPrimary.withOpacity(0.8),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ProfileStatCard(
                    icon: Icons.check_circle,
                    label: 'Tasks',
                    value: tasksCompleted.toString(),
                    color: colorScheme.primary,
                  ),
                  _ProfileStatCard(
                    icon: Icons.local_fire_department,
                    label: 'Streak',
                    value: '$currentStreak',
                    color: colorScheme.tertiary,
                  ),
                  _ProfileStatCard(
                    icon: Icons.emoji_events,
                    label: 'Goals',
                    value: goalsAchieved.toString(),
                    color: colorScheme.secondary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ProfileStatCard(
                    icon: Icons.category,
                    label: 'Categories',
                    value: categoriesCreated.toString(),
                    color: colorScheme.primaryContainer,
                  ),
                  _ProfileStatCard(
                    icon: Icons.calendar_today,
                    label: 'Active Days',
                    value: daysActive.toString(),
                    color: colorScheme.secondaryContainer,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Profile actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_isEditing) ...[
                    ElevatedButton.icon(
                      onPressed: _saveProfile,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _cancelEdit,
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.secondary,
                        side: BorderSide(color: colorScheme.secondary),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ] else ...[
                    OutlinedButton.icon(
                      onPressed: _startEdit,
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Details'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        side: BorderSide(color: colorScheme.primary),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download),
                      label: const Text('Export Profile'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.secondary,
                        side: BorderSide(color: colorScheme.secondary),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _ProfileStatCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: color.withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 