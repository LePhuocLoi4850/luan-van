import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';

import '../../../models/career.dart';
import '../../auth/auth_controller.dart';

class SearchUvScreen extends StatefulWidget {
  const SearchUvScreen({super.key});

  @override
  State<SearchUvScreen> createState() => _SearchUvScreenState();
}

class _SearchUvScreenState extends State<SearchUvScreen> {
  final AuthController controller = Get.find<AuthController>();
  String? title;
  String? _selectedCity;
  Career? selectedCareer;
  int? _salaryFrom;
  int? _salaryTo;
  CareerManager careerManager = CareerManager();
  List<Career> filteredCareerList = CareerManager().allCareer;

  final _careerController = TextEditingController();
  final _searchController = TextEditingController();
  final _experienceController = TextEditingController();
  final _salaryController = TextEditingController();
  final _addressController = TextEditingController();
  final _educationController = TextEditingController();
  final _genderController = TextEditingController();

  bool isLoading = true;
  Map<String, dynamic> data = {};
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _originalUsers = [];
  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
    setState(() {});
  }

  void searchUser() {
    setState(() {
      _fetchAllUsers();
      String career = removeDiacritics(_careerController.text.toLowerCase());
      print(career);
      String experience =
          removeDiacritics(_experienceController.text.toLowerCase());

      String address = removeDiacritics(_addressController.text.toLowerCase());
      String education =
          removeDiacritics(_educationController.text.toLowerCase());
      String gender = removeDiacritics(_genderController.text.toLowerCase());

      List<Map<String, dynamic>> filteredUsers = _originalUsers.where((item) {
        bool matchesCareer = career.isEmpty ||
            removeDiacritics(item['career'].toLowerCase()).contains(career);

        bool matchesExperience = experience.isEmpty ||
            removeDiacritics(item['experience'].toLowerCase())
                .contains(experience);

        bool matchesSalary = (_salaryFrom == null ||
                int.parse(item['salaryFrom']) <= _salaryTo!) &&
            (_salaryTo == null || int.parse(item['salaryTo']) >= _salaryFrom!);
        print('$_salaryFrom và $_salaryTo');

        bool matchesAddress = address.isEmpty ||
            removeDiacritics(item['address'].toLowerCase()).contains(address);
        bool matchesEducation = education.isEmpty ||
            (item['education'] != null &&
                removeDiacritics(item['education'].toLowerCase())
                    .contains(education));
        bool matchesGender = gender.isEmpty ||
            removeDiacritics(item['gender'].toLowerCase()).contains(gender);
        return matchesCareer &&
            matchesExperience &&
            matchesSalary &&
            matchesAddress &&
            matchesEducation &&
            matchesGender;
      }).toList();
      setState(() {
        _allUsers = filteredUsers;
        print(_allUsers);
      });
    });
  }

  void _fetchAllUsers() async {
    try {
      _originalUsers = await Database().fetchAllUsers();
      _allUsers = List.from(_originalUsers);
      print(_originalUsers);
    } catch (e) {
      print(e);
    }
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
                            experience[index] == 'Tất cả'
                                ? _experienceController.text = ''
                                : _experienceController.text =
                                    experience[index];
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

    super.dispose();
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

  void _showEducationBottomSheet(BuildContext context) {
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
                      'Chọn trình độ học vấn',
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
                  itemCount: education.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(education[index]),
                      onTap: () {
                        setState(
                          () {
                            _educationController.text = education[index];
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

  void _showGenderBottomSheet(BuildContext context) {
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
                      'Chọn giới tính',
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
                  itemCount: gender.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(gender[index]),
                      onTap: () {
                        setState(
                          () {
                            _genderController.text = gender[index];
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
            'Lựa chọn tìm kiếm',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0)),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        bottom: 10,
                      ),
                      child: Text(
                        'Ngành nghề tìm kiếm',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showCareerBottomSheet(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _careerController.text.isEmpty
                                          ? 'Lựa chọn ngành nghề'
                                          : _careerController.text,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        bottom: 10,
                      ),
                      child: Text(
                        'Kinh nghiệm',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showExperienceBottomSheet(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _experienceController.text.isEmpty ||
                                              _experienceController.text ==
                                                  'Tất cả'
                                          ? 'Chọn kinh nghiệm'
                                          : _experienceController.text,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        bottom: 10,
                      ),
                      child: Text(
                        'Mức lương',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showSalaryBottomSheet(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _salaryController.text.isEmpty ||
                                              _salaryController.text == 'Tất cả'
                                          ? 'Chọn mức lương'
                                          : _salaryController.text,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 20.0,
                            bottom: 10,
                          ),
                          child: Text(
                            'Địa điểm',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          iconSize: 30,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          hint: const Text(
                            'Chọn Tỉnh/Thành phố',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          value: _selectedCity,
                          items: _districts.keys.map((String city) {
                            return DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCity = newValue;
                              _addressController.text = newValue ?? '';
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        bottom: 10,
                      ),
                      child: Text(
                        'Trình độ học vấn',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showEducationBottomSheet(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _educationController.text.isEmpty ||
                                              _educationController.text ==
                                                  'Không yêu cầu'
                                          ? 'Trình độ học vấn'
                                          : _educationController.text,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        bottom: 10,
                      ),
                      child: Text(
                        'Giới tính',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showGenderBottomSheet(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _genderController.text.isEmpty ||
                                              _genderController.text ==
                                                  'Không yêu cầu'
                                          ? 'Chọn giới tính'
                                          : _genderController.text,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: BottomAppBar(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          searchUser();
                          Get.toNamed('/userGird', arguments: _allUsers);
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
      ),
    );
  }

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
  List<String> education = [
    'Không yêu cầu',
    'Chưa tốt nghiệp THPT',
    'Tốt nghiệp THPT',
    'Tốt nghiệp Trung cấp',
    'Tốt nghiệp Cao đẳng',
    'Tốt nghiệp Đại học',
    'Trên đại học',
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
  List<String> gender = ['Nam', 'Nữ', 'Không yêu cầu'];
  List<String> type = [
    'Toàn thời gian',
    'Bán thời gian',
    'Thực tập sinh',
  ];
  final Map<String, List<String>> _districts = {
    'Hà Nội': [
      'Quận Ba Đình',
      'Quận Hoàn Kiếm',
      'Quận Hai Bà Trưng',
      'Quận Đống Đa',
      'Quận Cầu Giấy',
      'Quận Tây Hồ',
      'Quận Thanh Xuân',
      'Quận Hoàng Mai',
      'Quận Long Biên',
      'Quận Bắc Từ Liêm',
      'Quận Nam Từ Liêm',
      'Huyện Thanh Trì',
      'Huyện Gia Lâm',
      'Huyện Đông Anh',
      'Huyện Sóc Sơn',
      'Huyện Hoài Đức',
      'Huyện Quốc Oai',
      'Huyện Thanh Oai',
      'Huyện Thường Tín',
      'Huyện Phú Xuyên',
      'Huyện Ba Vì',
      'Huyện Phúc Thọ',
      'Huyện Chương Mỹ',
      'Huyện Đan Phượng',
      'Huyện Mỹ Đức',
      'Huyện Thạch Thất',
      'Huyện Ứng Hòa',
      'Thị xã Sơn Tây'
    ],
    'Hồ Chí Minh': [
      'Quận 1',
      'Quận 3',
      'Quận 4',
      'Quận 5',
      'Quận 6',
      'Quận 7',
      'Quận 8',
      'Quận 10',
      'Quận 11',
      'Quận 12',
      'Quận Bình Thạnh',
      'Quận Tân Bình',
      'Quận Tân Phú',
      'Quận Phú Nhuận',
      'Quận Gò Vấp',
      'Quận Bình Tân',
      'Quận Thủ Đức',
      'Huyện Nhà Bè',
      'Huyện Hóc Môn',
      'Huyện Củ Chi',
      'Huyện Bình Chánh',
      'Huyện Cần Giờ'
    ],
    'Đà Nẵng': [
      'Quận Hải Châu',
      'Quận Thanh Khê',
      'Quận Sơn Trà',
      'Quận Ngũ Hành Sơn',
      'Quận Liên Chiểu',
      'Quận Cẩm Lệ',
      'Huyện Hòa Vang',
      'Huyện Hoàng Sa'
    ],
    'Hải Phòng': [
      'Quận Hồng Bàng',
      'Quận Lê Chân',
      'Quận Ngô Quyền',
      'Quận Kiến An',
      'Quận Hải An',
      'Quận Đồ Sơn',
      'Quận Dương Kinh',
      'Huyện An Dương',
      'Huyện An Lão',
      'Huyện Kiến Thụy',
      'Huyện Tiên Lãng',
      'Huyện Vĩnh Bảo',
      'Huyện Thủy Nguyên',
      'Huyện Cát Hải',
      'Huyện Bạch Long Vĩ'
    ],
    'Cần Thơ': [
      'Quận Ninh Kiều',
      'Quận Bình Thủy',
      'Quận Cái Răng',
      'Quận Ô Môn',
      'Quận Thốt Nốt',
      'Huyện Phong Điền',
      'Huyện Thới Lai',
      'Huyện Cờ Đỏ',
      'Huyện Vĩnh Thạnh'
    ],
    'Bà Rịa - Vũng Tàu': [
      'Thành phố Vũng Tàu',
      'Thành phố Bà Rịa',
      'Huyện Châu Đức',
      'Huyện Đất Đỏ',
      'Huyện Long Điền',
      'Huyện Tân Thành',
      'Huyện Xuyên Mộc',
      'Huyện Côn Đảo'
    ],
  };
}
