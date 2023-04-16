import 'package:edirnebenim/utilities/typedef.dart';
import 'package:flutter/material.dart';

class TradeCategories extends ValueNotifier<TradeCategoriesType> {
  factory TradeCategories() => _shared;
  TradeCategories._sharedInstance() : super({});
  static final TradeCategories _shared = TradeCategories._sharedInstance();

  int get length => value.length;

  void add({required TradeCategoriesType newCategory}) {
    final categories = value;
    categories.addAll(newCategory);
    notifyListeners();
  }

  void remove({required String categoryKey}) {
    final categories = value;
    if (categories.containsKey(categoryKey)) {
      categories.removeWhere(
        (key, value) => key == categoryKey,
      );
      notifyListeners();
    }
  }

  List<String?> get getCategoryIconPath {
    final categories = value;
    final categoriesIconPaths = <String?>[];
    for (final category in categories.keys) {
      if (category == 'Telefon') {
        categoriesIconPaths.add('assets/categories/smartphone.png');
      } else if (category == 'Ev Eşyaları') {
        categoriesIconPaths.add('assets/categories/electric-appliance.png');
      } else if (category == 'Giyim ve Aksesuar') {
        categoriesIconPaths.add('assets/categories/search.png');
      } else if (category == 'Elektronik') {
        categoriesIconPaths.add('assets/categories/gadgets.png');
      } else if (category == 'Bebek ve Çocuk') {
        categoriesIconPaths.add('assets/categories/stroller.png');
      } else if (category == 'Hobi ve Eğlence') {
        categoriesIconPaths.add('assets/categories/hobby.png');
      } else if (category == 'Spor ve Outdoor') {
        categoriesIconPaths.add('assets/categories/sports.png');
      } else {
        categoriesIconPaths.add(null);
      }
    }
    return categoriesIconPaths;
  }

  List<String> get getTitles {
    final categories = value;
    return categories.keys.toList();
  }

  List<List<String>> get getSubCategories {
    final categories = value;
    return categories.values.toList();
  }
}
