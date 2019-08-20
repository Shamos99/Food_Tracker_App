// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) {
  return Ingredient(
      json['name'] as String,
      (json['calories'] as num)?.toDouble(),
      (json['servingSize'] as num)?.toDouble(),
      (json['protein'] as num)?.toDouble(),
      (json['carbs'] as num)?.toDouble(),
      (json['fats'] as num)?.toDouble());
}

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'protein': instance.protein,
      'servingSize': instance.servingSize,
      'calories': instance.calories,
      'fats': instance.fats,
      'carbs': instance.carbs,
      'name': instance.name
    };
