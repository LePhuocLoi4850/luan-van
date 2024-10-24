import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';
import 'package:jobapp/ui/ungvien/home_uv/job_gird_title_vertical.dart';

import '../../auth/auth_controller.dart';

class JobOfCompany extends StatefulWidget {
  const JobOfCompany({super.key});

  @override
  State<JobOfCompany> createState() => _JobOfCompanyState();
}

class _JobOfCompanyState extends State<JobOfCompany> {
  AuthController controller = Get.find<AuthController>();
  List<Map<String, dynamic>> _allJob = [];
  int cId = Get.arguments;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchAllJobForCid();
  }

  void fetchAllJobForCid() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      _allJob = await Database().fetchAllJobForCid(cId, false);
      print(_allJob);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Việc làm cùng công ty'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 800,
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: JobGirdTitleVertical(
                    allJobs: _allJob,
                  ),
                ),
              ),
            ),
    );
  }
}
