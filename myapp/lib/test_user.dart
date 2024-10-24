import 'package:flutter/material.dart';
import 'package:myapp/ui/screens.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import 'ui/user/profileu/profile_gird_title.dart';

class JobApplicationPage extends StatefulWidget {
  const JobApplicationPage({super.key});

  @override
  _JobApplicationPageState createState() => _JobApplicationPageState();
}

class _JobApplicationPageState extends State<JobApplicationPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> appliedUsers = [];
  List<Map<String, dynamic>> receivedUsers = [];
  List<Map<String, dynamic>> refusedUsers = [];
  List<Map<String, dynamic>> withdrawnUsers = [];
  List<Map<String, dynamic>> userDataList = [];
  String? emailc;
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final companyProvider =
        Provider.of<CompanyProvider>(context, listen: false);
    emailc = companyProvider.email;
    _fetchData();
    _tabController = TabController(length: 4, vsync: this);
  }

  Future<void> _fetchData() async {
    try {
      userDataList =
          await DatabaseConnection().fetchUserDataByEmailC(emailc!, 'applied');
      print(userDataList);
      receivedUsers =
          await DatabaseConnection().fetchUserDataByEmailC(emailc!, 'received');
      refusedUsers =
          await DatabaseConnection().fetchUserDataByEmailC(emailc!, 'refused');
      withdrawnUsers = await DatabaseConnection()
          .fetchUserDataByEmailC(emailc!, 'withdrawn');
    } catch (e) {
      print('Error fetching data: $e');
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
        title: const Text('Quản lí ứng viên'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Đang chờ duyệt'),
            Tab(text: 'Đã nhận'),
            Tab(text: 'Đã từ chối'),
            Tab(text: 'Đã hủy'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildSection(userDataList),
                _buildSection(receivedUsers),
                _buildSection(refusedUsers),
                _buildSection(withdrawnUsers),
              ],
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
          'id': user['id'],
          'name': user['name'],
          'birthday': user['birthday'],
          'phone': user['phone'],
          'gender': user['gender'],
          'career': user['career'],
          'address': user['address'],
          'nameJob': user['nameJob'],
          'status': user['status'],
          'email': user['email'],
          'description': user['description'],
          'jobId': user['jobId']
        };
        return Container(
          width: 390,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 200, 200, 200)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ProfileGirdTitle(userData),
        );
      },
    );
  }
}
