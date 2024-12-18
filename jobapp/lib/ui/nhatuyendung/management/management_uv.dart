import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';
import 'package:jobapp/ui/nhatuyendung/management/uv_gird_title.dart';

class ManagementUv extends StatefulWidget {
  const ManagementUv({super.key});

  @override
  State<ManagementUv> createState() => _ManagementUvState();
}

class _ManagementUvState extends State<ManagementUv>
    with SingleTickerProviderStateMixin {
  AuthController controller = Get.find<AuthController>();
  late TabController _tabController;
  List<Map<String, dynamic>> appliedUsers = [];
  List<Map<String, dynamic>> receivedUsers = [];
  List<Map<String, dynamic>> refusedUsers = [];

  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchData();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _fetchData() async {
    String nameC = controller.companyModel.value.name.toString();

    try {
      appliedUsers = await Database().fetchAllJobApplied(nameC, 'applied');
      receivedUsers = await Database().fetchAllJobApplied(nameC, 'approved');
      refusedUsers = await Database().fetchAllJobApplied(nameC, 'rejected');
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý ứng viên'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Đang chờ duyệt'),
            Tab(text: 'Đã nhận'),
            Tab(text: 'Đã từ chối'),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildSection(appliedUsers),
                  _buildSection(receivedUsers),
                  _buildSection(refusedUsers),
                ],
              ),
      ),
    );
  }

  Widget _buildSection(List<Map<String, dynamic>> data) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final user = data[index];
        final userData = {
          'uid': user['uid'],
          'name': user['name'],
          'career': user['career'],
          'birthday': user['birthday'],
          'gender': user['gender'],
          'address': user['address'],
          'image': user['image'],
          'title': user['title'],
          'status': user['status'],
          'jid': user['jid'],
          'cv_id': user['cv_id'],
          'nameCv': user['nameCv'],
        };
        return Container(
          width: 390,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: UVGirdTitle(
            girdUV: userData,
            onStatusChanged: _fetchData,
          ),
        );
      },
    );
  }
}
