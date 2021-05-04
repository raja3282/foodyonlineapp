import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foody_online_app/helper/order_services.dart';
import 'package:foody_online_app/models/cartModel.dart';
import 'package:foody_online_app/models/fooditemModel.dart';
import 'package:foody_online_app/models/user_model.dart';

class MyProvider extends ChangeNotifier {
  OrderServices _orderServices = OrderServices();
  final db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');

  List<Category> categoryList = [];
  List<Category> newCategoryList = [];
  Category category;

  Future<List<Category>> getCategory() async {
    //print('hello rana the great');
    QuerySnapshot query = await db.collection('category').get();

    query.docs.forEach((element) {
      category = Category(
        id: element.reference.id,
        price: element.data()['price'],
        name: element.data()['name'],
        image: element.data()['image'],
        rating: element.data()['rating'],
        description: element.data()['description'],
        comparedPrice: element.data()['comparedPrice'],
      );

      newCategoryList.add(category);
      categoryList = newCategoryList;
    });
    return categoryList;
  }

  get throwcategoryList {
    return categoryList;
  }

  ///////////////Add to cart//////////////////////////////////////////

  List<CartModel> cartList = [];

  String UserId;

  List<CartModel> newCartList = [];
  CartModel cartModel;

  Future<void> addToCart({
    @required String id,
    String name,
    String image,
    int price,
    int comparedPrice,
    @required String Uemail,
  }) {
    UserId = Uemail.toString();
    bool isPresent = false;

    if (cartList.length > 0) {
      for (int i = 0; i < cartList.length; i++) {
        if (cartList[i].id == id) {
          increaseItemQuantity(cartList[i]);
          isPresent = true;
          break;
        } else {
          isPresent = false;
        }
      }

      if (!isPresent) {
        cartModel = CartModel(
            name: name,
            image: image,
            price: price,
            id: id,
            comparedPrice: comparedPrice);
        newCartList.add(cartModel);
        cartList = newCartList;
        cart.doc(getCurrentUser()).set({
          'uid': getCurrentUser(),
        });
        return cart.doc(getCurrentUser()).collection('products').add({
          'productName': name,
          'productID': id,
          'productImage': image,
          'productPrice': price,
          'productComparedprice': comparedPrice,
          'quantity': 1,
        });
      }
    } else {
      cartModel = CartModel(
          name: name,
          image: image,
          price: price,
          id: id,
          comparedPrice: comparedPrice);
      newCartList.add(cartModel);
      cartList = newCartList;

      cart.doc(getCurrentUser()).set({
        'uid': getCurrentUser(),
      });
      return cart.doc(getCurrentUser()).collection('products').add({
        'productName': name,
        'productID': id,
        'productImage': image,
        'productPrice': price,
        'productComparedprice': comparedPrice,
        'quantity': 1,
      });
    }
  }

  get getcartList => cartList;

//////////////if selected item is already in the cart//////////////////
  void increaseItemQuantity(CartModel foodItem) async {
    foodItem.incrementQuantity();
    await db
        .collection('cart')
        .doc(getCurrentUser())
        .collection('products')
        .where('productID', isEqualTo: foodItem.id)
        .get()
        .then((result) {
      for (DocumentSnapshot document in result.docs) {
        document.reference.update({'quantity': foodItem.quantity});
      }
    });
  }

  // void decreaseItemQuantity(CartModel foodItem) {
  //   foodItem.decrementQuantity();
  // }

////////////////////////////////////////////////
  int total() {
    int total = 0;
    cartList.forEach((element) {
      total += element.price * element.quantity;
    });
    return total;
  }

  Future<void> deleteitemfromcart(int index) async {
    await db
        .collection('cart')
        .doc(getCurrentUser())
        .collection('products')
        .where('productID', isEqualTo: cartList[index].id)
        .get()
        .then((result) {
      for (DocumentSnapshot document in result.docs) {
        document.reference.delete();
      }
    });
    cartList.removeAt(index);
    notifyListeners();
  }

  /////////////////(+ and - )quantity buttons///////////////////////////////
  void increaseQuantity(int index) async {
    cartList[index].incrementQuantity();
    notifyListeners();
    await db
        .collection('cart')
        .doc(getCurrentUser())
        .collection('products')
        .where('productID', isEqualTo: cartList[index].id)
        .get()
        .then((result) {
      for (DocumentSnapshot document in result.docs) {
        document.reference.update({'quantity': cartList[index].quantity});
      }
    });
  }

