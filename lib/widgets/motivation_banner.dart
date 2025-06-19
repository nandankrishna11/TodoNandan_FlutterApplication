import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'dart:math';

class MotivationBanner extends StatelessWidget {
  const MotivationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final quote = AppConstants.motivationalQuotes[Random().nextInt(AppConstants.motivationalQuotes.length)];
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.emoji_emotions, size: 36, color: Theme.of(context).colorScheme.tertiary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"${quote['text']}"',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '- ${quote['author']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.8)),
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