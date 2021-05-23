import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foody_online_app/constant/const.dart';
import 'package:foody_online_app/providers/manageMaps.dart';
import 'package:foody_online_app/screens/cart.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Maps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        height: 60,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
        child: FlatButton(
          color: kcolor2,
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: CartPage(), type: PageTransitionType.fade));
          },
          child: Text(
            'CONFIRM LOCATION',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w400, fontSize: 24),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                      height: 500,
                      child: Provider.of<GenerateMaps>(context, listen: false)
                          .fetchMaps()),
                ),
                Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      Provider.of<GenerateMaps>(context, listen: true)
                              .getMainAddress ??
                          Provider.of<GenerateMaps>(context, listen: true)
                              .getFinalAddress,
                      maxLines: 3,
                      style: TextStyle(
                          color: Colors.black,
                          //fontWeight: FontWeight.w100,
                          fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
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
                )),
          ],
        ),
      ),
    );
  }
}
