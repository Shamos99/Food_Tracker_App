// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) {
  return Meal(
      json['name'] as String,
      (json['ingredientList'] as List)
          ?.map((e) => e == null
              ? null
              : IngredientAmount.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
      'name': instance.name,
      'ingredientList': instance.ingredientList
    };
