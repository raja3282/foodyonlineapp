import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foody_online_app/helper/screen_navigation.dart';
import 'package:foody_online_app/models/fooditemModel.dart';
import 'package:foody_online_app/screens/details.dart';

class Featured extends StatelessWidget {
  List<Category> productsList;
  Featured(this.productsList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: productsList?.length ?? 0,
      shrinkWrap: true,
      itemBuilder: (_, index) {
        return Container(
          height: 113,
          width: MediaQuery.of(context).size.width,
          child: Card(
            child: Center(
              child: ListTile(
                leading: Container(
                  height: 90,
                  width: 90,
                  child: Image.network(
                    productsList[index].image,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  productsList[index].name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
                subtitle: Text(
                  'Rs.${productsList[index].price.toString()}',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  changeScreen(
                      context,
                      DetailPage(
                        name: productsList[index].name,
                        image: productsList[index].image,
                        price: productsList[index].price,
                        productid: productsList[index].id,
                        rating: productsList[index].rating,
                        description: productsList[index].description,
                        comparedPrice: productsList[index].comparedPrice,
                      ));
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
