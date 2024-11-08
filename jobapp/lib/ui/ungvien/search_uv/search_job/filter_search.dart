import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/models/career.dart';
import 'package:diacritic/diacritic.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';

import '../../../../models/address.dart';

class FilterSearch extends StatefulWidget {
  const FilterSearch({super.key});

  @override
  State<FilterSearch> createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {
  final AuthController controller = Get.find<AuthController>();
  String? title;
  int? _salaryFrom;
  int? _salaryTo;
  Address? selectedAddress;
  AddressManager addressManager = AddressManager();
  List<Address> filteredAddressList = AddressManager().allAddress;
  Career? selectedCareer;
  CareerManager careerManager = CareerManager();
  List<Career> filteredCareerList = CareerManager().allCareer;
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
  List<String> type = [
    'Toàn thời gian',
    'Bán thời gian',
    'Thực tập sinh',
  ];
  final _careerController = TextEditingController();
  final _searchController = TextEditingController();
  final _addressController = TextEditingController();
  final _experienceController = TextEditingController();
  final _salaryController = TextEditingController();
  final _typeController = TextEditingController();

  bool isLoading = true;
  Map<String, dynamic> data = {};
  List<Map<String, dynamic>> _job = [];
  @override
  void initState() {
    super.initState();
    data = Get.arguments;
    _job = List.from(data['job']);
    title = data['title'];
    _addressController.text = data['address'];
    _experienceController.text = data['experience'];
    _salaryController.text = data['salary'];

    _careerController.text = data['career'];
    _typeController.text = data['type'];
    setState(() {});
  }

  void searchJobs() {
    setState(() {
      String address = removeDiacritics(_addressController.text.toLowerCase());
      String career = removeDiacritics(_careerController.text.toLowerCase());

      String experience =
          removeDiacritics(_experienceController.text.toLowerCase());
      String type = removeDiacritics(_typeController.text.toLowerCase());
      _job = List.from(data['job']);
      _job = _job.where((item) {
        bool matChesAddress = address.isEmpty ||
            removeDiacritics(item['address'].toLowerCase()).contains(address);
        bool matchesExperience = experience.isEmpty ||
            removeDiacritics(item['experience'].toLowerCase())
                .contains(experience);
        bool matchesSalary = (_salaryFrom == null ||
                int.parse(item['salaryFrom']) <= _salaryTo!) &&
            (_salaryTo == null || int.parse(item['salaryTo']) >= _salaryFrom!);
        bool matchesCareer = career.isEmpty ||
            removeDiacritics(item['careerJ'].toLowerCase()).contains(career);
        bool matchesType = type.isEmpty ||
            removeDiacritics(item['type'].toLowerCase()).contains(type);

        return matChesAddress &&
            matchesCareer &&
            matchesExperience &&
            matchesSalary &&
            matchesType;
      }).toList();
    });
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
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chọn số năm kinh nghiệm',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    TextButton(onPressed: () {}, child: Text('Xong'))
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
    _experienceController.dispose();
    _typeController.dispose();
    _addressController.dispose();
    _salaryController.dispose();
    _careerController.dispose();
    super.dispose();
  }

  void _showTypeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chọn loại hình công việc',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    TextButton(onPressed: () {}, child: Text('Xong'))
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: type.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(type[index]),
                      onTap: () {
                        setState(
                          () {
                            _typeController.text = type[index];
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

  void _showCareerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (ctx, setState) {
          List<Career> filteredCareers = careerManager.allCareer
              .where((career) => removeDiacritics(career.name.toLowerCase())
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
                    'Chọn ngành nghề',
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
                      itemCount: filteredCareers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: ListTile(
                            title: Text(filteredCareers[index].name),
                            onTap: () {
                              setState(() {
                                selectedCareer = filteredCareers[index];
                                _careerController.text =
                                    filteredCareers[index].name;
                              });
                              Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0)),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showAddressBottomSheet(context, () {
                        setState(() {});
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.location_on_sharp,
                            size: 30, color: Colors.grey),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Khu vực',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right_sharp,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  _addressController.text.isEmpty ||
                          _addressController.text == 'Tất cả'
                      ? const SizedBox.shrink()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          onPressed: () {
                            setState(() {
                              _addressController.clear();
                            });
                          },
                          child: IntrinsicWidth(
                            child: Row(
                              children: [
                                Text(
                                  _addressController.text,
                                  style: TextStyle(color: Colors.blue),
                                ),
                                Icon(Icons.clear, color: Colors.blue)
                              ],
                            ),
                          ))
                ],
              ),
              Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showExperienceBottomSheet(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.business_center_rounded,
                            size: 30, color: Colors.grey),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kinh nghiệm',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right_sharp,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  _experienceController.text.isEmpty ||
                          _experienceController.text == 'Tất cả'
                      ? const SizedBox.shrink()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          onPressed: () {
                            setState(() {
                              _experienceController.clear();
                            });
                          },
                          child: IntrinsicWidth(
                            child: Row(
                              children: [
                                Text(
                                  _experienceController.text,
                                  style: TextStyle(color: Colors.blue),
                                ),
                                Icon(Icons.clear, color: Colors.blue)
                              ],
                            ),
                          ))
                ],
              ),
              Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showSalaryBottomSheet(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.monetization_on,
                            size: 30, color: Colors.grey),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mức lương',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right_sharp,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  _salaryController.text.isEmpty ||
                          _salaryController.text == 'Tất cả'
                      ? const SizedBox.shrink()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          onPressed: () {
                            setState(() {
                              _salaryController.clear();
                            });
                          },
                          child: IntrinsicWidth(
                            child: Row(
                              children: [
                                Text(
                                  _salaryController.text,
                                  style: TextStyle(color: Colors.blue),
                                ),
                                Icon(Icons.clear, color: Colors.blue)
                              ],
                            ),
                          ))
                ],
              ),
              Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showCareerBottomSheet(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.now_widgets_rounded,
                            size: 30, color: Colors.grey),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ngành nghề',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right_sharp,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  _careerController.text.isEmpty
                      ? const SizedBox.shrink()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          onPressed: () {
                            setState(() {
                              _careerController.clear();
                            });
                          },
                          child: IntrinsicWidth(
                            child: Row(
                              children: [
                                Text(
                                  _careerController.text,
                                  style: TextStyle(color: Colors.blue),
                                ),
                                Icon(Icons.clear, color: Colors.blue)
                              ],
                            ),
                          ))
                ],
              ),
              Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showTypeBottomSheet(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.note, size: 30, color: Colors.grey),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Loại hình',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right_sharp,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  _typeController.text.isEmpty
                      ? const SizedBox.shrink()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          onPressed: () {
                            setState(() {
                              _typeController.clear();
                            });
                          },
                          child: IntrinsicWidth(
                            child: Row(
                              children: [
                                Text(
                                  _typeController.text,
                                  style: TextStyle(color: Colors.blue),
                                ),
                                Icon(Icons.clear, color: Colors.blue)
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: BottomAppBar(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        searchJobs();

                        Map<String, dynamic> result = {
                          'job': _job,
                          'title': title,
                          'address': _addressController.text,
                          'experience': _experienceController.text,
                          'salary': _salaryController.text,
                          'career': _careerController.text,
                          'type': _typeController.text,
                        };
                        Get.back(result: result);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 11.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Tìm kiếm',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
