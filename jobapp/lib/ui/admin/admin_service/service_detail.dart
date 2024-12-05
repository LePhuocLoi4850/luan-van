import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobapp/server/database.dart';

class ServiceDetail extends StatefulWidget {
  const ServiceDetail({super.key});

  @override
  State<ServiceDetail> createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _companyList = [];
  List<Map<String, dynamic>> _invoiceList = [];
  bool isLoading = false;
  int? svId;
  @override
  void initState() {
    super.initState();
    svId = Get.arguments;
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      _companyList = await Database().fetchCompaniesBoughtService(svId!);
      _invoiceList = await Database().fetchInvoicesForService(svId!);
    } catch (e) {
      print('Fetch data error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết dịch vụ'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Danh sách công ty'),
            Tab(text: 'Danh sách hóa đơn'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCompanyList(),
                _buildInvoiceList(),
              ],
            ),
    );
  }

  Widget _buildCompanyList() {
    return ListView.builder(
      itemCount: _companyList.length,
      itemBuilder: (context, index) {
        final company = _companyList[index];
        return ExpansionTile(
          title: Text(company['name']),
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: Database().fetchInvoicesForCompany(svId!, company['cid']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có hóa đơn nào.'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final invoice = snapshot.data![index];
                      return ListTile(
                        title: Text(invoice['sv_name']),
                        subtitle: Text('${invoice['price']} VNĐ'),
                        trailing: Text(invoice['day_order'].toString()),
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildInvoiceList() {
    return ListView.builder(
      itemCount: _invoiceList.length,
      itemBuilder: (context, index) {
        final invoice = _invoiceList[index];
        return GestureDetector(
          onTap: () {
            Map<String, dynamic> data = {
              'pay_id': invoice['pay_id'],
              'day_order': invoice['day_order'],
              'sv_name': invoice['sv_name'],
              'price': invoice['price'],
              'pay': invoice['pay'],
              'cid': invoice['cid'],
              'name': invoice['name'],
            };
            Get.toNamed('/payDetailScreenAdmin', arguments: data);
          },
          child: Card(
            elevation: 1,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(15),
              leading: Icon(
                Icons.shopify_outlined,
                color: Colors.blue,
                size: 40,
              ),
              title: Text(
                invoice['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${formatCurrency(invoice['price'].toDouble())} VND',
                    style: TextStyle(
                      color: Colors.green, // Màu xanh lá cây cho giá tiền
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    DateFormat('yyyy-MM-dd HH:mm:ss')
                        .format(invoice['day_order']),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              trailing:
                  Icon(Icons.arrow_forward_ios, size: 18), // Thêm icon mũi tên
            ),
          ),
        );
      },
    );
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat("#,##0", "en_US");
    return formatter.format(amount);
  }
}
