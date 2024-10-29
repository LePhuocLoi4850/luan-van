class Address {
  final String ten;

  Address({
    required this.ten,
  });

  Address copyWith({
    String? ten,
  }) {
    return Address(
      ten: ten ?? this.ten,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ten': ten,
    };
  }
}

class AddressManager {
  final List<Address> allAddress = [
    Address(ten: "Tất cả"),
    Address(ten: "Hà Nội"),
    Address(ten: "Hồ Chí Minh"),
    Address(ten: "Cần Thơ"),
    Address(ten: "An Giang"),
    Address(ten: "Bà Rịa - Vũng Tàu"),
    Address(ten: "Bắc Giang"),
    Address(ten: "Bắc Kạn"),
    Address(ten: "Bạc Liêu"),
    Address(ten: "Bắc Ninh"),
    Address(ten: "Bến Tre"),
    Address(ten: "Bình Định"),
    Address(ten: "Bình Dương"),
    Address(ten: "Bình Phước"),
    Address(ten: "Bình Thuận"),
    Address(ten: "Cà Mau"),
    Address(ten: "Cao Bằng"),
    Address(ten: "Đắk Lắk"),
    Address(ten: "Đắk Nông"),
    Address(ten: "Điện Biên"),
    Address(ten: "Đồng Nai"),
    Address(ten: "Đồng Tháp"),
    Address(ten: "Gia Lai"),
    Address(ten: "Hà Giang"),
    Address(ten: "Hà Nam"),
    Address(ten: "Hà Tĩnh"),
    Address(ten: "Hải Dương"),
    Address(ten: "Hải Phòng"),
    Address(ten: "Hậu Giang"),
    Address(ten: "Hòa Bình"),
    Address(ten: "Hưng Yên"),
    Address(ten: "Khánh Hòa"),
    Address(ten: "Kiên Giang"),
    Address(ten: "Kon Tum"),
    Address(ten: "Lai Châu"),
    Address(ten: "Lâm Đồng"),
    Address(ten: "Lạng Sơn"),
    Address(ten: "Lào Cai"),
    Address(ten: "Long An"),
    Address(ten: "Nam Định"),
    Address(ten: "Nghệ An"),
    Address(ten: "Ninh Bình"),
    Address(ten: "Ninh Thuận"),
    Address(ten: "Phú Thọ"),
    Address(ten: "Phú Yên"),
    Address(ten: "Quảng Bình"),
    Address(ten: "Quảng Nam"),
    Address(ten: "Quảng Ngãi"),
    Address(ten: "Quảng Ninh"),
    Address(ten: "Quảng Trị"),
    Address(ten: "Sóc Trăng"),
    Address(ten: "Sơn La"),
    Address(ten: "Tây Ninh"),
    Address(ten: "Thái Bình"),
    Address(ten: "Thái Nguyên"),
    Address(ten: "Thanh Hóa"),
    Address(ten: "Thừa Thiên Huế"),
    Address(ten: "Tiền Giang"),
    Address(ten: "Trà Vinh"),
    Address(ten: "Tuyên Quang"),
    Address(ten: "Vĩnh Long"),
    Address(ten: "Vĩnh Phúc"),
    Address(ten: "Yên Bái"),
    Address(ten: "Đà Nẵng"),
  ];
}
