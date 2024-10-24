import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class SearchResultsPage extends StatelessWidget {
  final List<dynamic> filteredUserList;

  const SearchResultsPage({super.key, required this.filteredUserList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(filteredUserList.toString()),
      ),
      body: filteredUserList.isNotEmpty
          ? ListView.builder(
              itemCount: filteredUserList.length,
              itemBuilder: (context, index) {
                final user = filteredUserList[index];
                // final userId = user[0];
                final userName = user[3];
                final userPhone = user[4];
                final userBirthdate =
                    user[5].toString(); // This is a string in your data
                final userGender = user[6];
                final userCareer = user[7];
                final userAddress = user[8];

                final userDescription = user[9];

                final formattedBirthdate = userBirthdate == false
                    ? DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(userBirthdate))
                    : "Không có thông tin";

                return ListTile(
                  title: Text('Họ tên: $userName',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ngành nghề: $userCareer'),
                      Text('Địa chỉ: $userAddress'),
                      Text('Số điện thoại: $userPhone'),
                      Text('Ngày sinh: $formattedBirthdate'),
                      Text('Giới tính: $userGender'),
                      if (userDescription != null)
                        Text('Mô tả: $userDescription'),
                    ],
                  ),
                  onTap: () {},
                );
              },
            )
          : const Center(
              child: Text(
                'Không tìm thấy ứng viên nào',
                style: TextStyle(fontSize: 18),
              ),
            ),
    );
  }
}
