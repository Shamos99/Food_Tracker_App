import 'package:json_annotation/json_annotation.dart';

part 'Ingredient.g.dart';

@JsonSerializable()
class Ingredient {
  String _name;

  int _calories;
  int _protein;
  int _carbs;
  int _fats;

  int _servingSize = 100;

  Ingredient(String name, int calories, int protein, int carbs, int fats) {
    this._name = name;
    this._calories = calories;
    this._protein = protein;
    this._carbs = carbs;
    this._fats = fats;
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  int get protein => _protein;

  int get calories => _calories;

  int get fats => _fats;

  int get carbs => _carbs;

  String get name => _name;

  int get servingSize => _servingSize;
}
