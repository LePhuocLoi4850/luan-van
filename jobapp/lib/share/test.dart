import 'package:flutter/material.dart';

class CityDistrictSelection extends StatefulWidget {
  const CityDistrictSelection({super.key});

  @override
  _CityDistrictSelectionState createState() => _CityDistrictSelectionState();
}

class _CityDistrictSelectionState extends State<CityDistrictSelection> {
  String? _selectedCity; // Tỉnh/Thành được chọn
  String? _selectedDistrict; // Quận/Huyện được chọn

  // Dữ liệu mẫu về tỉnh/thành và quận/huyện
  final Map<String, List<String>> _districts = {
    'Hà Nội': ['Quận Ba Đình', 'Quận Hoàn Kiếm', 'Quận Hai Bà Trưng'],
    'Hồ Chí Minh': ['Quận 1', 'Quận 3', 'Quận 5'],
    'Đà Nẵng': ['Quận Hải Châu', 'Quận Ngũ Hành Sơn', 'Quận Thanh Khê'],
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown cho Tỉnh/Thành
          DropdownButton<String>(
            hint: Text('Chọn Tỉnh/Thành phố'),
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
                _selectedDistrict =
                    null; // Đặt lại Quận/Huyện khi chọn Tỉnh/Thành mới
              });
            },
          ),
          SizedBox(height: 20),
          // Dropdown cho Quận/Huyện
          if (_selectedCity != null)
            DropdownButton<String>(
              hint: Text('Chọn Quận/Huyện'),
              value: _selectedDistrict,
              items: _districts[_selectedCity]!.map((String district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedDistrict = newValue;
                });
              },
            ),
        ],
      ),
    );
  }
}
