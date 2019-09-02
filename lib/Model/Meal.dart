import 'package:json_annotation/json_annotation.dart';
import 'Ingredient.dart';

part 'Meal.g.dart';

@JsonSerializable()
class Meal {
  List<String> _ingredients;
  String _name;
  int _cals;
  int _protein;

  Meal(String name, List<String> ingredientList, int cals, int protein) {
    this._name = name;
    this._ingredients = ingredientList;
    this._cals = cals;
    this._protein = protein;
  }

  void addIngredient(Ingredient ingredient) {
    if (_ingredients.contains(ingredient.name)) {
      throw Error();
    }
    _ingredients.add(ingredient.name);
    _cals += ingredient.calories;
    _protein += ingredient.protein;
  }

  void deleteIngredient(Ingredient ingredient) {
    if (_ingredients.contains(ingredient.name)) {
      throw Error();
    }
    _ingredients.remove(ingredient);
    _cals -= ingredient.calories;
    _protein -= ingredient.protein;
  }

  String get name => this._name;

  List<String> get ingredientList => this._ingredients;

  int get protein => _protein;

  int get cals => _cals;

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);

  Map<String, dynamic> toJson() => _$MealToJson(this);
}
