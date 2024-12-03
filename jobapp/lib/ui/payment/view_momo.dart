import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Web extends StatefulWidget {
  const Web({super.key});

  @override
  State<Web> createState() => _WebState();
}

class _WebState extends State<Web> {
  late final WebViewController controller;
  Map<String, dynamic> data = {};
  String url = '';
  @override
  void initState() {
    super.initState();
    data = Get.arguments;
    url = data['url'];
    int cid = data['cid'];
    int sv_id = data['sv_id'];
    String name = data['name'];
    String sv_name = data['sv_name'];
    int price = data['sv_price'];
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.contains('resultCode=0')) {
              insertPayment(cid, sv_id, name, sv_name, price, DateTime.now(),
                  false, 'MoMo');

              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            print('Web resource error: ${error.description}');
          },
          onPageFinished: (url) {},
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  Future<void> insertPayment(
    int cid,
    int svId,
    String name,
    String svName,
    int price,
    DateTime dayOrder,
    bool status,
    String pay,
  ) async {
    int day = extractNumberFromPackage(svName);
    DateTime serviceDay = DateTime.now().add(Duration(days: day));
    try {
      await Database()
          .insertPayment(cid, svId, name, svName, price, dayOrder, status, pay);
      await Database().updatePaymentCompany(cid, serviceDay);
      Get.offAllNamed('/companyScreen');
    } catch (e) {
      print(e);
    }
  }

  int extractNumberFromPackage(String package) {
    // Sử dụng biểu thức chính quy để tìm số trong chuỗi
    RegExp regExp = RegExp(r'\d+');
    var match = regExp.firstMatch(package);

    // Nếu tìm thấy số, chuyển đổi thành kiểu int, ngược lại trả về 0
    if (match != null) {
      return int.parse(match.group(0)!);
    } else {
      return 0; // Hoặc bạn có thể throw exception nếu cần
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
