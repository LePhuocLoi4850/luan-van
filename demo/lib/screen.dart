import 'package:demo/home.dart';
import 'package:demo/update.dart';
import 'package:flutter/material.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          MessengerWebView(),
          MessengerWebView(),
          MessengerWebView(),
          MessengerWebView(),
          UpdateUserScreen(),
        ],
      ),
      floatingActionButton: ClipOval(
        child: Material(
          color: Colors.blue,
          elevation: 0,
          child: InkWell(
            focusColor: Colors.blue,
            onTap: () => _onItemTapped(2),
            child: const SizedBox(
              width: 50,
              height: 50,
              child: Icon(
                Icons.search_outlined,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: const Color.fromARGB(255, 99, 99, 99),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
              size: 30,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month,
              size: 30,
            ),
            label: 'MyCV',
          ),
          BottomNavigationBarItem(
            icon: SizedBox.shrink(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.note_rounded,
              size: 30,
            ),
            label: 'CV',
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
