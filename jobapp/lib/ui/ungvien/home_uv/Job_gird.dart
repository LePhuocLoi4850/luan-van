import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';

import 'job_gird_title.dart';

class JobGird extends StatefulWidget {
  const JobGird({super.key});

  @override
  State<JobGird> createState() => _JobGirdState();
}

class _JobGirdState extends State<JobGird> {
  final AuthController controller = Get.find<AuthController>();
  String inter = 'Thực tập';
  List<Map<String, dynamic>> _allJobs = [];
  List<Map<String, dynamic>> _allJobForCareer = [];
  List<Map<String, dynamic>> _allJobInter = [];
  @override
  void initState() {
    super.initState();
    _fetchAllJobs();
  }

  void _fetchAllJobs() async {
    _allJobs = await Database().fetchAllJob(false);
    _allJobInter = await Database().fetchAllJobInter(false, 'Thực tập sinh');
    _allJobForCareer = await Database()
        .fetchAllJobForCareer(controller.userModel.value.career!);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 0, right: 0),
        child: Container(
          color: Colors.grey[50],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: Colors.blue),
                                    color: Colors.grey[200]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image(
                                    image: AssetImage('assets/images/bag.jpg'),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Việc làm',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/companyGirdTitle');
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.grey[200]),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/company.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Công ty',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Divider(
                      color: Colors.blue,
                      thickness: 3,
                      indent: 185,
                      endIndent: 185,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Colors.orange,
                    ),
                    Text(
                      'Việc làm phù hợp',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 20, 121, 203),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: _allJobForCareer == []
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
                                          image: AssetImage(
                                              'assets/images/error.gif')),
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
                                            fontSize: 16,
                                            color: Colors.grey[400]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : JobGirdTitle(
                            allJobs: _allJobForCareer,
                          )),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                    ),
                    Text(
                      'Thực tập sinh',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 20, 121, 203)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: _allJobInter == []
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
                                          image: AssetImage(
                                              'assets/images/error.gif')),
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
                                            fontSize: 16,
                                            color: Colors.grey[400]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : JobGirdTitle(
                            allJobs: _allJobInter,
                          )),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.orange,
                    ),
                    Text(
                      'Việc làm Mới Nhất',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 20, 121, 203)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
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
                                          image: AssetImage(
                                              'assets/images/error.gif')),
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
                                            fontSize: 16,
                                            color: Colors.grey[400]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : JobGirdTitle(
                            allJobs: _allJobs,
                          )),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Xem tất cả việc làm',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Ngành nghề nổi bậc',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 20, 121, 203)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
