import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foody_online_app/providers/manageMaps.dart';
import 'package:foody_online_app/screens/cart.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Maps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Provider.of<GenerateMaps>(context, listen: false).fetchMaps(),
          Positioned(
              top: 50.0,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: CartPage(), type: PageTransitionType.fade),
                  );
                },
              ))
        ],
      ),
    );
  }
}
