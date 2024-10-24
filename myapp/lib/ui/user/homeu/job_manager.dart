import 'package:flutter/material.dart';
import '../../../ui/screens.dart';

class JobManager with ChangeNotifier {
  List<Job> jobList = [
    Job(
      id: 1,
      name: 'Kỹ sư phần mềm',
      image: 'assets/images/imageJ.jpg',
      salary: 15000000,
      category: 'Toàn thời gian',
      address: 'Cầu Giấy, Hà Nội',
      quantity: 3,
      schedule: 'Thứ Hai - Thứ Sáu',
      gender: 'Không yêu cầu',
      age: '25-35',
      education: 'Đại học',
      experience: '3 năm',
      career: 'Công nghệ thông tin',
      description: 'Phát triển và duy trì các ứng dụng phần mềm.',
      otherRequirements: 'Có khả năng làm việc nhóm tốt.',
      benefits: 'Bảo hiểm y tế, Du lịch công ty',
      creatorId: 123,
    ),
    Job(
      id: 2,
      name: 'Nhân viên bán hàng',
      image: 'assets/images/imageJ.jpg',
      salary: 10000000,
      category: 'Bán thời gian',
      address: 'Bình Thạnh, TP. Hồ Chí Minh',
      quantity: 5,
      schedule: 'Thứ Hai - Thứ Bảy',
      gender: 'Nữ',
      age: '18-25',
      education: 'Cao đẳng',
      experience: '1 năm',
      career: 'Bán lẻ',
      description: 'Tư vấn và bán sản phẩm cho khách hàng.',
      otherRequirements: 'Giao tiếp tốt, ngoại hình ưa nhìn.',
      benefits: 'Hoa hồng bán hàng',
      creatorId: 124,
    ),
    Job(
      id: 3,
      name: 'Gia sư trực tuyến',
      image: 'assets/images/imageJ.jpg',
      salary: 8000000,
      category: 'Bán thời gian',
      address: 'Q1, TP. Hồ Chí Minh',
      quantity: 5,
      schedule: 'Thứ Hai - Thứ Bảy',
      gender: 'Nữ',
      age: '18-25',
      education: 'Cao đẳng',
      experience: '1 năm',
      career: 'Bán lẻ',
      description: 'Tư vấn và bán sản phẩm cho khách hàng.',
      otherRequirements: 'Giao tiếp tốt, ngoại hình ưa nhìn.',
      benefits: 'Hoa hồng bán hàng',
      creatorId: 124,
    ),
  ];

  List<Job> get _jobList {
    return [...jobList];
  }

  Job? findById(String id) {
    try {
      return jobList.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }
}
