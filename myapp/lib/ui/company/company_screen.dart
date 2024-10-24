import 'package:flutter/material.dart';
import '../../../ui/company/post/post_screen.dart';
import '../../ui/screens.dart';
import 'profilec/profilec.dart';
import 'searchc/searchc.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomeCScreen(),
          SearchUser(),
          PostJobScreen(),
          ProfileCScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_search_sharp,
              size: 30,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.solidPaperPlane,
              size: 27,
            ),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 30,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
