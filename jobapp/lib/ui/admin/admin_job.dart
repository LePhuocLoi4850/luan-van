import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:jobapp/ui/ungvien/home_uv/job_gird_title_vertical.dart';

import '../../server/database.dart';
import '../auth/auth_controller.dart';

class AdminJob extends StatefulWidget {
  const AdminJob({super.key});

  @override
  State<AdminJob> createState() => _AdminJobState();
}

class _AdminJobState extends State<AdminJob> {
  final AuthController controller = Get.find<AuthController>();

  List<Map<String, dynamic>> _allJobs = [];
  @override
  void initState() {
    super.initState();
    _fetchAllJobs();
  }

  void _fetchAllJobs() async {
    _allJobs = await Database().fetchAllJob(false);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách việc làm'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
            height: 800,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: _allJobs == []
                ? Padding(
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
                              child: Image(
                                  image: AssetImage('assets/images/error.gif')),
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
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[400]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : JobGirdTitleVertical(
                    allJobs: _allJobs,
                    imageDecorator: (serviceDay) {
                      return _getServiceDayBorder(serviceDay);
                    },
                  )),
      ),
    );
  }
}
