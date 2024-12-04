// admin_drawer.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth/auth_controller.dart';

class AdminDrawer extends StatefulWidget {
  final List<Map<String, dynamic>> serviceData;
  final int countService;
  final ValueChanged<int> onCountServiceChanged;

  const AdminDrawer({
    super.key,
    required this.serviceData,
    required this.countService,
    required this.onCountServiceChanged,
  });

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu Admin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Quản lý ứng viên'),
            onTap: () {
              Get.toNamed('/adminUser');
            },
          ),
          ListTile(
            leading: Icon(Icons.business),
            title: Text('Quản lý công ty'),
            onTap: () {
              Get.toNamed('/adminCompany');
            },
          ),
          ListTile(
            leading: Icon(Icons.work),
            title: Text('Quản lý công việc'),
            onTap: () {
              Get.toNamed('/adminJob');
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Quản lý dịch vụ'),
            onTap: () async {
              Map<String, dynamic> data = {
                'data': widget.serviceData,
                'count_service': widget.countService
              };
              final result =
                  await Get.toNamed('/adminService', arguments: data);
              if (result != null) {
                widget.onCountServiceChanged(result['count_service']);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Quản lý đơn hàng'),
            onTap: () {
              Get.toNamed('/adminPay');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Đăng xuất'),
            onTap: () {
              controller.logout();
            },
          ),
        ],
      ),
    );
  }
}
