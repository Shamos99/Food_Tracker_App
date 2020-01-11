import 'dart:convert';
import 'package:food_tracker/Model/IngredientAmount.dart';
import 'package:food_tracker/Utility/FileHandler.dart';
import 'package:food_tracker/Utility/SharedPref.dart';
import 'Ingredient.dart';
import 'Meal.dart';

import 'package:food_tracker/UI/custom.dart';

class ModelManager {
  List<Ingredient> _ingredients = [];
  List<Meal> _meals = [];
  FileHandler ingredientFileHandler =
      new FileHandler(Constants.file_ingredients_json);
  FileHandler mealFileHandler = new FileHandler(Constants.file_meals_json);

  Future<bool> initModel() async {
    await Future.wait(
            [ingredientFileHandler.readData(), mealFileHandler.readData()])
        .then((value) {
      createIngredients(value[0]);
      createMeals(value[1]);
    });
    return false;
  }

  void createIngredients(String json_ingredients) {
    if (json_ingredients == null) {
      return;
    }
    Iterable iterable = json.decode(json_ingredients);
    _ingredients = iterable.map((model) => Ingredient.fromJson(model)).toList();
  }

  void createMeals(String json_meal) {
    if (json_meal == null) {
      return;
    }
    Iterable iterable = json.decode(json_meal);
    _meals = iterable.map((model) => Meal.fromJson(model)).toList();
  }

  void addIngedient(Ingredient ingredient) {
    if (!does_exist_ingredient(ingredient)) {
      _ingredients.add(ingredient);
    }
  }

  void addMeal(Meal meal) {
    if (!does_meal_name_exist(meal.name)) {
      _meals.add(meal);
    }
  }

  bool does_exist_meal(Meal meal) {
    if (_meals.contains(meal)) {
      return true;
    }
    return false;
  }

  bool does_meal_name_exist(String name) {
    if (_meals.isEmpty) {
      return false;
    }
    return !(_meals.every((meal) => meal.name != name));
  }

  bool does_meal_name_exist_edit(String original_name, String name) {
    if (_meals.isEmpty) {
      return false;
    }

    if (name == original_name) {
      return false;
    }

    return !(_meals.every((meal) => meal.name != name));
  }

  bool does_ingredient_exist_edit(String original_name, String new_name) {
    if (_meals.isEmpty) {
      return false;
    }

    if (new_name == original_name) {
      return false;
    }

    return !(_ingredients.every((ing) => ing.name != new_name));
  }

  bool does_exist_ingredient_name(String name) {
    if (_ingredients.isEmpty) {
      return false;
    }
    return !(_ingredients.every((item) => item.name != name));
  }

  bool does_exist_ingredient(Ingredient ingredient) {
    if (_ingredients.contains(ingredient)) {
      return true;
    }
    return false;
  }

  Meal getMeal(String name) {
    return _meals.firstWhere((item) => item.name == name, orElse: () => null);
  }

  List<Ingredient> get ingredients => List.unmodifiable(_ingredients);

  List<Meal> get meals => List.unmodifiable(_meals);

  void deleteIngredient(Ingredient ingredient) {
    for (Meal meal in _meals) {
      meal.ingredientList
          .removeWhere((item) => item.thisingredient.name == ingredient.name);
    }
    _deleteEmptyMeals();
    _ingredients.removeWhere((item) => item.name == ingredient.name);
  }

  void edit_ingredient(Ingredient oldIngredient, Ingredient newIngredient) {
    for (Meal meal in _meals) {
      meal.editIngredient(oldIngredient, newIngredient);
    }

    _ingredients.removeWhere((item) => item.name == oldIngredient.name);
    _ingredients.add(newIngredient);
  }

  void edit_meal(Meal oldMeal, Meal newMeal) {
    MySharedPref.meal_edited(oldMeal.name, newMeal.name);
    _meals.removeWhere((item) => item.name == oldMeal.name);
    _meals.add(newMeal);
  }

  void _deleteEmptyMeals() {
    List<Meal> deleted = List<Meal>();
    _meals.removeWhere((item) {
      if (item.ingredientList.isEmpty) {
        deleted.add(item);
        return true;
      } else {
        return false;
      }
    });
    MySharedPref.meals_deleted(deleted);
  }

  void deleteMeal(Meal meal) {
    List<Meal> deleted = List<Meal>();
    _meals.removeWhere((item) {
      if (item.name == meal.name) {
        deleted.add(item);
        return true;
      } else {
        return false;
      }
    });
    MySharedPref.meals_deleted(deleted);
  }

  bool isSafeDeleteIngredient(Ingredient ingredient) {
    _meals.forEach((Meal meal) {
      if (meal.ingredientList.contains(ingredient)) {
        return false;
      }
    });
    return true;
  }

  //TODO FIX THE LOGIC
  void forceDeleteIngredient(Ingredient ingredient) {
    _meals.forEach((Meal meal) {
      for (IngredientAmount meal_ingredient in meal.ingredientList) {
        if (meal_ingredient == ingredient) {
          meal.ingredientList.remove(meal_ingredient);
        }
      }
    });
    deleteIngredient(ingredient);
  }

  String ingredientsJson() {
    _ingredients
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    String myjson = jsonEncode(ingredients
        .map((Ingredient ingredient) => ingredient.toJson())
        .toList());
    return myjson;
  }

  String mealsJson() {
    _meals.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    String myjson =
        jsonEncode(meals.map((Meal meal) => meal.toJson()).toList());

    return myjson;
  }

  Future<bool> saveModel() async {
    await Future.wait([
      ingredientFileHandler.writeData(ingredientsJson()),
      mealFileHandler.writeData(mealsJson())
    ]);

    return true;
  }
}
