import 'package:json_annotation/json_annotation.dart';

import 'IngredientAmount.dart';

part 'Meal.g.dart';

@JsonSerializable()
class Meal {

  List<IngredientAmount> _ingredients;
  String _name;


  Meal(String name, List<IngredientAmount> ingredientList){
    this._name = name;
    this._ingredients = ingredientList;
  }

  void addIngredient(IngredientAmount ingredient){
    _ingredients.add(ingredient);

  }

  String get name => this._name;

  List<IngredientAmount> get ingredientList => this._ingredients;

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);

  Map<String, dynamic> toJson() => _$MealToJson(this);

}