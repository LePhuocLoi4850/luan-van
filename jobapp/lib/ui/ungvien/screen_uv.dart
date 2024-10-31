import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/controller/user_controller.dart';
import 'package:jobapp/ui/ungvien/cv_uv/cv_screen.dart';
import 'package:jobapp/ui/ungvien/home_uv/home_uv_screen.dart';
import 'package:jobapp/ui/ungvien/mycv/mycv_screen.dart';
import 'package:jobapp/ui/ungvien/profile_uv/profile_uv_screen.dart';
import 'package:jobapp/ui/ungvien/search_uv/search_uv_screen.dart';

import '../../controller/cv_storage.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserController userController = Get.put(UserController());
  CvStorageController cvStorageController = Get.put(CvStorageController());

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    if (arguments != null &&
        arguments is Map &&
        arguments.containsKey('selectedIndex')) {
      _selectedIndex = arguments['selectedIndex'] as int;
    }
  }

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
          HomeUV(),
          MyCVScreen(),
          SearchUVScreen(),
          CvScreen(),
          ProfileUVScreen(),
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
