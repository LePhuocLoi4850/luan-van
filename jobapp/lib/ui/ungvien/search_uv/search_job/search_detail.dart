import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../server/database.dart';
import '../../../auth/auth_controller.dart';
import '../../home_uv/job_gird_title_vertical.dart';

class SearchDetail extends StatefulWidget {
  const SearchDetail({super.key});

  @override
  State<SearchDetail> createState() => _SearchDetailState();
}

class _SearchDetailState extends State<SearchDetail> {
  final AuthController controller = Get.find<AuthController>();
  List<Map<String, dynamic>> _jobCareer = [];
  List<Map<String, dynamic>> _job = [];
  bool isLoading = true;
  String type = '';
  String? title;
  final _experienceController = TextEditingController();
  final _salaryController = TextEditingController();

  List<String> experience = [
    'Tất cả',
    'Sắp đi làm',
    'Dưới 1 năm',
    '1 năm',
    '2 năm',
    '3 năm',
    '4 năm',
    '5 năm',
    'Trên 5 năm',
    'Không yêu cầu'
  ];
  List<String> salary = [
    'Tất cả',
    'Dưới 10 triệu',
    '10 - 15 triệu',
    '15 - 20 triệu',
    '20 - 25 triệu',
    '25 - 30 triệu',
    'Trên 30 triệu',
    'Thỏa thuận'
  ];
  @override
  void initState() {
    super.initState();

    final arguments = Get.arguments as Map<String, dynamic>;

    if (arguments.containsKey('searchText')) {
      title = arguments['searchText'];
      _fetchJobCareer();
    }

    // if (arguments.containsKey('jobs') && arguments.containsKey('title')) {
    //   title = arguments['title'];
    //   try {
    //     if (mounted) {
    //       setState(() {
    //         isLoading = true;
    //       });
    //     }
    //     _job = List<Map<String, dynamic>>.from(arguments['jobs']);
    //   } catch (e) {
    //     print(e);
    //   } finally {
    //     if (mounted) {
    //       setState(() {
    //         isLoading = false;
    //       });
    //     }
    //   }
    // }
    setState(() {});
  }

  void _fetchJobCareer() async {
    String career = await Database()
        .selectCareerUserForEmail(controller.userModel.value.email!);
    print(career.toString());

    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      _jobCareer = await Database().fetchJobForCareer(career);

      _filterJobsByTitle(title!);
    } catch (e) {
      print('select error job for career: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _filterJobsByTitle(String title) {
    setState(() {
      _job = _jobCareer.where((item) {
        return removeDiacritics(item['title'].toLowerCase())
            .contains(removeDiacritics(title.toLowerCase()));
      }).toList();
    });
  }

  void _filterJobsBySalary(String salary) {
    setState(() {
      salary == 'Tất cả'
          ? _filterJobsByTitle(title!)
          : _job = _job.where((item) {
              return removeDiacritics(item['salary'].toLowerCase())
                  .contains(removeDiacritics(salary.toLowerCase()));
            }).toList();
    });
  }

  void _filterJobsByExperience(String experience) {
    setState(() {
      experience == 'Tất cả'
          ? _filterJobsByTitle(title!)
          : _job = _job.where((item) {
              return removeDiacritics(item['experience'].toLowerCase())
                  .contains(removeDiacritics(experience.toLowerCase()));
            }).toList();
    });
  }

  void _showExperienceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chọn số năm kinh nghiệm',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    TextButton(onPressed: () {}, child: const Text('Xong'))
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: experience.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(experience[index]),
                      onTap: () {
                        setState(
                          () {
                            _experienceController.text = experience[index];
                            _filterJobsByExperience(_experienceController.text);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSalaryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chọn mức lương',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    TextButton(onPressed: () {}, child: const Text('Xong'))
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: salary.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(salary[index]),
                      onTap: () {
                        setState(
                          () {
                            _salaryController.text = salary[index];
                            _filterJobsBySalary(_salaryController.text);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_sharp),
                ),
                const Icon(
                  Icons.location_on_sharp,
                  color: Colors.blue,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    'Khu vực',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.blue,
                  size: 30,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.search,
                      size: 35,
                      color: Color.fromARGB(255, 166, 172, 178),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Text(
                        title!,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 166, 172, 178),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              Map<String, dynamic> data = {
                'title': title,
                'experience': _experienceController.text,
                'salary': _salaryController.text,
                'type': type
              };
              final result = await Get.toNamed('filterSearch', arguments: data);
              if (result != null) {
                setState(() {
                  _job = result['jobs'];
                  _experienceController.text = result['experience'];
                  title = result['title'];
                  type = result['type'];
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.filter_list,
                        size: 40,
                        color: _experienceController.text.isEmpty ||
                                _experienceController.text == 'Tất cả' ||
                                type.isEmpty
                            ? Colors.black
                            : Colors.blue,
                      ),
                      Text(
                        'Lọc',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.grey,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      elevation: 0,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: _experienceController.text.isEmpty ||
                                  _experienceController.text == 'Tất cả'
                              ? BorderSide(width: 1, color: Colors.grey)
                              : BorderSide(width: 1, color: Colors.blue)),
                    ),
                    onPressed: () {
                      _showExperienceBottomSheet(context);
                    },
                    child: Row(
                      children: [
                        Text(
                          _experienceController.text.isEmpty ||
                                  _experienceController.text == 'Tất cả'
                              ? 'Kinh nghiệm'
                              : _experienceController.text,
                          style: TextStyle(
                              fontSize: 16,
                              color: _experienceController.text.isEmpty ||
                                      _experienceController.text == 'Tất cả'
                                  ? Color.fromARGB(221, 42, 42, 42)
                                  : Colors.blue),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 30,
                          color: _experienceController.text.isEmpty ||
                                  _experienceController.text == 'Tất cả'
                              ? Colors.grey
                              : Colors.blue,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      elevation: 0,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: _salaryController.text.isEmpty ||
                                  _salaryController.text == 'Tất cả'
                              ? BorderSide(width: 1, color: Colors.grey)
                              : BorderSide(width: 1, color: Colors.blue)),
                    ),
                    onPressed: () {
                      _showSalaryBottomSheet(context);
                    },
                    child: Row(
                      children: [
                        Text(
                          _salaryController.text.isEmpty ||
                                  _salaryController.text == 'Tất cả'
                              ? 'Mức lương'
                              : _salaryController.text,
                          style: TextStyle(
                              fontSize: 16,
                              color: _salaryController.text.isEmpty ||
                                      _salaryController.text == 'Tất cả'
                                  ? Color.fromARGB(221, 42, 42, 42)
                                  : Colors.blue),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 30,
                          color: _salaryController.text.isEmpty ||
                                  _salaryController.text == 'Tất cả'
                              ? Colors.grey
                              : Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    height: 680,
                    color: Colors.white,
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: JobGirdTitleVertical(
                          allJobs: _job,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
