import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:idcardku/model/payment_model.dart';
import 'package:idcardku/model/response_model.dart';
import 'package:idcardku/model/user_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  final User user;
  final Payment payment;

  const PaymentPage({super.key, required this.user, required this.payment});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String errorMessage = "";
  bool loading = false;

  Future<void> check() async {
    setState(() {
      errorMessage = "";
      loading = true;
    });

    final rawResponse = await http.get(
      Uri.parse(
        "https://mwsapi.safatanc.com/payment/reference_id/${widget.payment.referenceId}",
      ),
    );

    final Map parseResponse = json.decode(rawResponse.body);

    final response = APIResponse.fromJson(parseResponse);

    if (response.code == 200) {
      final payment = Payment.fromJson(response.data);

      if (payment.status != "PENDING") {
        Navigator.of(context).pop();
      }
    } else {
      setState(() {
        errorMessage = response.message;
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.payment.url));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          title: const Text(
            "Payment",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: WebViewWidget(controller: controller),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.green,
                  ),
                  width: MediaQuery.sizeOf(context).width,
                  child: TextButton(
                    onPressed: () {
                      check();
                    },
                    style: const ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    child: const Text(
                      "Confirm/Refresh Payment",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
