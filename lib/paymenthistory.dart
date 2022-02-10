import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/order.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({ Key? key }) : super(key: key);

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List orderlist = [];
  String titlecenter = "Loading data...";
  late double screenHeight, screenWidth, resWidth;
  late ScrollController _scrollController;
  int scrollcount = 5;
  int rowcount = 2;
  int numprd = 0;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }

  return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
          centerTitle: true,
          title: const Text("Payment History"),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Center(
        child: Column(children: <Widget>[
          const SizedBox(height:10),
          const Text(
            "Payment History",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height:8),
          Flexible(
            flex:1,
            child: Container(
              decoration: const BoxDecoration(        
                image: DecorationImage(image: AssetImage('assets/images/img_paymenthistory.png'), alignment: Alignment.topCenter, fit: BoxFit.fitWidth),
              ),
            ),),
          orderlist == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: const TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ))))
              : Expanded(
                  child: ListView.builder(
                      itemCount: orderlist == null ? 0 : orderlist.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: InkWell(
                                onTap: () => _prodDetails(index),
                                child: Card(
                                  elevation: 10,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                                orderlist[index]['paymentID'],
                                            style:
                                                const TextStyle(color: Colors.black),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                                orderlist[index]['billID'],
                                            style:
                                                const TextStyle(color: Colors.black),
                                          )),
                                          Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                              "RM " +
                                                orderlist[index]['total'],
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                orderlist[index]['date'],
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          )),
                                          Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                orderlist[index]['paidStatus'],
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                )));
                      }))
        ]),
      ),
    );
  }
  String truncateString(String str) {
    if (str.length > 15) {
      str = str.substring(0, 15);
      return str + "...";
    } else {
      return str;
    }
  }

  _prodDetails(int index) {
    Order order = Order(
        paymentID: orderlist[index]['paymentID'],
        billID: orderlist[index]['billID'],
        total: orderlist[index]['total'],
        paidStatus: orderlist[index]['paidStatus'],
        date: orderlist[index]['date'],
    );
  }

  void _loadPaymentHistory() {
    http.post(Uri.parse(Config.server + "/sbusiness/php/load_paymenthistory.php"),
        body: {}).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        print(response.body);
        var extractdata = data['data'];
        setState(() {
          orderlist = extractdata["payment"];
        });
      } else {
        setState(() {
          titlecenter = "No Data";
        });
      }
    });
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (orderlist.length > scrollcount) {
          scrollcount = scrollcount + 10;
          if (scrollcount >= orderlist.length) {
            scrollcount = orderlist.length;
          }
        }
      });
    }
  }
}