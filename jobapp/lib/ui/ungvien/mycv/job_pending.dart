import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../server/database.dart';
import '../../auth/auth_controller.dart';
import '../home_uv/job_gird_title_vertical.dart';

class JobPending extends StatefulWidget {
  const JobPending({super.key});

  @override
  State<JobPending> createState() => _JobPendingState();
}

class _JobPendingState extends State<JobPending> {
  final AuthController controller = Get.find<AuthController>();

  List<Map<String, dynamic>> _appliedJobs = [];
  List<Map<String, dynamic>> _reapplyJobs = [];
  List<Map<String, dynamic>> _allJobs = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchAllJob('applied');
    _fetchAllJob('reapply');
  }

  void _fetchAllJob(String status) async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    int uid = controller.userModel.value.id!;
    if (status == 'applied') {
      _appliedJobs = await Database().fetchAllApplyForStatus(uid, status);
    } else if (status == 'reapply') {
      _reapplyJobs = await Database().fetchAllApplyForStatus(uid, status);
    }
    _allJobs = [..._appliedJobs, ..._reapplyJobs];
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Công việc đang chờ duyệt'),
      ),
      body: isLoading
          ? const Center(
              child: SpinKitChasingDots(
                color: Colors.blue,
                size: 50.0,
              ),
            )
          : SingleChildScrollView(
              child: SizedBox(
                height: 789,
                child: GestureDetector(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: JobGirdTitleVertical(
                        allJobs: _allJobs,
                      )),
                ),
              ),
            ),
    );
  }
}
