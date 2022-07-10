import 'dart:async';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/user.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final double totalpayable;

  const PaymentScreen(
      {Key? key, required this.user, required this.totalpayable})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
        backgroundColor:Color.fromARGB(255,155,36,36),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: WebView(
              initialUrl: CONSTANTS.server +
                  '/mytutor_app/php/payment.php?email=' +
                  widget.user.email.toString() +
                  '&mobile=' +
                  widget.user.phoneno.toString() +
                  '&name=' +
                  widget.user.name.toString() +
                  '&amount=' +
                  widget.totalpayable.toString(),
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
            ),
          )
        ],
      )
    );
  }
}