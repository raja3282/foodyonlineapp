import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foody_online_app/constant/const.dart';
import 'package:foody_online_app/helper/order_services.dart';
import 'package:foody_online_app/providers/order_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  OrderServices _OrderServices = OrderServices();
  User user = FirebaseAuth.instance.currentUser;

  int tag = 0;
  List<String> options = [
    'All Orders',
    'Ordered',
    'Accepted',
    'Picked Up',
    'On the way',
    'Delivered',
    'Rejected',
  ];
  @override
  Widget build(BuildContext context) {
    var _orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: kcolor2,
        title: Text(
          'My Orders',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: ChipsChoice<int>.single(
              choiceActiveStyle: C2ChoiceStyle(
                color: Colors.teal,
              ),
              choiceStyle: C2ChoiceStyle(
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
              value: tag,
              onChanged: (val) => setState(() {
                if (val == 0) {
                  setState(() {
                    _orderProvider.status = null;
                  });
                }
                setState(() {
                  tag = val;
                  _orderProvider.filterOrder(options[val]);
                });
              }),
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _OrderServices.orders
                  .where('userId', isEqualTo: user.uid)
                  .where('orderStatus',
                      isEqualTo: tag > 0 ? _orderProvider.status : null)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data.size == 0) {
                  //TODO no order screen
                  return Center(
                    child: Text(tag > 0
                        ? 'No ${options[tag]} orders'
                        : 'No Orders. Continue Shopping'),
                  );
                }

                return Expanded(
                  child: new ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return new Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            ListTile(
                              horizontalTitleGap: 0,
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 14,
                                child: _OrderServices.statusIcon(document),
                              ),
                              title: Text(
                                document.data()['orderStatus'],
                                style: TextStyle(
                                    fontSize: 12,
                                    color: _OrderServices.statusColor(document),
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'On ${DateFormat.yMMMd().format(
                                  DateTime.parse(document.data()['timestamp']),
                                )}',
                                style: TextStyle(fontSize: 12),
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Payment : ${document.data()['cod']}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Amount : PKR ${document.data()['total'].toStringAsFixed(0)}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            document.data()['orderStatus'] == 'Ordered'
                                ? Container()
                                : document.data()['orderStatus'] == 'Rejected'
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: ListTile(
                                            tileColor: Colors.grey,
                                            leading: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: Image.network(
                                                  document.data()['deliveryBoy']
                                                      ['image'],
                                                  fit: BoxFit.contain,
                                                )),
                                            title: Text(
                                                document.data()['deliveryBoy']
                                                    ['name'],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                )),
                                            subtitle: Text(
                                                _OrderServices.statusComment(
                                                    document),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                )),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                document.data()[
                                                            'orderStatus'] ==
                                                        'On the way'
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        child: IconButton(
                                                          icon: Icon(Icons.map),
                                                          color: Colors.green,
                                                          onPressed: () {
                                                            GeoPoint location =
                                                                document.data()[
                                                                        'deliveryBoy']
                                                                    [
                                                                    'location'];
                                                            _OrderServices.launchMap(
                                                                location,
                                                                document.data()[
                                                                        'deliveryBoy']
                                                                    ['name']);
                                                          },
                                                        ),
                                                      )
                                                    : Container(),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: IconButton(
                                                    icon: Icon(Icons.phone),
                                                    color: Colors.green,
                                                    onPressed: () {
                                                      _OrderServices.launchCall(
                                                          'tel:${document.data()['deliveryBoy']['phone']}');
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                            ExpansionTile(
                              title: Text(
                                'Order details',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              subtitle: Text(
                                'View order details',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        //radius: 20,
                                        backgroundColor: Colors.white,
                                        child: Image.network(
                                            document.data()['products'][index]
                                                ['productImage']),
                                      ),
                                      title: Text(
                                        document.data()['products'][index]
                                            ['productName'],
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      subtitle: Text(
                                        '${document.data()['products'][index]['quantity'].toString()} x PKR ${document.data()['products'][index]['productPrice'].toString()}',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    );
                                  },
                                  itemCount: document.data()['products'].length,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 8, bottom: 8),
                                  child: Card(
                                    //color: Colors.grey[200],
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Discount : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              ),
                                              Text(
                                                document
                                                    .data()['discount']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 13),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Delivery Fee : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              ),
                                              Text(
                                                document
                                                    .data()['deliverFee']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 13),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              height: 3,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
