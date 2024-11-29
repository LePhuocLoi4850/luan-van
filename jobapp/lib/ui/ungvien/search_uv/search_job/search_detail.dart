import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../../../../models/address.dart';
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
  List<Map<String, dynamic>> _allJob = [];
  List<Map<String, dynamic>> _job = [];
  List<Map<String, dynamic>> _jobAll = [];
  List<Map<String, dynamic>> _jobSearch = [];
  bool isLoading = true;
  bool _isFiltered = true;
  String type = '';
  String career = '';
  String? title;
  int? _salaryFrom;
  int? _salaryTo;
  final _experienceController = TextEditingController();
  final _salaryController = TextEditingController();
  Address? selectedAddress;
  AddressManager addressManager = AddressManager();
  List<Address> filteredAddressList = AddressManager().allAddress;
  final _searchController = TextEditingController();
  final _addressController = TextEditingController();
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
      _fetchAllJob();
    }
    setState(() {});
  }

  void _fetchAllJob() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      _allJob = await Database().fetchAllJobSearch(false);
      _job = _allJob;
      _filterJobsByTitle(title!);
    } catch (e) {
      print('select error job for title: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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

  void _filterJobsByTitle(String title) {
    setState(() {
      _isFiltered = true;
      _job = _allJob.where((item) {
        return removeDiacritics(item['title'].toLowerCase())
            .contains(removeDiacritics(title.toLowerCase()));
      }).toList();

      print(_job);
      _jobAll = _allJob.where((item) {
        return removeDiacritics(item['title'].toLowerCase())
            .contains(removeDiacritics(title.toLowerCase()));
      }).toList();
      _job.sort((a, b) =>
          (b['service_day'] ?? DateTime.fromMillisecondsSinceEpoch(0))
              .compareTo(
                  a['service_day'] ?? DateTime.fromMillisecondsSinceEpoch(0)));
      _jobAll.sort((a, b) =>
          (b['service_day'] ?? DateTime.fromMillisecondsSinceEpoch(0))
              .compareTo(
                  a['service_day'] ?? DateTime.fromMillisecondsSinceEpoch(0)));
    });
  }

  void _filterJobsBySalary(String salary) {
    setState(() {
      _isFiltered = false;
      salary == 'Tất cả'
          ? setState(() {
              salary = '';
              _applyFilters();
            })
          : _applyFilters();
    });
  }

  void _filterJobsByExperience(String experience) {
    setState(() {
      _isFiltered = false;

      experience == 'Tất cả'
          ? setState(() {
              experience = '';
              _applyFilters();
            })
          : _applyFilters();
    });
  }

  void _filterJobsByAddress(String address) {
    setState(() {
      _isFiltered = false;

      address == 'Tất cả'
          ? setState(() {
              address = '';
              _applyFilters();
            })
          : _applyFilters();
    });
  }

  void _applyFilters() {
    _job = _allJob.where((item) {
      return removeDiacritics(item['title'].toLowerCase())
          .contains(removeDiacritics(title!.toLowerCase()));
    }).toList();

    if (_salaryFrom != null || _salaryTo != null) {
      _job = _job.where((item) {
        final salaryFrom = int.parse(item['salaryFrom']);
        final salaryTo = int.parse(item['salaryTo']);
        return (_salaryFrom == null || salaryFrom <= _salaryTo!) &&
            (_salaryTo == null || salaryTo >= _salaryFrom!);
      }).toList();
    }

    if (_experienceController.text != 'Tất cả') {
      _job = _job.where((item) {
        return removeDiacritics(item['experience'].toLowerCase()).contains(
            removeDiacritics(_experienceController.text.toLowerCase()));
      }).toList();
    }

    if (_addressController.text != 'Tất cả' && _addressController.text != '') {
      _job = _job.where((item) {
        return removeDiacritics(item['address'].toLowerCase())
            .contains(removeDiacritics(_addressController.text.toLowerCase()));
      }).toList();
    }

    if (career != '') {
      _job = _job.where((item) {
        return removeDiacritics(item['careerJ'].toLowerCase())
            .contains(removeDiacritics(career.toLowerCase()));
      }).toList();
    }
    if (type != '') {
      _job = _job.where((item) {
        return removeDiacritics(item['type'].toLowerCase())
            .contains(removeDiacritics(type.toLowerCase()));
      }).toList();
    }
  }

  void _showAddressBottomSheet(
      BuildContext context, Function updateParentState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (ctx, setState) {
          List<Address> filteredAddress = addressManager.allAddress
              .where((address) => removeDiacritics(address.ten.toLowerCase())
                  .contains(
                      removeDiacritics(_searchController.text.toLowerCase())))
              .toList();

          return FractionallySizedBox(
            heightFactor: 0.85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Chọn vị trí',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_rounded),
                      hintText: 'Tìm kiếm',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchController.text = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredAddress.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: ListTile(
                            title: Text(filteredAddress[index].ten),
                            onTap: () {
                              setState(() {
                                selectedAddress = filteredAddress[index];
                                _addressController.text =
                                    filteredAddress[index].ten;
                                _filterJobsByAddress(_addressController.text);
                              });
                              Navigator.of(context).pop();
                              updateParentState();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
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
    final salaryRanges = {
      'Tất cả': [0, 100],
      'Dưới 10 triệu': [1, 9],
      '10 - 15 triệu': [10, 15],
      '15 - 20 triệu': [15, 20],
      '20 - 25 triệu': [20, 25],
      '25 - 30 triệu': [25, 30],
      'Trên 30 triệu': [30, 100],
      'Thỏa thuận': [0, 0],
    };
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
                            final selectedRange = salaryRanges[salary[index]]!;
                            _salaryController.text = salary[index];
                            _salaryFrom = selectedRange[0];
                            _salaryTo = selectedRange[1];
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

  void clearFiltersIfAllSelected() {
    List<TextEditingController> controllers = [
      _addressController,
      _experienceController,
      _salaryController,
    ];

    setState(() {
      for (var controller in controllers) {
        if (controller.text == 'Tất cả') {
          controller.text = '';
        }
      }
    });
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
                GestureDetector(
                  onTap: () {
                    _showAddressBottomSheet(context, () {
                      setState(() {});
                    });
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          _addressController.text == '' ||
                                  _addressController.text == 'Tất cả'
                              ? 'Khu vực'
                              : _addressController.text,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ],
                  ),
                ),
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
              clearFiltersIfAllSelected();
              _jobSearch = List.from(_jobAll);
              Map<String, dynamic> data = {
                'job': _jobSearch,
                'title': title,
                'address': _addressController.text,
                'experience': _experienceController.text,
                'salary': _salaryController.text,
                'career': career,
                'type': type
              };
              final result = await Get.toNamed('filterSearch', arguments: data);
              if (result != null) {
                setState(
                  () {
                    _job = result['job'];
                    title = result['title'];
                    _addressController.text = result['address'];
                    _experienceController.text = result['experience'];
                    _salaryController.text = result['salary'];
                    career = result['career'];
                    type = result['type'];
                    print('công việc khi lọc: $_job');
                  },
                );
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
                        color: _isFiltered ? Colors.black : Colors.blue,
                      ),
                      Text(
                        'Lọc',
                        style: TextStyle(
                          fontSize: 18,
                          color: _isFiltered ? Colors.black : Colors.blue,
                        ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 650,
                      color: Colors.white,
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: JobGirdTitleVertical(
                            allJobs: _job,
                            imageDecorator: (serviceDay) {
                              return _getServiceDayBorder(serviceDay);
                            },
                          ),
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
