import 'package:flutter/cupertino.dart';
import 'package:foody_online_app/models/fooditemModel.dart';
import 'package:foody_online_app/providers/my_provider.dart';

class CategoryProvider with ChangeNotifier {
  MyProvider _categoryServices = MyProvider();
  List<Category> categories = [];

  CategoryProvider.initialize() {
    loadCategories();
  }

  loadCategories() async {
    categories = await _categoryServices.getCategory();
    notifyListeners();
  }
}
