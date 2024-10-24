import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../models/career.dart';
import '../../../models/experience.dart';
import '../../../models/location.dart';
import '../../screens.dart';
import 'list_user.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  CareerManager careerManager = CareerManager();
  Career? selectedCareer;
  LocationManager locationManager = LocationManager();
  Location? selectedLocation;
  ExperienceManager experienceManager = ExperienceManager();
  Experience? selectedExperience;
  bool showGenderOptions = false;
  List<dynamic> userList = [];
  List<dynamic> filteredUserList = [];
  final _gioitinhController = TextEditingController();

  String? selectedGender;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<dynamic> data = await DatabaseConnection().selectAllUsers();
    setState(() {
      userList = data;
      filteredUserList = data;
    });
  }

  void _filterUserList() {
    print('bắt đầu tìm');

    setState(() {
      if (selectedCareer == 'IT(Công nghệ thông tin)' &&
          _gioitinhController.text == '' &&
          selectedLocation == null) {
        filteredUserList = userList;
      } else {
        filteredUserList = userList.where((user) {
          final careerMatch = selectedCareer == null ||
              user[7].toLowerCase() == selectedCareer!.name.toLowerCase();

          final genderMatch = _gioitinhController.text == 'Không yêu cầu' ||
              user[6] == _gioitinhController.text;

          final locationMatch = selectedLocation == null ||
              removeDiacritics(user[8].toLowerCase()).contains(
                  removeDiacritics(selectedLocation!.name.toLowerCase()));
          print("Career Match: $careerMatch");
          print("Gender Match: $_gioitinhController");
          print(selectedLocation!.name);
          return careerMatch || locationMatch || genderMatch;
        }).toList();
      }
      print(filteredUserList);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SearchResultsPage(filteredUserList: filteredUserList),
      ),
    );
  }

  void _showCareerListBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: careerManager.allCareer.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(careerManager.allCareer[index].name),
              onTap: () {
                setState(() {
                  selectedCareer = careerManager.allCareer[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showLocationListBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: locationManager.allLocation.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(locationManager.allLocation[index].name),
              onTap: () {
                setState(() {
                  selectedLocation = locationManager.allLocation[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showExperienceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: experienceManager.allExperience.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(experienceManager.allExperience[index].name),
              onTap: () {
                setState(() {
                  selectedExperience = experienceManager.allExperience[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tìm kiếm ứng viên',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                ),
                child: Text(
                  'Ngành nghề tìm kiếm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: () {
                  _showCareerListBottomSheet(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius:
                          BorderRadius.circular(10), // Độ cong của góc
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              selectedCareer?.name ?? 'IT(Công nghệ thông tin)',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down_sharp,
                              color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, top: 10),
                child: Text(
                  'Địa điểm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: () {
                  _showLocationListBottomSheet(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius:
                          BorderRadius.circular(10), // Độ cong của góc
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              selectedLocation?.name ?? 'Địa điểm',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down_sharp,
                              color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, top: 10),
                child: Text(
                  'Giới tính',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Không yêu cầu',
                          groupValue: _gioitinhController.text,
                          onChanged: (value) {
                            setState(() {
                              _gioitinhController.text = value!;
                              showGenderOptions = false;
                            });
                          },
                        ),
                        const Text(
                          'Không yêu cầu',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Radio(
                          value: 'Chọn giới tính',
                          groupValue: _gioitinhController.text,
                          onChanged: (value) {
                            setState(() {
                              _gioitinhController.text = value!;
                              showGenderOptions = true;
                            });
                          },
                        ),
                        const Text(
                          'Chọn giới tính',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: showGenderOptions,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildGenderButton('Nam'),
                          _buildGenderButton('Nữ'),
                          _buildGenderButton('Khác'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, top: 10),
                child: Text(
                  'Kinh nghiệm yêu cầu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: () {
                  _showExperienceBottomSheet(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius:
                          BorderRadius.circular(10), // Độ cong của góc
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              selectedExperience?.name ?? 'Chọn kinh nghiệm',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down_sharp,
                              color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: 400,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                      onPressed: () {
                        _filterUserList();
                      },
                      child: const Text(
                        'Tìm kiếm',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderButton(String gender) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 251, 227, 255)),
        color: selectedGender == gender
            ? const Color.fromARGB(255, 241, 206, 247)
            : null, // Màu chỉ khi được chọn
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            _gioitinhController.text = gender;
            selectedGender = gender; // Cập nhật giới tính được chọn
          });
        },
        child: Text(gender, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
