import 'package:flutter/material.dart';
import 'package:todo_nandan_flutter/widgets/task_list.dart';
import 'package:todo_nandan_flutter/widgets/task_filters.dart';
import 'package:todo_nandan_flutter/widgets/task_stats.dart';
import 'package:todo_nandan_flutter/widgets/add_task_button.dart';
import 'package:todo_nandan_flutter/widgets/concentration_page.dart';
import 'package:todo_nandan_flutter/widgets/journal_page.dart';
import 'package:todo_nandan_flutter/widgets/special_occasion_page.dart';
import 'package:todo_nandan_flutter/widgets/day_task_page.dart';
import '../widgets/streak_checkin.dart';
import '../widgets/motivation_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
      onTap: onTap,
    );
  }

  Widget _buildQuickAccessCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    Color? color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.7),
                Theme.of(context).colorScheme.primary,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primaryContainer,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    child: Icon(Icons.person, size: 35, color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'TodoNandan',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Text(
                    'Your Personal Task Manager',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.timer,
              title: 'Concentration',
              onTap: () => _navigateTo(context, const ConcentrationPage()),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.book,
              title: 'Journal',
              onTap: () => _navigateTo(context, const JournalPage()),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.celebration,
              title: 'Special Occasion',
              onTap: () => _navigateTo(context, const SpecialOccasionPage()),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.calendar_today,
              title: 'Day Task/Activity',
              onTap: () => _navigateTo(context, const DayTaskPage()),
            ),
            const Divider(),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
              title: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome!',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Let\'s get productive!',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.85),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: Theme.of(context).brightness == Brightness.dark
                      ? [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.surface,
                        ]
                      : [
                          const Color(0xFF5B86E5),
                          const Color(0xFF36D1C4),
                        ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Icon(
                        Icons.check_circle,
                        size: 150,
                        color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.05)
                          : Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Motivation Banner
          SliverToBoxAdapter(child: MotivationBanner()),
          // Streak Check-in
          SliverToBoxAdapter(child: StreakCheckin()),

          // Quick Access Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Access',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildQuickAccessCard(
                        context,
                        title: 'Focus Time',
                        icon: Icons.timer,
                        onTap: () => _navigateTo(context, const ConcentrationPage()),
                      ),
                      _buildQuickAccessCard(
                        context,
                        title: 'Journal',
                        icon: Icons.book,
                        onTap: () => _navigateTo(context, const JournalPage()),
                      ),
                      _buildQuickAccessCard(
                        context,
                        title: 'Special Events',
                        icon: Icons.celebration,
                        onTap: () => _navigateTo(context, const SpecialOccasionPage()),
                      ),
                      _buildQuickAccessCard(
                        context,
                        title: 'Day Tasks',
                        icon: Icons.calendar_today,
                        onTap: () => _navigateTo(context, const DayTaskPage()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Stats Section
          const SliverToBoxAdapter(
            child: TaskStats(),
          ),

          // Filters Section
          const SliverToBoxAdapter(
            child: TaskFilters(),
          ),

          // Tasks List
          const SliverToBoxAdapter(
            child: TaskList(),
          ),
        ],
      ),
      floatingActionButton: const AddTaskButton(),
    );
  }
} 