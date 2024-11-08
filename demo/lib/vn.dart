import 'package:flutter/material.dart';
import 'package:vnpay_flutter/vnpay_flutter.dart';

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  bool isLoading = false;
  String responseCode = '';
  Future<void> onPayment() async {
    try {
      setState(() {
        isLoading = false;
      });
      final paymentUrl = await VNPAYFlutter.instance.generatePaymentUrl(
        url: 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
        version: '1.0.3',
        tmnCode: '4EUDD9OP',
        txnRef: DateTime.now().millisecondsSinceEpoch.toString(),
        orderInfo: 'Pay 30.000 VND',
        amount: 30000,
        returnUrl: 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
        ipAdress: '10.0.2.2',
        vnpayHashKey: '2NN2SRGO9KKZ46UW5FCPDTYIQF0WPGDA',
        vnPayHashType: VNPayHashType.HMACSHA512,
        vnpayExpireDate: DateTime.now().add(const Duration(hours: 1)),
      );

      await VNPAYFlutter.instance.show(
        paymentUrl: paymentUrl,
        onPaymentSuccess: (params) {
          setState(() {
            responseCode = params['vnp_ResponseCode'] ?? '';
          });
        },
        onPaymentError: (params) {
          setState(() {
            responseCode = 'Error';
          });
        },
      );
      setState(() {
        isLoading = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        responseCode = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Response Code: $responseCode'),
                  TextButton(
                    onPressed: onPayment,
                    child: const Text('30.000VND'),
                  ),
                ],
              ),
            ),
    );
  }
}
