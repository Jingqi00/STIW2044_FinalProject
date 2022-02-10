import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'config.dart';
import 'user.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final String val;
    const PaymentScreen({Key? key, required this.user, required this.val})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PAYMENT'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl:Config.server +
                        '/sbusiness/php/orderpayment.php?email=' +
                        widget.user.email.toString() +
                        '&mobile=' +
                        widget.user.phoneno.toString() +
                        '&name=' +
                        widget.user.name.toString()  +
                        '&amount=' +
                        widget.val,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )
          ],
        ));
  }
}