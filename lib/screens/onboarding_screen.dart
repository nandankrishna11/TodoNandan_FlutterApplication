import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Welcome to TodoNandan',
      'desc': 'Your all-in-one productivity and task management app.',
    },
    {
      'title': 'Stay Organized',
      'desc': 'Create tasks, subtasks, set reminders, and never miss a deadline.',
    },
    {
      'title': 'Achieve More',
      'desc': 'Track your goals, earn achievements, and stay motivated every day.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 80, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 32),
                      Text(_pages[i]['title']!, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      Text(_pages[i]['desc']!, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _page ? Theme.of(context).colorScheme.primary : Colors.grey[300],
                ),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Mark onboarding as complete and navigate to login/home
                  Navigator.pop(context);
                },
                child: Text(_page == _pages.length - 1 ? 'Get Started' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 