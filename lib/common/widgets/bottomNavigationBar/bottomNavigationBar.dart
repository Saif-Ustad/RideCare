import 'package:flutter/material.dart';

class BottomNavigationBarSection extends StatelessWidget {
  const BottomNavigationBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBottomNavigationBar();
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Bookmark"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
