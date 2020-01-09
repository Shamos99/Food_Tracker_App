import 'package:json_annotation/json_annotation.dart';

part 'Ingredient.g.dart';

@JsonSerializable()
class Ingredient {
  String _name;

  double _calories;
  double _protein;
  double _carbs;
  double _fats;

  int _servingSize = 100;

  Ingredient(String name, double calories, double protein, double carbs, double fats) {
    this._name = name;
    this._calories = calories;
    this._protein = protein;
    this._carbs = carbs;
    this._fats = fats;
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  double get protein => _protein;

  double get calories => _calories;

  double get fats => _fats;

  double get carbs => _carbs;

  String get name => _name;

  int get servingSize => _servingSize;
}
