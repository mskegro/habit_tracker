import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final String currentRoute;

  const BottomNavBar({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56, 
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            icon: Icons.home_rounded,
            label: 'Home',
            route: '/dashboard',
          ),
          _buildNavItem(
            context,
            icon: Icons.check_circle_outline,
            label: 'Habits',
            route: '/habits',
          ),
          _buildNavItem(
            context,
            icon: Icons.bar_chart_rounded,
            label: 'Analytics',
            route: '/analytics',
          ),
          _buildNavItem(
            context,
            icon: Icons.emoji_events_rounded,
            label: 'Awards',
            route: '/achievements',
          ),
          _buildNavItem(
            context,
            icon: Icons.person_rounded,
            label: 'Profile',
            route: '/profile',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    final isActive = currentRoute == route;

    return InkWell(
      onTap: () {
        if (currentRoute != route) {
          Navigator.pushNamed(context, route);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6), 
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color.fromARGB(255, 166, 54, 194) : const Color(0xFF94A3B8),
              size: 24, 
            ),
            const SizedBox(height: 2), 
            Text(
              label,
              style: TextStyle(
                fontSize: 11, 
                color: isActive ? const Color.fromARGB(255, 146, 23, 174) : const Color(0xFF94A3B8),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
