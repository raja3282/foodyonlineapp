import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foody_online_app/constant/const.dart';
import 'package:foody_online_app/helper/Maps.dart';
import 'package:foody_online_app/helper/screen_navigation.dart';
import 'package:foody_online_app/models/cartModel.dart';
import 'package:foody_online_app/providers/manageMaps.dart';
import 'package:foody_online_app/providers/my_provider.dart';
import 'package:foody_online_app/screens/menu.dart';
import 'package:page_transition/page_transition.dart';

import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var textstyle = TextStyle(color: Colors.grey);
  int deliveryFee = 100;
  int discount = 50;
  DateTime datetime = new DateTime.now();
  @override
  void initState() {
    Provider.of<GenerateMaps>(context, listen: false).getCurrentLocation();
    super.initState();
  }

  @override
  Widget Cartitem(
      {@required image,
      @required name,
      @required price,
      @required comparedPrice,
      @required quantity,
      @required Function onTap,
      @required Function increment,
      @required Function decrement}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[100],
              offset: Offset(1, 1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Image.network(
                    image,
                    height: 65.0,
                    width: 65.0,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 200,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: name + '\n',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              TextSpan(
                                text: 'price:' + price.toString() + '\n',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: 'Quantity:' + quantity.toString() + '\n',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: 'Total: Rs' +
                                    (quantity * price).toString() +
                                    '\n',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      IconButton(
                        iconSize: 36,
                        icon: Icon(Icons.delete_outline_rounded),
                        onPressed: () {
                          onTap();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        decrement();
                      });
                    },
                    child: Container(
                      height: 37,
                      width: 37,
                      decoration: BoxDecoration(
                        color: Colors.red[500],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      quantity.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        increment();
                      });
                    },
                    child: Container(
                      height: 37,
                      width: 37,
                      decoration: BoxDecoration(
                        color: Colors.red[500],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    MyProvider provider = Provider.of<MyProvider>(context);
    int bill = provider.total();
    var _payable = bill + deliveryFee - discount;
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: kcolor2, //Color(0xff213777),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                changeScreenReplacement(context, Menu());
              },
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 100.0),
              child: Text(
                'CART',
                style: kappbarstyle,
              ),
            ),
          ),
          bottomSheet: provider.cartList.length > 0
              ? Container(
                  height: 178,
                  color: Colors.blueGrey[900],
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        height: 121,
                        color: Colors.white,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Deliver to this address',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                              child: Maps(),
                                              type: PageTransitionType
                                                  .rightToLeftWithFade),
                                        );
                                      },
                                      child: Text(
                                        'Mark',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, bottom: 3.0),
                                  child: Text(
                                    Provider.of<GenerateMaps>(context,
                                                listen: true)
                                            .getMainAddress ??
                                        Provider.of<GenerateMaps>(context,
                                                listen: true)
                                            .getFinalAddress,
                                    maxLines: 4,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'RS $_payable',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '(Including Taxes)',
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 10),
                                  ),
                                ],
                              ),
                              RaisedButton(
                                  child: Text(
                                    'CHECKOUT',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  color: Colors.redAccent,
                                  onPressed: () {
                                    provider.saveOrder(
                                        _payable,
                                        Provider.of<GenerateMaps>(context,
                                                    listen: false)
                                                .getMainAddress ??
                                            Provider.of<GenerateMaps>(context,
                                                    listen: false)
                                                .getFinalAddress,
                                        deliveryFee,
                                        discount);
                                    // Navigator.pop(context);

                                    setState(() {});
                                  })
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : noItemContainer(),
          body: Container(
            child: Column(
              children: [
                Container(
                    color: Colors.white,
                    height: 320,
                    child: ListView.builder(
                      itemCount: provider.cartList.length,
                      itemBuilder: (context, index) {
                        return Cartitem(
                            image: provider.cartList[index].image,
                            name: provider.cartList[index].name,
                            price: provider.cartList[index].price,
                            comparedPrice:
                                provider.cartList[index].comparedPrice,
                            quantity: provider.cartList[index].quantity,
                            onTap: () {
                              provider.deleteitemfromcart(index);
                            },
                            increment: () {
                              provider.increaseQuantity(index);
                            },
                            decrement: () {
                              provider.decreaseQuantity(index);
                            });
                      },
                    )),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bill Details',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Basket value',
                                    style: textstyle,
                                  ),
                                ),
                                Text(
                                  'Rs $bill',
                                  style: textstyle,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Discount',
                                    style: textstyle,
                                  ),
                                ),
                                Text(
                                  'Rs $discount',
                                  style: textstyle,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Delivery fee',
                                    style: textstyle,
                                  ),
                                ),
                                Text(
                                  'Rs $deliveryFee',
                                  style: textstyle,
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Total amount payable',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  'Rs $_payable',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Container noItemContainer() {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Container(
          height: 450,
          width: 450,
          child: Image.asset(
            'images/emptycart.png',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}
