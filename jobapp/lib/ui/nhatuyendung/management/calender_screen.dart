import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/controller/calender_controller.dart';
import 'package:jobapp/models/calender.dart';

import '../../../models/wards_data.dart';
import '../../../server/database.dart';
import '../../auth/auth_controller.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  final AuthController controller = Get.find<AuthController>();
  final CalenderController calenderController = Get.find<CalenderController>();

  String? _selectedCity;
  String? _selectedDistrict;
  String? _selectedWard;
  DateTime? _selectedDate;
  String? _houseNumberStreet;
  String? address;
  String? time;
  String note = '';
  String? name;
  DateTime? createAt;
  bool isLoading = false;
  TimeOfDay? selectedTime;
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  Orientation? orientation;
  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  bool use24HourTime = false;

  final _houseNumberStreetController = TextEditingController();
  final _nameController = TextEditingController();
  final _dayController = TextEditingController();
  final _noteController = TextEditingController();

  Future<void> _handleInsertCertificate() async {
    setState(() {
      isLoading = true;
    });
    int cid = controller.companyModel.value.id!;
    name = _nameController.text;
    time = '${selectedTime!.format(context)} ${_dayController.text}';
    address =
        '$_houseNumberStreet, $_selectedWard, $_selectedDistrict, $_selectedCity';
    createAt = DateTime.now();
    note = _noteController.text;

    try {
      print('time: $time, address: $address');
      final cldId = await Database()
          .insertCalender(cid, name!, time!, address!, createAt!, note);
      print(createAt);
      Map<String, dynamic> cld = {
        'cld_id': cldId,
        'cid': cid,
        'name': name,
        'time': time,
        'address': address,
        'createAt': createAt,
        'note': note,
      };
      calenderController.addCld(Calender.fromMap(cld));
      setState(() {
        isLoading = false;
      });
      Get.back(result: true);
    } catch (e) {
      print('Thêm lịch phỏng vấn lỗi: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dayController.text =
            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mẫu lịch phỏng vấn'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Tên mẫu lịch',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Nhập tên mẫu lịch',
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        controller: _nameController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Chọn ngày',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 160,
                                child: TextFormField(
                                  readOnly: true,
                                  onTap: () => _selectDate(context),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.date_range_outlined,
                                      color: Colors.grey[800],
                                    ),
                                    hintText: '0000-00-00',
                                    hintStyle: TextStyle(fontSize: 18),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  controller: _dayController,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Chọn giờ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize: const Size(100, 58),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.timelapse_rounded,
                                        color: Colors.grey[800],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Center(
                                        child: selectedTime != null
                                            ? Text(
                                                selectedTime!.format(context),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            : Text(
                                                '00:00 PM',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black54),
                                              ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () async {
                                    final TimeOfDay? time =
                                        await showTimePicker(
                                      context: context,
                                      initialTime:
                                          selectedTime ?? TimeOfDay.now(),
                                      initialEntryMode: entryMode,
                                      orientation: orientation,
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            materialTapTargetSize:
                                                tapTargetSize,
                                          ),
                                          child: Directionality(
                                            textDirection: textDirection,
                                            child: MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
                                                alwaysUse24HourFormat:
                                                    use24HourTime,
                                              ),
                                              child: child!,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    setState(() {
                                      selectedTime = time;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Địa điểm',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.location_on_outlined,
                                color: Colors.grey[800],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            hint: const Text('Chọn Tỉnh/Thành phố'),
                            value: _selectedCity,
                            items: wardsData.keys.map((String city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCity = newValue;
                                _selectedDistrict = null;
                                _selectedWard = null;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng chọn Tỉnh/Thành phố';
                              }
                              return null;
                            },
                          ),
                          if (_selectedCity != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 20),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                hint: const Text('Chọn Quận/Huyện'),
                                value: _selectedDistrict,
                                items: wardsData[_selectedCity]!.entries.map(
                                    (MapEntry<String, List<String>> entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Text(entry.key),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedDistrict = newValue;
                                    _selectedWard = null;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng chọn Quận/Huyện';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          if (_selectedDistrict != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 20),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                hint: const Text('Chọn Phường/Xã'),
                                value: _selectedWard,
                                items: wardsData[_selectedCity]![
                                        _selectedDistrict]!
                                    .map((String ward) {
                                  return DropdownMenuItem<String>(
                                    value: ward,
                                    child: Text(ward),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedWard = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng chọn Xã/Phường';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          if (_selectedWard != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 20),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Nhập số nhà và tên đường',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                controller: _houseNumberStreetController,
                                onChanged: (value) {
                                  setState(() {
                                    _houseNumberStreet = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập số nhà và tên đường';
                                  }
                                  return null;
                                },
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Ghi chú',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Ghi chú',
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        controller: _noteController,
                        maxLines: 3,
                        maxLength: 255,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: () {
              _handleInsertCertificate();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Thêm',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
