import 'package:flutter/material.dart';
import '../config/theme.dart';

class BottomBarWidget extends StatelessWidget {
  const BottomBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        color: AppTheme.backgroundDark, // Match scaffold background or slightly lighter
        border: Border(
          top: BorderSide(color: AppTheme.primaryColor, width: 2), // Neon laser line
        ),
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
            children: [
              TextSpan(text: '© ${DateTime.now().year} '),
              const TextSpan(
                text: 'StajForum',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: '. Tüm hakları saklıdır.'),
            ],
          ),
        ),
      ),
    );
  }
}





