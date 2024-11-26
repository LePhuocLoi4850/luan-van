import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/controller/calender_controller.dart';
import 'package:jobapp/models/calender.dart';

import '../../../models/wards_data.dart';
import '../../../server/database.dart';
import '../../auth/auth_controller.dart';

class CalenderDetail extends StatefulWidget {
  const CalenderDetail({super.key});

  @override
  State<CalenderDetail> createState() => _CalenderDetailState();
}

class _CalenderDetailState extends State<CalenderDetail> {
  final AuthController controller = Get.find<AuthController>();
  final CalenderController calenderController = Get.find<CalenderController>();
  int? cldId;
  String? _selectedCity;
  String? _selectedDistrict;
  String? _selectedWard;
  DateTime? _selectedDate;
  String? address;
  String? time;
  String note = '';
  String? name;
  String? day;
  String? hour;
  DateTime? createAt;
  bool isLoadingUpdate = false;
  bool isLoading = false;
  TimeOfDay? selectedTime;
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  Orientation? orientation;
  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  bool use24HourTime = false;

  late TextEditingController _houseNumberStreetController;
  final _nameController = TextEditingController();
  final _dayController = TextEditingController();
  final _noteController = TextEditingController();
  Map<String, dynamic> cldData = {};

  @override
  void initState() {
    super.initState();
    cldData = Get.arguments;
    fetchCalender();
  }

  void fetchCalender() async {
    setState(() {
      isLoading = true;
    });
    try {
      _nameController.text = cldData['name'];
      day = extractAfterM(cldData['time']);
      hour = extractBeforeM(cldData['time']);
      _dayController.text = day!;
      selectedTime = parseTimeOfDay(hour!);
      address = cldData['address'];
      List<String> parts = address!.split(", ");
      for (var part in parts) {
        if (part.contains("Phường")) {
          _selectedWard = part;
        } else if (part.contains("Xã")) {
          _selectedWard = part;
        } else if (part.contains("Thị")) {
          _selectedWard = part;
        } else if (part.contains("Quận")) {
          _selectedDistrict = part;
        } else if (part.contains("Huyện")) {
          _selectedDistrict = part;
        } else {
          _selectedCity = part;
        }
      }
      _houseNumberStreetController =
          TextEditingController(text: address!.split(",")[0]);
      _noteController.text = cldData['note'];
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('lỗi fetch calender: $e');
    }
  }

  void _handleUpdateCalender() async {
    setState(() {
      isLoadingUpdate = true;
    });
    int cldId = cldData['cld_id'];
    int cid = cldData['cid'];
    name = _nameController.text;
    time = '${selectedTime!.format(context)} ${_dayController.text}';
    address =
        '${_houseNumberStreetController.text}, $_selectedWard, $_selectedDistrict, $_selectedCity';
    String note = _noteController.text;
    print('$cldId, $cid, $name, $time, $address,$note');
    try {
      await Database()
          .updateCalender(cldId, name!, time!, address!, DateTime.now(), note);
      Calender updatedCalender = Calender(
          cldId: cldId,
          cid: cid,
          name: name!,
          time: time!,
          address: address!,
          createAt: DateTime.now(),
          note: note);
      calenderController.updateCld(cldId, updatedCalender);
      setState(() {
        isLoadingUpdate = false;
      });
      Get.back(result: true);
    } catch (e) {
      print(e);
    }
  }

  void _handleDelete(BuildContext context, String message, int cldId) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Database().deleteCalender(cldId);
              calenderController.removeCld(cldId);

              setState(() {});
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  TimeOfDay parseTimeOfDay(String timeString) {
    // Parse the input string and convert to TimeOfDay
    final format = RegExp(r'^(\d{1,2}):(\d{2})\s?(AM|PM)$');
    final match = format.firstMatch(timeString);

    if (match == null) {
      throw FormatException('Invalid time format: $timeString');
    }

    final hour = int.parse(match.group(1)!); // Get the hour
    final minute = int.parse(match.group(2)!); // Get the minutes
    final period = match.group(3)!; // Get AM/PM

    // Convert hour to 24-hour format if needed
    final adjustedHour = (period == 'PM' && hour != 12)
        ? hour + 12
        : (period == 'AM' && hour == 12)
            ? 0
            : hour;

    return TimeOfDay(hour: adjustedHour, minute: minute);
  }

  String? extractBeforeM(String input) {
    final regex = RegExp(r'.*?M');
    final match = regex.firstMatch(input);
    return match?.group(0);
  }

  String? extractAfterM(String input) {
    final regex = RegExp(r'(?<=M\s).*');
    final match = regex.firstMatch(input);
    return match?.group(0);
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
                                  setState(() {});
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
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          _handleDelete(
                              context,
                              'Bạn có muốn xóa lịch phỏng vấn',
                              cldData['cld_id']);
                        },
                        child: Text(
                          'Xóa mẫu',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
              ],
            ),
          ),
          if (isLoadingUpdate)
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
              _handleUpdateCalender();
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
