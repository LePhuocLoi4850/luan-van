import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';
import 'package:jobapp/ui/ungvien/home_uv/job_gird_title_vertical.dart';

import '../../../server/database.dart';

class SearchUVScreen extends StatefulWidget {
  const SearchUVScreen({super.key});

  @override
  State<SearchUVScreen> createState() => _SearchUVScreenState();
}

class _SearchUVScreenState extends State<SearchUVScreen> {
  final AuthController controller = Get.find<AuthController>();
  final _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Map<String, dynamic>> _jobCareer = [];
  List<dynamic> items = [
    'Lập trình viên',
    'Gia sư',
    'Trưởng phòng kinh doanh',
    'Nhân viên phục vụ',
    'Nhân viên marketing',
    'Nhân viên kinh doanh',
    'Trợ lý giám đốc',
    'Xây dựng',
    'Digital marketing',
    'Ngân hàng'
  ];
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
    _fetchJobCareer();
  }

  void _fetchJobCareer() async {
    String career = await Database()
        .selectCareerUserForEmail(controller.userModel.value.email!);

    try {
      _jobCareer = await Database().fetchAllJobForCareer(career);
      setState(() {});
    } catch (e) {
      print('select error job for career: $e');
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
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.white],
          stops: [0.1, 0.3],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _focusNode.unfocus();
                              Get.toNamed('/searchScreen');
                            },
                            child: Container(
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      size: 30,
                                      color: Colors.blue,
                                    ),
                                    Text(
                                      'Tìm kiếm',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tìm kiếm hàng đầu',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 380,
                          height: 192,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 7,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  color: Colors.transparent,
                                  child: RichText(
                                      text: TextSpan(
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          children: [
                                        TextSpan(
                                            text: '${index + 1} ',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        TextSpan(text: '${items[index]}')
                                      ])));
                            },
                          ),
                        ),
                        const Text(
                          'Việc làm phù hợp',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        _jobCareer.isEmpty
                            ? Center(
                                child: Text('Hiện tại không có công việc nào'),
                              )
                            : Container(
                                color: Colors.white,
                                child: ListView.builder(
                                  shrinkWrap:
                                      true, // Để giới hạn chiều cao theo dữ liệu
                                  physics:
                                      NeverScrollableScrollPhysics(), // Ngăn việc cuộn bên trong nếu không cần thiết
                                  itemCount: _jobCareer.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: JobGirdTitleVertical(
                                          allJobs: [_jobCareer[index]],
                                          imageDecorator: (serviceDay) {
                                            return _getServiceDayBorder(
                                                serviceDay);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
