import 'package:food_tracker/UI/custom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_tracker/Model/Meal.dart';

class MySharedPref {
  static Future<SharedPreferences> get_pref({String key}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (key == null) {
      return pref;
    } else {
      if (pref.containsKey(key)) {
        return pref;
      } else {
        return null;
      }
    }
  }

  static List<String> meals_to_string(List<Meal> meals) {
    List<String> toReturn = new List<String>();
    meals.forEach((item) {
      toReturn.add(item.name);
    });

    return toReturn;
  }

  static void meal_edited(String old_name, String new_name) async {
    SharedPreferences pref =
        await MySharedPref.get_pref(key: Constants.key_meals);

    List<String> meals = pref.getStringList(Constants.key_meals);
    for (int i = 0; i < meals.length; i++) {
      if (meals[i] == old_name) {
        meals[i] = new_name;
      }
    }

    await pref.setStringList(Constants.key_meals, meals);
  }
}
