import 'package:flutter/material.dart';
import '../config/theme.dart';

class BottomBarWidget extends StatelessWidget {
  const BottomBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: AppTheme.colorSecondaryDark,
        border: Border(
          top: BorderSide(color: AppTheme.colorSecondary, width: 2),
        ),
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              color: AppTheme.colorTextLight,
              fontSize: 14,
            ),
            children: [
              TextSpan(text: '© ${DateTime.now().year} '),
              const TextSpan(
                text: 'StajForum',
                style: TextStyle(
                  color: AppTheme.colorAccent,
                  fontWeight: FontWeight.w500,
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





