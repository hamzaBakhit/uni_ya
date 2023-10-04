import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../constants/texts.dart';
import '../../features/meals/models/addition.dart';
import '../../features/meals/models/group.dart';
import '../../features/meals/models/meal.dart';

class MealsRemoteService {
  static MealsRemoteService get() => MealsRemoteService();

  CollectionReference meals =FirebaseFirestore.instance
      .collection('restaurants')
      .doc('chile')
      .collection('meals');

  Future<List<Meal>> getMeals() async {
    List<Meal> mealsList = [];
    try {
      final data = await meals.get();
      if (data.docs.isNotEmpty) {
        for (QueryDocumentSnapshot meal in data.docs) {
          List groupss=meal.get('groups') ;

          List additionss=meal.get('additions') ;

          mealsList.add(Meal(
            additions: additionss.map((e) => e.toString()).toList(),
            groups: groupss.map((e) => e.toString()).toList(),
            title: meal.get('title'),
            img: meal.get('img'),
            price: meal.get('price'),
            description: meal.get('description'),
            rateScore: meal.get('rateScore'),
            rateCount: meal.get('rateCount'),
          ));
          mealsList.last.setId(meal.get('id'));


        }
      }
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
    }
    return mealsList;
  }

  final groups = FirebaseFirestore.instance
      .collection('restaurants')
      .doc('chile')
      .collection('groups');

  Future<List<Group>> getGroups() async {
    List<Group> groupsList = [];
    try {
      final data = await groups.get();
      if (data.docs.isNotEmpty) {
        for (QueryDocumentSnapshot group in data.docs) {
          groupsList.add(Group(
            title: group.get('title'),
            img: group.get('img'),
            isOffer: group.get('isOffer'),
          ));
          int color = group.get('color');
          groupsList.last.setColor(color);
          groupsList.last.setId(group.get('id'));
        }
      }
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
    }
    return groupsList;
  }
  CollectionReference additions =FirebaseFirestore.instance
      .collection('restaurants')
      .doc('chile')
      .collection('additions');

  Future<List<Addition>> getAdditions() async {
    List<Addition> additionsList = [];
    try {
      final data = await additions.get();
      if (data.docs.isNotEmpty) {
        for (QueryDocumentSnapshot addition in data.docs) {
          additionsList.add(Addition(
            title: addition.get('title'),
            img: addition.get('img'),
            price: addition.get('price'),
          ));
          additionsList.last.setId(addition.get('id'));
        }
      }
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
    }
    return additionsList;
  }

}
