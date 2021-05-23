import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foody_online_app/constant/const.dart';
import 'package:foody_online_app/helper/screen_navigation.dart';
import 'package:foody_online_app/login/login.dart';
import 'package:foody_online_app/models/fooditemModel.dart';
import 'package:foody_online_app/providers/auth.dart';
import 'package:foody_online_app/providers/categoryprovider.dart';
import 'package:foody_online_app/providers/my_provider.dart';
import 'package:foody_online_app/screens/cart.dart';
import 'package:foody_online_app/screens/featured_products.dart';
import 'package:foody_online_app/screens/order_screen.dart';
import 'package:foody_online_app/welcome/welcome.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  // String user_email = MyProvider().getUserMail();
  final _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  List<Category> listcategory = [];

  Widget drawerItem({@required String name, @required IconData icon}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        name,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MyProvider provider2 = Provider.of<MyProvider>(context);
    final CategoryProvider provider = Provider.of<CategoryProvider>(context);
    var userDetails = Provider.of<Authentication>(context);
    userDetails.getUsereDtails();
    listcategory = provider.categories;

    int length = provider2.cartList.length;
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              userDetails.snapshot == null
                  ? UserAccountsDrawerHeader(
                      accountName: Text(
                        'Name Loading..',
                        style: TextStyle(fontSize: 21),
                      ),
                      accountEmail: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Email Loading..',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : UserAccountsDrawerHeader(
                      accountName: Text(
                        userDetails.snapshot.data()['name'],
                        style: TextStyle(fontSize: 21),
                      ),
                      accountEmail: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          userDetails.snapshot.data()['email'],
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
              GestureDetector(
                onTap: () {
                  changeScreen(context, CartPage());
                },
                child: drawerItem(
                  icon: Icons.shopping_cart_outlined,
                  name: "My Cart",
                ),
              ),
              GestureDetector(
                onTap: () {
                  changeScreen(context, MyOrders());
                },
                child: drawerItem(
                  icon: Icons.card_travel,
                  name: "My Orders",
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: drawerItem(
                  icon: Icons.info,
                  name: 'Foody App  (version: 1.0)' +
                      '\n' +
                      'Developers: M. Junaid & M. Awais',
                ),
              ),
              Divider(
                thickness: 2,
                color: black,
              ),
              GestureDetector(
                onTap: () {},
                child: drawerItem(
                  icon: Icons.lock,
                  name: "Change Password",
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _auth.signOut();
                    changeScreenReplacement(context, Welcome());
                  });
                },
                child: drawerItem(
                  icon: Icons.logout,
                  name: "Logout",
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: kcolor2,
        title: Center(child: kappbartext),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Stack(children: [
              IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    changeScreenReplacement(context, CartPage());
                  }),
              Positioned(
                top: 4,
                right: 0,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.black87),
                  child: Center(child: Text('$length')),
                ),
              ),
            ]),
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: true,

      body: Container(
        //color: Colors.white,
        child: Column(children: [
          Container(
            child: Container(
              height: 170,
              width: double.infinity,
              child: Image.asset(
                "images/menu2.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            tileColor: Colors.grey[300],
            title: Center(
              child: Text(
                'MENU',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Featured(listcategory),
          )
        ]),
      ),
    );
  }
}
