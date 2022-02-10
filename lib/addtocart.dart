import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:project/product.dart';
import 'package:project/productpage.dart';
import 'package:project/user.dart';
import 'config.dart';

class AddToCart extends StatefulWidget {
  final User user;
  final Product product;
  const AddToCart({ Key? key, required this.product, required this.user}) : super(key: key);

  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  double price = 0.0, totalP = 0.0, cartqty = 0;
  late double screenHeight, screenWidth, resWidth;
  var pathAsset = "assets/images/logo_camera.png";
  final _formKey = GlobalKey<FormState>();
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();

  final TextEditingController _productNameEditingController = TextEditingController();
  final TextEditingController _productDescriptionEditingController = TextEditingController();
  final TextEditingController _productPriceEditingController = TextEditingController();
  final TextEditingController _productQuantityEditingController = TextEditingController();
  final TextEditingController _productStateEditingController = TextEditingController();
  final TextEditingController _productLocEditingController = TextEditingController();
  final TextEditingController _cartQuantityEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productNameEditingController.text = widget.product.productName.toString();
    _productDescriptionEditingController.text = widget.product.productDescription.toString();
    _productPriceEditingController.text = widget.product.productPrice.toString();
    _productQuantityEditingController.text = widget.product.productQuantity.toString();
    _productStateEditingController.text = widget.product.productState.toString();
    _productLocEditingController.text = widget.product.productLoc.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
         leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (content)=> ProductPage(user: widget.user)))),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: resWidth,
            child: Column(
              children: [
                CachedNetworkImage(
                  width: screenWidth,
                  fit: BoxFit.scaleDown,
                    imageUrl: Config.server +
                      "/sbusiness/images/products/" +
                      widget.product.productID.toString() +
                      ".png",
                    placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                ),                
                Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              enabled: false,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus);
                              },
                              controller: _productNameEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Product Name',
                                  labelStyle: TextStyle(),
                                  icon: Icon(
                                    Icons.create,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              enabled: false,
                              focusNode: focus,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus1);
                              },
                              maxLines: 5,
                              controller: _productDescriptionEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Product Description',
                                  alignLabelWithHint: true,
                                  labelStyle: TextStyle(),
                                  icon: Icon(
                                    Icons.description_outlined,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  )
                                )
                              ),
                          Row(
                            children: [
                              Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    enabled: false,
                                    focusNode: focus1,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context).requestFocus(focus2);
                                    },
                                    controller: _productPriceEditingController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Product Price',
                                        labelStyle: TextStyle(),
                                        icon: Icon(
                                          Icons.price_change_outlined
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ))),
                              ),
                              Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    enabled: false,
                                    focusNode: focus2,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context).requestFocus(focus3);
                                    },
                                    controller: _productQuantityEditingController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Product Quantity',
                                        labelStyle: TextStyle(),
                                        icon: Icon(
                                          Icons.production_quantity_limits,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ))),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    enabled: false,
                                    controller: _productStateEditingController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        labelText: 'Current States',
                                        labelStyle: TextStyle(),
                                        icon: Icon(
                                          Icons.flag,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ))),
                              ),
                              Flexible(
                                  flex: 5,
                                  child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      enabled: false,
                                      validator: (val) =>
                                          val!.isEmpty || (val.length < 3)
                                              ? "Current Locality"
                                              : null,
                                      controller: _productLocEditingController,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                          labelText: 'Current Locality',
                                          labelStyle: TextStyle(),
                                          icon: Icon(
                                            Icons.map,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 2.0),
                                          )))),

                            ],
                          ),
                          const SizedBox(height: 20),
                            
                          Row(
                            children: [
                              Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    validator: (val) => val!.isEmpty
                                        ? "Quantity should be more than 0"
                                        : null,
                                    controller: _cartQuantityEditingController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        labelText: 'Select quantity of product',
                                        labelStyle: TextStyle(),
                                        icon: Icon(
                                          Icons.shopping_basket_outlined,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ))),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton.icon(
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text('Add To Cart', style: TextStyle(fontSize:18)),
                            onPressed: () => _newProductDialog(),
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(width: 2.0, color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                          )  ,                                      
              ]),
          )))]))))
        );
  }

  void _newProductDialog() {
    cartqty = double.parse(_cartQuantityEditingController.text);
    price = double.parse(_productPriceEditingController.text);
    totalP = cartqty * price;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Add to cart",
            style: TextStyle(),
          ),
          content: Text("Are you sure? \nTotal Price: RM " + totalP.toStringAsFixed(2), style: const TextStyle(fontSize: 18)),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _addToCart();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
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

void _addToCart() {
    String _productName = _productNameEditingController.text;
    String _productDescription = _productDescriptionEditingController.text;
    String _productPrice = _productPriceEditingController.text;
    String _productQuantity = _productQuantityEditingController.text;
    String _productState = _productStateEditingController.text;
    String _productLoc = _productLocEditingController.text;
    String _cartQuantity = _cartQuantityEditingController.text;

    FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).unfocus();
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Adding to cart.."),
        title: const Text("Processing..."));
    progressDialog.show();
    http.post(Uri.parse(Config.server + "/sbusiness/php/insert_cart.php"), body: {
      "productName": _productName,
      "productDescription": _productDescription,
      "productPrice": _productPrice,
      "productQuantity": _productQuantity,
      "productState": _productState,
      "productLoc": _productLoc,
      "cartQuantity": _cartQuantity,
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      }
    });
    progressDialog.dismiss();
  }  
}
