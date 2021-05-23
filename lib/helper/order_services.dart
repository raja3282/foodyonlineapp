import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderServices {
  CollectionReference orders =
      FirebaseFirestore.instance.collection('onlineOrder');

  Future<DocumentReference> saveOrder(Map<String, dynamic> data) {
    var result = orders.add(data);
    return result;
  }

  Color statusColor(document) {
    if (document.data()['orderStatus'] == 'Rejected') {
      return Colors.red;
    }
    if (document.data()['orderStatus'] == 'Accepted') {
      return Colors.blueGrey[400];
    }
    if (document.data()['orderStatus'] == 'Picked Up') {
      return Colors.pink[900];
    }
    if (document.data()['orderStatus'] == 'On the way') {
      return Colors.deepPurpleAccent;
    }
    if (document.data()['orderStatus'] == 'Delivered') {
      return Colors.green;
    }
    return Colors.orange;
  }

  Icon statusIcon(document) {
    if (document.data()['orderStatus'] == 'Rejected') {
      return Icon(
        Icons.cancel_presentation_rounded,
        color: statusColor(document),
        size: 18,
      );
    }
    if (document.data()['orderStatus'] == 'Accepted') {
      return Icon(
        Icons.assignment_turned_in_outlined,
        color: statusColor(document),
        size: 18,
      );
    }
    if (document.data()['orderStatus'] == 'Picked Up') {
      return Icon(
        Icons.cases,
        color: statusColor(document),
        size: 18,
      );
    }
    if (document.data()['orderStatus'] == 'On the way') {
      return Icon(
        Icons.delivery_dining,
        color: statusColor(document),
        size: 18,
      );
    }
    if (document.data()['orderStatus'] == 'Delivered') {
      return Icon(
        Icons.shopping_bag_outlined,
        color: statusColor(document),
        size: 18,
      );
    }
    return Icon(
      CupertinoIcons.square_list,
      color: Colors.orange,
      size: 18,
    );
  }

  String statusComment(document) {
    if (document.data()['orderStatus'] == 'Picked Up') {
      return 'Your order is Picked by ${document.data()['deliveryBoy']['name']}';
    }

    if (document.data()['orderStatus'] == 'On the way') {
      return 'Your delivery person ${document.data()['deliveryBoy']['name']} is on the way';
    }

    if (document.data()['orderStatus'] == 'Delivered') {
      return 'Your order has completed';
    }
    return 'Mr.${document.data()['deliveryBoy']['name']} is on the way to Pick your Order';
  }

  void launchCall(number) async => await canLaunch(number)
      ? await launch(number)
      : throw 'could not launch $number';

  void launchMap(GeoPoint location, name) async {
    final availableMaps = await MapLauncher.installedMaps;

    await availableMaps.first.showMarker(
        coords: Coords(location.latitude, location.longitude), title: name);
  }
}
