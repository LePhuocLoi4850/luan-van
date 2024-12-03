import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/controller/calender_controller.dart';
import 'package:jobapp/controller/company_controller.dart';
import 'package:jobapp/controller/user_controller.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';
import 'package:jobapp/ui/nhatuyendung/search/search_uv.dart';

import 'home_company.dart';
import 'profile_ntd/profile_screen.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  AuthController controller = Get.put(AuthController());
  UserController userController = Get.put(UserController());
  CompanyController companyController = Get.put(CompanyController());
  CalenderController calenderController = Get.put(CalenderController());

  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    companyController.countJob(controller.companyModel.value.id!);
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
          HomeNTD(),
          SearchUvScreen(),
          ProfileScreen(),
        ],
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
              Icons.search,
              size: 30,
            ),
            label: 'Tìm kiếm',
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
