import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String username;
  const HomeHeader({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7B1FA2), Color(0xFF512DA8)], // Purple shades
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 👤 Avatar Placeholder with initial
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white.withAlpha(200),
              child: Text(
                username.isNotEmpty ? username[0].toUpperCase() : "?",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 👋 Welcome + username
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // 🔔 Notifications
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined,
                  color: Colors.white, size: 26),
            ),
            // ☰ Menu
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu, color: Colors.white, size: 26),
            ),
          ],
        ),
      ),
    );
  }
}
