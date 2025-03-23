import 'package:flutter/material.dart';
import '../../../core/configs/theme/app_colors.dart';

class BottomNavigationBarSection extends StatefulWidget {
  const BottomNavigationBarSection({super.key});

  @override
  _BottomNavigationBarSectionState createState() =>
      _BottomNavigationBarSectionState();
}

class _BottomNavigationBarSectionState
    extends State<BottomNavigationBarSection> {
  int _selectedIndex = 0;

  final List<IconData> _icons = [
    Icons.home,
    Icons.explore,
    Icons.bookmark,
    Icons.person,
  ];

  final List<String> _labels = ["Home", "Explore", "Bookmark", "Profile"];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent, // Removes splash effect
        highlightColor: Colors.transparent, // Removes touch highlight
        hoverColor: Colors.transparent, // Prevents hover effect
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedLabelStyle: TextStyle(fontSize: 10),
              unselectedLabelStyle: TextStyle(fontSize: 10),
              elevation: 10,
              items: List.generate(
                _icons.length,
                    (index) => BottomNavigationBarItem(
                  icon: _buildIcon(index),
                  label: _labels[index],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(int index) {
    bool isSelected = index == _selectedIndex;
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color:
        isSelected
            ? Color(0xFF8A6CFF).withOpacity(0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(_icons[index], size: 20,),
    );
  }
}
