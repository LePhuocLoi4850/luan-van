class Career {
  final String? id;
  final String name;
  final String image; // Thêm trường image
  bool isSelected;

  Career({
    this.id,
    required this.name,
    required this.image, // Cập nhật constructor để yêu cầu trường image
    this.isSelected = false,
  });

  Career copyWith({
    String? id,
    String? name,
    String? image, // Thêm trường image vào hàm copyWith
    bool? isSelected,
  }) {
    return Career(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image, // Bổ sung image vào đối tượng JSON được trả về
    };
  }

  static Career fromJson(Map<String, dynamic> json) {
    return Career(
      id: json['id'],
      name: json['name'],
      image: json['image'], // Lấy giá trị image từ JSON
    );
  }
}

class CareerManager {
  final List<Career> allCareer = [
    Career(
      name: 'IT(Công nghệ thông tin)',
      image:
          'https://tse1.mm.bing.net/th?id=OIP.hqiFNyWMmX6d8cOea4LGzQHaE8&pid=Api&P=0&h=220',
    ),
    Career(
      name: 'Việc nhà',
      image:
          'https://tse2.mm.bing.net/th?id=OIP.mivntFv1Gmp23_7WQEoR8AHaHa&pid=Api&P=0&h=220',
    ),
    Career(
      name: 'Tư vấn',
      image:
          'https://tse4.mm.bing.net/th?id=OIP.7Alm5Q8p2NOO7ctwep2QLQHaHa&pid=Api&P=0&h=220',
    ),
    Career(
      name: 'Gia sư',
      image:
          'https://tse1.mm.bing.net/th?id=OIP.vje1AxYC9vRdDEhL2JeQjwHaHa&pid=Api&P=0&h=220',
    ),
    Career(
      name: 'Freelancer',
      image:
          'https://tse2.mm.bing.net/th?id=OIP.s7ok4DuXvDJTgSNQT032GQHaHa&pid=Api&P=0&h=220',
    ),
    Career(
      name: 'Làm đẹp',
      image: 'https://example.com/lamdep.jpg',
    ),
    Career(
      name: 'Sự kiện',
      image: 'https://example.com/sukien.jpg',
    ),
    Career(
      name: 'Nhân viên kho',
      image: 'https://example.com/nhanvienkho.jpg',
    ),
    Career(
      name: 'Kinh doanh',
      image: 'https://example.com/kinhdoanhbanhang.jpg',
    ),
    Career(
      name: 'Marketing',
      image: 'https://example.com/marketing.jpg',
    ),
    Career(
      name: 'PG-PB',
      image: 'https://example.com/pgpb.jpg',
    ),
    Career(
      name: 'Giải trí',
      image: 'https://example.com/giaitri.jpg',
    ),
    Career(
      name: 'Part-time',
      image: 'https://example.com/baohiem.jpg',
    ),
    Career(
      name: 'Bất động sản',
      image: 'https://example.com/batdongsan.jpg',
    ),
    Career(
      name: 'Y tế',
      image: 'https://example.com/yte.jpg',
    ),
    Career(
      name: 'Giáo dục',
      image: 'https://example.com/giaoduc.jpg',
    ),
    Career(
      name: 'Du lịch',
      image: 'https://example.com/dulich.jpg',
    ),
    Career(
      name: 'Thư kí',
      image: 'https://example.com/thuki.jpg',
    ),
    Career(
      name: 'Kiến trúc/Thiết kế nội thất',
      image: 'https://example.com/kientruc.jpg',
    ),
    Career(
      name: 'Ngân hàng',
      image: 'https://example.com/nganhang.jpg',
    ),
    Career(
      name: 'Khách sạn',
      image: 'https://example.com/khachsan.jpg',
    ),
    Career(
      name: 'Thời trang',
      image: 'https://example.com/thoitrang.jpg',
    ),
    Career(
      name: 'Kế toán',
      image: 'https://example.com/ketoan.jpg',
    ),
    Career(
      name: 'Thực tập sinh',
      image: 'https://example.com/thuctapsinh.jpg',
    ),
    Career(
      name: 'Thiết kế đồ họa',
      image: 'https://example.com/thietkedohoa.jpg',
    ),
    Career(
      name: 'Xây dựng',
      image: 'https://example.com/xaydung.jpg',
    ),
  ];

  void selectCareer(String careerName) {
    for (var career in allCareer) {
      if (career.name == careerName) {
        career.isSelected = !career.isSelected;
      }
    }
  }
}
