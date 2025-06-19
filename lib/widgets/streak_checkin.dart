import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StreakCheckin extends StatefulWidget {
  const StreakCheckin({super.key});

  @override
  State<StreakCheckin> createState() => _StreakCheckinState();
}

class _StreakCheckinState extends State<StreakCheckin> {
  int _streak = 3; // Mock value
  bool _checkedInToday = false;
  bool _showCelebration = false;

  void _checkIn() {
    setState(() {
      _checkedInToday = true;
      _streak++;
      _showCelebration = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _showCelebration = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_fire_department, color: Theme.of(context).colorScheme.tertiary, size: 32),
                const SizedBox(width: 12),
                Text('Streak: $_streak days', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer)),
                const Spacer(),
                ElevatedButton(
                  onPressed: _checkedInToday ? null : _checkIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: Text(_checkedInToday ? 'Checked In' : 'Daily Check-in'),
                ),
              ],
            ),
            if (_showCelebration)
              Center(
                child: Lottie.asset('assets/icons/celebrate.json', height: 80, repeat: false),
              ),
          ],
        ),
      ),
    );
  }
} 