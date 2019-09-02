import 'package:json_annotation/json_annotation.dart';

import 'Ingredient.dart';

part 'IngredientAmount.g.dart';

@JsonSerializable()
class IngredientAmount {

  Ingredient _ingredient;
  int _amount;
  String _name;

  IngredientAmount(Ingredient ingredient, int amount){
    this._ingredient = ingredient;
    this._amount = amount;
    this._name = this._ingredient.name;
  }

  Ingredient get ingredient => _ingredient;

  int get amount => _amount;

  String get name => this._name;

  factory IngredientAmount.fromJson(Map<String, dynamic> json) => _$IngredientAmountFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientAmountToJson(this);
}
