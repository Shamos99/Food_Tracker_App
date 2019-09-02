// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IngredientAmount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientAmount _$IngredientAmountFromJson(Map<String, dynamic> json) {
  return IngredientAmount(
      json['ingredient'] == null
          ? null
          : Ingredient.fromJson(json['ingredient'] as Map<String, dynamic>),
      json['amount'] as int);
}

Map<String, dynamic> _$IngredientAmountToJson(IngredientAmount instance) =>
    <String, dynamic>{
      'ingredient': instance.ingredient,
      'amount': instance.amount
    };
