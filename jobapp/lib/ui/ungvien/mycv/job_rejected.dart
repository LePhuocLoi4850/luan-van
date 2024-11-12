import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../server/database.dart';
import '../../auth/auth_controller.dart';

import '../home_uv/job_gird_title_vertical.dart';

class JobRejected extends StatefulWidget {
  const JobRejected({super.key});

  @override
  State<JobRejected> createState() => _JobRejectedState();
}

class _JobRejectedState extends State<JobRejected> {
  final AuthController controller = Get.find<AuthController>();

  List<Map<String, dynamic>> _allJobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllJobs();
  }

  void _fetchAllJobs() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    String status = 'rejected';
    int uid = controller.userModel.value.id!;
    _allJobs = await Database().fetchAllApplyForStatus(uid, status);
    setState(() {});
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
        title: Text('Công việc bị từ chối'),
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
                height: 780,
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
