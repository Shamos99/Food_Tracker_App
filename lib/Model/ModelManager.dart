import 'dart:convert';
import 'Ingredient.dart';
import 'Meal.dart';

class ModelManager {
  List<Ingredient> _ingredients = [];
  List<Meal> _meals = [];

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
    var iterable = json.decode(json_meal);
    _meals = iterable.map((Map model) => Ingredient.fromJson(model)).toList();
  }

  void addIngedient(Ingredient ingredient) {
    _ingredients.add(ingredient);
  }

  void addMeal(Meal meal) {
    _meals.add(meal);
  }

  List<Ingredient> get ingredients => List.unmodifiable(_ingredients);

  List<Meal> get meals => List.unmodifiable(_meals);

  void deleteIngredient(Ingredient ingredient) {
    _ingredients.remove(ingredient);
  }

  bool isSafeDelete(Ingredient ingredient) {
    _meals.forEach((Meal meal) {
      if (meal.ingredientList.contains(ingredient.name)) {
        return false;
      }
    });
    return true;
  }

  void forceDelete(Ingredient ingredient) {
    _meals.forEach((Meal meal) {
      if (meal.ingredientList.contains(ingredient.name)) {
        meal.deleteIngredient(ingredient);
      }
    });
    deleteIngredient(ingredient);
  }

  String ingredientsJson() {
    String myjson = jsonEncode(ingredients
        .map((Ingredient ingredient) => ingredient.toJson())
        .toList());
    return myjson;
  }
}
