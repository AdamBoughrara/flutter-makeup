import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: Theme.of(context).primaryColor,
      height: 65,
      items: const [
        Icon(Icons.home, color: Colors.white),
        Icon(Icons.favorite, color: Colors.white),
        Icon(Icons.person, color: Colors.white),
        Icon(Icons.menu, color: Colors.white),
      ],
      onTap: onTap, // Use the provided onTap callback
    );
  }
}
