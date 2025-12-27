import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'donor_list_screen.dart';
import 'donor_form_screen.dart';
import 'guidelines_screen.dart';
import 'profile_screen.dart';

class NavigationScreens extends StatefulWidget {
  final int initialIndex; // إضافة معامل لاختيار الفهرس المبدئي
  
  const NavigationScreens({super.key, this.initialIndex = 0});

  @override
  State<NavigationScreens> createState() => _NavigationScreensState();
}

class _NavigationScreensState extends State<NavigationScreens> {
  late int _selectedIndex;
  
  static final List<Widget> _screens = [
    const HomeScreen(),
    const DonorsListScreen(),
    BloodRequestForm(),
    HealthTipsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // استخدام المعامل
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'المتبرعون',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'طلب دم',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety),
            label: 'إرشادات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}