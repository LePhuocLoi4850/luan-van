import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:intl/intl.dart';

import '../../../server/database.dart';
import '../../auth/auth_controller.dart';
import '../admin_company/admin_company.dart';

class AdminJob extends StatefulWidget {
  const AdminJob({super.key});

  @override
  State<AdminJob> createState() => _AdminJobState();
}

class _AdminJobState extends State<AdminJob> {
  final AuthController controller = Get.find<AuthController>();

  List<Map<String, dynamic>> _allJobs = [];
  List<Map<String, dynamic>> _filteredJobs = [];
  bool _isAscending = true;
  bool _isSortByStatus = false;
  bool _filterByStatus = false;

  @override
  void initState() {
    super.initState();
    _fetchAllJobs();
  }

  void _fetchAllJobs() async {
    _allJobs = await Database().fetchAllJobAdmin();
    _sortJobsByNumApply(_isAscending);

    _applyFilters();

    if (mounted) {
      setState(() {});
    }
  }

  BoxDecoration _getServiceDayBorder(String? serviceDay) {
    if (serviceDay != null && serviceDay.isNotEmpty) {
      try {
        DateTime serviceDate = DateTime.parse(serviceDay);
        if (serviceDate.isAfter(DateTime.now())) {
          return BoxDecoration(
            border: GradientBoxBorder(
              width: 3,
              gradient: LinearGradient(
                colors: [Colors.red, Colors.yellow, Colors.green, Colors.blue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            borderRadius: BorderRadius.circular(8),
          );
        }
      } catch (e) {
        print('Error parsing service_day: $e');
      }
    }
    return BoxDecoration();
  }

  void _sortJobsByStatus(bool ascending) {
    if (ascending) {
      _filteredJobs.sort(
          (a, b) => a['status'] == b['status'] ? 0 : (a['status'] ? 1 : -1));
    } else {
      _filteredJobs.sort(
          (a, b) => a['status'] == b['status'] ? 0 : (a['status'] ? -1 : 1));
    }
  }

  void _sortJobsByNumApply(bool ascending) {
    if (ascending) {
      _filteredJobs.sort((a, b) => a['num_apply'].compareTo(b['num_apply']));
    } else {
      _filteredJobs.sort((a, b) => b['num_apply'].compareTo(a['num_apply']));
    }
  }

  void _filterJobsByStatus() {
    if (_filterByStatus) {
      _filteredJobs = _allJobs.where((job) => job['status'] == false).toList();
    } else {
      _filteredJobs = List.from(_allJobs);
    }
  }

  void _applyFilters() {
    _filterJobsByStatus();
    if (_isSortByStatus) {
      _sortJobsByStatus(_isAscending);
    } else {
      _sortJobsByNumApply(_isAscending);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách việc làm'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                switch (value) {
                  case 'SortOrder':
                    _isAscending = !_isAscending;
                    break;
                  case 'SortByStatus':
                    _isSortByStatus = !_isSortByStatus;
                    break;
                  case 'FilterByStatus':
                    _filterByStatus = !_filterByStatus;
                    break;
                }
                _applyFilters();
              });
            },
            icon: Icon(Icons.more_vert), // Nút dấu ba chấm
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'SortOrder',
                child: ListTile(
                  leading: Icon(
                    _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  ),
                  title: Text(
                      _isAscending ? 'Sắp xếp giảm dần' : 'Sắp xếp tăng dần'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'SortByStatus',
                child: ListTile(
                  leading: Icon(
                    _isSortByStatus ? Icons.toggle_on : Icons.toggle_off,
                  ),
                  title: Text(_isSortByStatus
                      ? 'Tắt sắp xếp theo trạng thái'
                      : 'Sắp xếp theo trạng thái'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          height: 800,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: _filteredJobs.isEmpty
              ? _buildErrorWidget()
              : ListView.builder(
                  itemCount: _filteredJobs.length,
                  itemBuilder: (context, index) {
                    final job = _filteredJobs[index];
                    return _buildJobTile(job);
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 80,
                height: 80,
                child: Image(image: AssetImage('assets/images/error.gif')),
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Đã xảy ra lỗi',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Không tìm thấy việc làm phù hợp với bạn!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobTile(Map<String, dynamic> job) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () {
          Get.toNamed('/jobDetailAdmin', arguments: job['jid']);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: Container(
              decoration: _getServiceDayBorder(job['service_day'].toString()),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageFromBase64String(job['image']),
              ),
            ),
            title: Text(
              job['title'],
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job['nameC']),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Icon(Icons.person_2),
                    Text(job['num_apply'].toString()),
                  ],
                ),
                Text(
                    'Hết hạn: ${DateFormat('dd/MM/yyyy').format(job['expiration_date'])}'),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.all(7.0),
              decoration: BoxDecoration(
                color:
                    job['status'] == false ? Colors.green[50] : Colors.red[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                job['status'] == false ? 'Hoạt động' : 'Đã ẩn',
                style: TextStyle(
                  color: job['status'] == false ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
