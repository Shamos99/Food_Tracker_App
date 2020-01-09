import 'package:json_annotation/json_annotation.dart';

import 'Ingredient.dart';
import 'package:json_annotation/json_annotation.dart';

part 'IngredientAmount.g.dart';

@JsonSerializable()
class IngredientAmount {
  Ingredient thisingredient;
  double amount;

  IngredientAmount(this.thisingredient, this.amount);

  factory IngredientAmount.fromJson(Map<String, dynamic> json) => _$IngredientAmountFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientAmountToJson(this);

  double getCalories(){
    return thisingredient.calories*amount;
  }
}
