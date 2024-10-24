class Location {
  final String? id;
  final String name;
  bool isSelected;
  Location({
    this.id,
    required this.name,
    this.isSelected = false,
  });

  Location copyWith({
    String? id,
    String? name,
    bool? isSelected,
  }) {
    return Location(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class LocationManager {
  final List<Location> allLocation = [
    Location(name: 'Hà Nội'),
    Location(name: 'Hồ Chí Minh'),
    Location(name: 'Đà Nẵng'),
    Location(name: 'Hải Phòng'),
    Location(name: 'Cần Thơ'),
    Location(name: 'An Giang'),
    Location(name: 'Bà Rịa - Vũng Tàu'),
    Location(name: 'Bắc Giang'),
    Location(name: 'Bắc Kạn'),
    Location(name: 'Bạc Liêu'),
    Location(name: 'Bắc Ninh'),
    Location(name: 'Bến Tre'),
    Location(name: 'Bình Định'),
    Location(name: 'Bình Dương'),
    Location(name: 'Bình Phước'),
    Location(name: 'Bình Thuận'),
    Location(name: 'Cà Mau'),
    Location(name: 'Cao Bằng'),
    Location(name: 'Đắk Lắk'),
    Location(name: 'Đắk Nông'),
    Location(name: 'Điện Biên'),
    Location(name: 'Đồng Nai'),
    Location(name: 'Đồng Tháp'),
    Location(name: 'Gia Lai'),
    Location(name: 'Hà Giang'),
    Location(name: 'Hà Nam'),
    Location(name: 'Hà Tĩnh'),
    Location(name: 'Hải Dương'),
    Location(name: 'Hậu Giang'),
    Location(name: 'Hòa Bình'),
    Location(name: 'Hưng Yên'),
    Location(name: 'Khánh Hòa'),
    Location(name: 'Kiên Giang'),
    Location(name: 'Kon Tum'),
    Location(name: 'Lai Châu'),
    Location(name: 'Lâm Đồng'),
    Location(name: 'Lạng Sơn'),
    Location(name: 'Lào Cai'),
    Location(name: 'Long An'),
    Location(name: 'Nam Định'),
    Location(name: 'Nghệ An'),
    Location(name: 'Ninh Bình'),
    Location(name: 'Ninh Thuận'),
    Location(name: 'Phú Thọ'),
    Location(name: 'Quảng Bình'),
    Location(name: 'Quảng Nam'),
    Location(name: 'Quảng Ngãi'),
    Location(name: 'Quảng Ninh'),
    Location(name: 'Quảng Trị'),
    Location(name: 'Sóc Trăng'),
    Location(name: 'Sơn La'),
    Location(name: 'Tây Ninh'),
    Location(name: 'Thái Bình'),
    Location(name: 'Thái Nguyên'),
    Location(name: 'Thanh Hóa'),
    Location(name: 'Thừa Thiên Huế'),
    Location(name: 'Tiền Giang'),
    Location(name: 'Trà Vinh'),
    Location(name: 'Tuyên Quang'),
    Location(name: 'Vĩnh Long'),
    Location(name: 'Vĩnh Phúc'),
    Location(name: 'Yên Bái'),
  ];
  void selectLocation(String LocationName) {
    for (var Location in allLocation) {
      if (Location.name == LocationName) {
        Location.isSelected =
            !Location.isSelected; // Đảo ngược trạng thái isSelected
      }
    }
  }
}
