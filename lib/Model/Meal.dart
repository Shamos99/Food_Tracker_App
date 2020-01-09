import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:food_tracker/Model/Ingredient.dart';
import 'package:json_annotation/json_annotation.dart';
import 'IngredientAmount.dart';

part 'Meal.g.dart';

@JsonSerializable()
class Meal {
  List<IngredientAmount> _ingredients;
  String _name;

  Meal(
    String name,
    List<IngredientAmount> ingredientList,
  ) {
    this._name = name;
    this._ingredients = ingredientList;
  }

  void addIngredient(IngredientAmount ingredient) {
    if (_ingredients.contains(ingredient)) {
      throw Error();
    }
    _ingredients.add(ingredient);
  }

  void deleteIngredient(IngredientAmount ingredient) {
    _ingredients.remove(ingredient);
  }

  void editIngredient(Ingredient old_ing, Ingredient new_ing) {
    for (int i = 0; i < _ingredients.length; i++) {
      if (_ingredients[i].thisingredient.name == old_ing.name) {
        _ingredients[i].thisingredient = new_ing;
        return;
      }
    }
  }

  double getCalories() {
    double cals = 0;
    ingredientList.forEach((val) {
      cals += val.getCalories();
    });
    return cals;
  }

  String get name => this._name;

  List<IngredientAmount> get ingredientList => this._ingredients;

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);

  Map<String, dynamic> toJson() => _$MealToJson(this);
}