  void decreaseQuantity(int index) async {
    if (cartList[index].quantity > 1) {
      cartList[index].decrementQuantity();
    }
    notifyListeners();
    await db
        .collection('cart')
        .doc(getCurrentUser())
        .collection('products')
        .where('productID', isEqualTo: cartList[index].id)
        .get()
        .then((result) {
      for (DocumentSnapshot document in result.docs) {
        document.reference.update({'quantity': cartList[index].quantity});
      }
    });
  }

  int cartlength() {
    return cartList.length;
  }

  ////////////////////cancel order/////////////////////////////////////////
  void cancelorder() {
    cartList.clear();
    newCartList.clear();
    notifyListeners();
    cart.doc(getCurrentUser()).delete();
  }

///////////////////////storing ids and quantities//////////////////////////////////////
  List<String> cartIDsList = [];
  List<String> newcartIDsList = [];
  List<int> cartQuantityList = [];
  List<int> newcartQuantityList = [];
  List<String> getCartItemsIDs() {
    for (int i = 0; i < cartList.length; i++) {
      newcartIDsList.add(cartList[i].id);
      cartIDsList = newcartIDsList;
    }
    return cartIDsList;
  }

  List<int> getQuantity() {
    for (int i = 0; i < cartList.length; i++) {
      newcartQuantityList.add(cartList[i].quantity);
      cartQuantityList = newcartQuantityList;
    }
    return cartQuantityList;
  }

  //////////////////////////Add to db///////////////////////////////////////////////

  // void addt(int total, loc) {
  //   cartIDsList = getCartItemsIDs();
  //   cartQuantityList = getQuantity();
  //   try {
  //     db.collection('onlineOrder').doc().set({
  //       'orderby': UserId,
  //       'products': cartIDsList,
  //       'quantity': cartQuantityList,
  //       'total': total,
  //       'datetime': datetime,
  //       // 'UID': Authentication().uid,
  //       'UID': getCurrentUser(),
  //       'location': loc,
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   cartIDsList.clear();
  //   cartQuantityList.clear();
  //   cartList.clear();
  //   newCartList.clear();
  //   newcartQuantityList.clear();
  //   newcartIDsList.clear();
  // }
  Future<void> checkData() async {
    final snapshot =
        await cart.doc(getCurrentUser()).collection('products').get();
    if (snapshot.docs.length == 0) {
      cart.doc(getCurrentUser()).delete();
    }
  }

  Future<void> deleteCart() async {
    final result = await cart
        .doc(getCurrentUser())
        .collection('products')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  saveOrder(int total, loc, delFee, discount) async {
    List listCart = [];
    List _newlistCart = [];
    QuerySnapshot snapshot =
        await cart.doc(getCurrentUser()).collection('products').get();
    if (snapshot == null) {
      return null;
    }
    snapshot.docs.forEach((doc) {
      if (!_newlistCart.contains(doc.data())) {
        _newlistCart.add(doc.data());
        listCart = _newlistCart;
        notifyListeners();
      }
    });

    _orderServices.saveOrder({
      'products': listCart,
      'userId': getCurrentUser(),
      'userEmail': UserId,
      //'username': userList.name,
      'userAddress': loc,
      'deliverFee': delFee,
      'total': total,
      'discount': discount,
      'timestamp': DateTime.now().toString(),
      'orderStatus': 'Ordered',
      'cod': 'cash on delivery',
      'deliveryBoy': {
        'name': '',
        'phone': '',
        'location': '',
      },
    }).then((value) {
      deleteCart().then((value) {
        checkData();
      });
    });
    cartList.clear();
    newCartList.clear();
  }

  //////////user id//////////////////////////////////////////
  String getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
    return loggedInUser.uid;
  }

  String getUserMail() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
    return loggedInUser.email;
  }

// ///////////payment db//////////////////////////////
//
//   Future<String> getdocumentid(DateTime datetime, String useremail) async {
//     String doc;
//     await db
//         .collection('myOrder')
//         .where('orderby', isEqualTo: useremail)
//         .where('datetime', isEqualTo: datetime)
//         .get()
//         .then((result) {
//       for (DocumentSnapshot document in result.docs) {
//         doc = document.reference.id;
//       }
//       print('--------------------------------------------------------------');
//       print(doc);
//     });
//     return doc;
//   }
//
//   Future<void> addpayment(
//       int total, String docc, String method, String name, String no) async {
//     // print('${order.name}');
//     //QuerySnapshot query = await db.collection('category').get();
//     try {
//       await db.collection('myOrder').doc(docc).collection('payment').doc().set({
//         'orderby': name,
//         'method': method,
//         'total': total,
//         'pNo': no,
//         //   db.collection('myOrder').doc(id).collection('Payment').doc().set({
//
//         // 'quantity': order.quantity,
//         // 'image': order.image,
//       });
//     } catch (e) {
//       print(e.toString());
//     }
//   }
}
