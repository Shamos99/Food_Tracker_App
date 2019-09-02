import 'package:json_annotation/json_annotation.dart';

part 'Ingredient.g.dart';

@JsonSerializable()
class Ingredient {

  String _name;

  double _calories;
  double _servingSize;

  double _protein;
  double _carbs;
  double _fats;

  Ingredient(String name, double calories, double servingSize, double protein, double carbs, double fats){
    this._name = name;
    this._calories = calories;
    this._servingSize = servingSize;
    this._protein = protein;
    this._carbs = carbs;
    this._fats = fats;

  }


  factory Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  double get protein => _protein;

  double get servingSize => _servingSize;

  double get calories => _calories;

  double get fats => _fats;

  double get carbs => _carbs;

  String get name => _name;


}
