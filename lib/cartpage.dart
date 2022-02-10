import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:project/mainpage.dart';
import 'package:project/payment.dart';
import 'package:project/product.dart';
import 'package:http/http.dart' as http;
import 'package:project/user.dart';
import 'config.dart';

class CartPage extends StatefulWidget {
  final User user;
  const CartPage({ Key? key, required this.user }) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double price = 0.0, totalP = 0.0, cartqty = 0.0, sum= 0.0;
  List productlist = [];
  String titlecenter = "Loading data...";
  late double screenHeight, screenWidth, resWidth;
  late ScrollController _scrollController;
  int scrollcount = 10;
  int rowcount = 2;
  int numprd = 0;
  int quantity = 1;
  bool _isChecked = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadProducts();
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (content)=> MainPage(user: widget.user)))),
          backgroundColor: Colors.deepPurple[300],
          centerTitle: true,
          title: const Text("MY CART"),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_basket),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(user: widget.user)));
              },
          ),
        ],
        ), 
        body: productlist.isEmpty
            ? Center(
                child: Text(titlecenter,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)))
            : Column(
                children: [
                  const SizedBox(height:5),
                  const Text("Content of your Cart", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height:3),
                  Text("Total " + numprd.toString() + " items", style: const TextStyle(fontStyle: FontStyle.italic)),
                  const SizedBox(height:5),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: rowcount,
                      childAspectRatio: screenWidth / (screenHeight / 2),
                      controller: _scrollController,
                      children: List.generate(scrollcount, (index) {                       
                        cartqty = double.parse(productlist[index]['cartQuantity'].toString());
                        price = double.parse(productlist[index]['productPrice'].toString());
                        totalP = cartqty * price;
                        sum = sum + totalP;
                        return Card(
                          shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.grey.withOpacity(1),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          ),
                        child: InkWell(
                          onTap: () => {_prodDetails(index)},
                          child: Column(
                            children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                            truncateString(productlist[index]['productName'].toString()),
                                            style: TextStyle(
                                                fontSize: resWidth * 0.05,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height:2),        
                                        Text("RM " + 
                                            truncateString(productlist[index]['productPrice'].toString()),
                                            style: TextStyle(
                                                fontSize: resWidth * 0.04,
                                                fontWeight: FontWeight.bold), textAlign: TextAlign.center), 
                                        const SizedBox(height:2),        
                                        Text("Qty: " + 
                                            truncateString(productlist[index]['cartQuantity'].toString()),
                                            style: TextStyle(
                                                fontSize: resWidth * 0.04,
                                                fontWeight: FontWeight.bold), textAlign: TextAlign.center),          
                                      ],
                                    ),
                                  ), 
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                          value: _isChecked,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _isChecked = value!;
                                            });
                                          },
                                ),Text('Total: RM ' + totalP.toStringAsFixed(2),),
                                ],
                                ),
                                ),
                            ],
                          ),
                        ));
                      }),
                    ),
                  ),
                  Text('Total: RM ' + sum.toStringAsFixed(2), style: const TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.payment_rounded),
                    label: const Text('Proceed To Payment', style: TextStyle(fontSize:18)),
                      onPressed: () => _makePaymentDialog(),
                        style: ElevatedButton.styleFrom(
                        side: const BorderSide(width: 2.0, color: Colors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),                          
                ],
              ),
        ));
  }

  void _makePaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Proceed With Payment?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                makePayment();
              },
            ),
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _loadProducts() {
    http.post(Uri.parse(Config.server + "/sbusiness/php/load_cart.php"),
        body: {}).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        print(response.body);
        var extractdata = data['data'];
        setState(() {
          productlist = extractdata["products"];
          numprd = productlist.length;
          if (scrollcount >= productlist.length) {
            scrollcount = productlist.length;
          }
        });
      } else {
        setState(() {
          titlecenter = "No Data";
        });
      }
    });
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
    Product product = Product(
        productID: productlist[index]['productID'],
        productName: productlist[index]['productName'],
        productDescription: productlist[index]['productDescription'],
        productPrice: productlist[index]['productPrice'],
        productQuantity: productlist[index]['productQuantity'],
        productState: productlist[index]['productState'],
        productLoc: productlist[index]['productLoc'],
        cartQuantity: productlist[index]['cartQuantity']);  
    _onDeleteProduct(index);
}   

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (productlist.length > scrollcount) {
          scrollcount = scrollcount + 10;
          if (scrollcount >= productlist.length) {
            scrollcount = productlist.length;
          }
        }
      });
    }
  }

   Future<void> makePayment() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentScreen(
                  user: widget.user,
                  val: sum.toStringAsFixed(2),
                )));
  }

  _onDeleteProduct(int index){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Delete this product",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle(fontSize:17)),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(fontSize:20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct (index);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(fontSize:20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

void _deleteProduct(int index) {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Deleting product.."),
        title: const Text("Processing..."));
    progressDialog.show();
    http.post(Uri.parse(Config.server + "/sbusiness/php/delete_cartProduct.php"),
        body: {
          "productName": productlist[index]['productName'],
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            fontSize: 14.0);
        progressDialog.dismiss();
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      }
    });
  }
}