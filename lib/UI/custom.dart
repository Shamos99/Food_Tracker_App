import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:food_tracker/Model/Ingredient.dart';
import 'package:food_tracker/Model/IngredientAmount.dart';
import 'package:food_tracker/UI/ingredient_add.dart';
import 'package:food_tracker/Model/Meal.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AppRoutes {
  static const main_page = '/';
  static const main_ingredient = '/main_ingredient';
  static const add_ingredient = '/add_ingredient';
  static const main_meal = '/main_meal';
  static const add_meal = '/add_meal';
  static const search_ingredient = '/search_ingredient';
}

enum Macros { p, c, f, kcal }

class Options {
  static const String foodlib = "Food Library";
  static const String ingredientlib = "Ingredient Library";
  static const String refresh = "Refresh Goals";
  static const String calorieGoal = "Change Calorie Goal";
  static const String createIngredient = "Create Ingredient";
  static const String createMeal = "Create Meal";
  static const String searchIngredeint = "Search Ingredient";

  static const List<String> options = <String>[
    foodlib,
    ingredientlib,
    refresh,
    calorieGoal
  ];
}

class Constants {
  //file/storage handling
  static const String file_meals_json = "test1.txt";
  static const String file_ingredients_json = "test.txt";
  static const String key_calorie_goal = "calories";
  static const String key_meals = "meals";

  //string constants
  static const String appTitle = "EZ Calories";
  static const String delete = "Delete?";
  static const String yes = "Yes";
  static const String no = "No";
  static const String calorie_goal_promopt = "Enter your new calorie goal";
  static const String refresh_meals = "Delete meals and start again?";
  static const String cancel = "Cancel";
  static const String okay = "Okay";
  static const String type = "Type...";
  static const double defaultCalorieGoal = 2000;
  static const String ingredientPageTitle = "Ingredient Library";
  static const String add_ingredient = "Create Ingerdient";
  static const String per_100_gm_or_ml = "per 100gm or 100ml";
  static const String emptyError = "Enter something maybe???";
  static const String number_error_prompt = "idiot baka...";
  static const String ingredientName = "Ingredient Name";
  static const String calories = "Calories";
  static const String protein = "Protein";
  static const String carbs = "Carbs";
  static const String fats = "Fats";
  static const String todays_meals = "Todays Meals";
  static const String noIngredients = "No ingredients yet to show :(";
  static const String noMeals = "No meals bitch";
  static const String protein_cals_explanation =
      "Protein and Calories are Mandatory";
  static const String total_cals_not_adding =
      "All macros do not add up to the given calories...dumbass";
  static const String cals_prompt_not_all_macros =
      "The given macros should be less than the fucking calories dumbfuck";
  static const String menu = "Menu";
  static const String meallib = "Meal Library";
  static const String createMeal = "Create Meal";
  static const String editMeal = "Edit Meal";
  static const String editIngredient = "Edit Ingredient";
  static const String sameNamePromtIngredient =
      "An ingredient with the same name exists. I need to index ingredients uniqely, I am not a god pls";
  static const String sameNamePromptMeal =
      "A meal with the same name exists. I need to index ingredients uniqely, I am not a god pls";
  static const String mealName = "Meal Name";
  static const String saveMeal = "Save Meal";
  static const String search_ingredients = "Search Ingredients";
  static const String nothingfound = "Nothing Found :(";
  static const String saveingredient = "Save Ingredient";
  static const String enteramount = "amount...";
  static const String angry = "fuck u";
  static const String angry2 = "You gonna eat air? Dumbfuck";
  static const String alreadyexists = "already exists";
  static const String success = "success";

  //integers for calorie logic
  static const int protein_cals_per_gram = 4;
  static const int carbs_cals_per_gram = 4;
  static const int fats_cals_per_gram = 9;
  static const int snackbar_duration = 2;
}

//Custom Widgets

class MyColumn extends Column {
  MyColumn(List<Widget> _children)
      : super(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: _children);
}

class MyButton extends RaisedButton {
  MyButton()
      : super(
            onPressed: () {},
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF0D47A1),
                    Color(0xFF1976D2),
                    Color(0xFF42A5F5),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(10.0),
              child:
                  const Text('Gradient Button', style: TextStyle(fontSize: 20)),
            ));
}

TextInputType platformspecificKeyboard() {
  return (Platform.isIOS) ? TextInputType.text : TextInputType.number;
}

String getIngredientMacros(Ingredient ingredient, {double amount = 1}) {
  String toReturn = (ingredient.calories * amount).round().toString() + "kcal";
  toReturn += " " + (ingredient.protein * amount).round().toString() + "p";
  if (ingredient.carbs != null) {
    toReturn += " " + (ingredient.carbs * amount).round().toString() + "c";
  }
  if (ingredient.fats != null) {
    toReturn += " " + (ingredient.fats * amount).round().toString() + "f";
  }
  return toReturn;
}

String getMealMacros(List<IngredientAmount> ingredientlist) {
  double cals = 0, protein = 0, carbs = 0, fat = 0;
  ingredientlist.forEach((ingredient) {
    cals += ingredient.thisingredient.calories * ingredient.amount;
    protein += ingredient.thisingredient.protein * ingredient.amount;
    if (ingredient.thisingredient.carbs != null) {
      carbs += ingredient.thisingredient.carbs * ingredient.amount;
    }
    if (ingredient.thisingredient.fats != null) {
      fat += ingredient.thisingredient.fats * ingredient.amount;
    }
  });

  return cals.round().toString() +
      "kcal " +
      protein.round().toString() +
      "p " +
      carbs.round().toString() +
      "c " +
      fat.round().toString() +
      "f";
}

Map<Macros, int> get_macros_map(List<Meal> meals) {
  double cals = 0, protein = 0, carbs = 0, fat = 0;
  meals.forEach((meal) {
    meal.ingredientList.forEach((ingredient) {
      cals += ingredient.thisingredient.calories * ingredient.amount;
      protein += ingredient.thisingredient.protein * ingredient.amount;
      if (ingredient.thisingredient.carbs != null) {
        carbs += ingredient.thisingredient.carbs * ingredient.amount;
      }
      if (ingredient.thisingredient.fats != null) {
        fat += ingredient.thisingredient.fats * ingredient.amount;
      }
    });
  });

  return {
    Macros.kcal: cals.toInt(),
    Macros.c: carbs.toInt(),
    Macros.f: fat.toInt(),
    Macros.p: protein.toInt()
  };
}

String getAllMealMacros(List<Meal> meals, {bool integer = false}) {
  double cals = 0, protein = 0, carbs = 0, fat = 0;
  meals.forEach((meal) {
    meal.ingredientList.forEach((ingredient) {
      cals += ingredient.thisingredient.calories * ingredient.amount;
      protein += ingredient.thisingredient.protein * ingredient.amount;
      if (ingredient.thisingredient.carbs != null) {
        carbs += ingredient.thisingredient.carbs * ingredient.amount;
      }
      if (ingredient.thisingredient.fats != null) {
        fat += ingredient.thisingredient.fats * ingredient.amount;
      }
    });
  });
  return cals.round().toString() +
      "kcal " +
      protein.round().toString() +
      "p " +
      carbs.round().toString() +
      "c " +
      fat.round().toString() +
      "f";
}

class MyAppBar extends AppBar {
  MyAppBar(_title)
      : super(
          title: _title,
        );
}

class TextAlign extends Align {
  TextAlign(String text, double size, Alignment alignment)
      : super(
            child: Text(
              "Todays Meals",
              textScaleFactor: size,
            ),
            alignment: alignment);
}

@deprecated
class _MyAppBar extends AppBar {
  var context;

  _MyAppBar(String title, {this.context})
      : super(title: Text(title), actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return Options.options.map((String option) {
                return PopupMenuItem<String>(
                    value: option, child: Text(option));
              }).toList();
            },
            onSelected: choice,
          )
        ]);

  static choice(String choice) {
    if (choice == Options.foodlib) {
    } else if (choice == Options.ingredientlib) {
    } else if (choice == Options.refresh) {}
  }
}

SnackBar myGenericSnackbar(String prompt, {int duration = 2}) {
  return SnackBar(
    content: Text(
      prompt,
      textScaleFactor: 1.5,
    ),
    duration: Duration(seconds: duration),
  );
}

//Creates the list view when we search for an ingredient
Widget myIngredientListView_add_to_meal(
        BuildContext context, List<Ingredient> ingredients, poptwice) =>
    ListView.builder(
      itemBuilder: (context, index) => ListTile(
        title: Text(ingredients[index].name),
        subtitle: Text(getIngredientMacros(ingredients[index])),
        onTap: () {
          if (poptwice) {
            Navigator.pop(context);
            Navigator.pop(context, ingredients[index]);
          } else {
            Navigator.pop(context, ingredients[index]);
          }
        },
      ),
      itemCount: ingredients.length,
    );

//return ingredients based on search param
List<Ingredient> searchResults_ingredients(
        String query, List<Ingredient> toSearch) =>
    query.isEmpty
        ? toSearch
        : toSearch
            .where(
                (item) => item.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

//return meal based on search param
List<Meal> searchResults_meals(String query, List<Meal> toSearch) => query
        .isEmpty
    ? toSearch
    : toSearch
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

void show_simple_dialogue(BuildContext context, String prompt) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(title: Text(prompt), actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.pop(context, Constants.success);
              },
              child:
                  Text(Constants.okay, style: TextStyle(color: Colors.blue))),
        ]);
      });
}

@deprecated
class _ProgressBar extends CircularPercentIndicator {
  _ProgressBar(List<Meal> meals, int calorie_display)
      : super(
            percent: _get_percent(meals, calorie_display),
            animation: true,
            animationDuration: 1500,
            radius: 200.0,
            lineWidth: 10.0,
            header: Text("Your Progress", textScaleFactor: 2.0),
            footer: Text("Goal: $calorie_display", textScaleFactor: 1.25),
            center: Text(
              "80%",
              textScaleFactor: 2.0,
            ));

  static double _get_percent(List<Meal> meals, int calorie_goal) {
    double cals = 0;
    meals.forEach((meal) {
      cals += meal.getCalories();
    });
    print(cals / calorie_goal);
    return 0.4;
  }
}

void show_yes_no_dialogue(BuildContext context, String mytitle,
    {@required Function yes_call_back, @required Function no_callback}) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(mytitle),
            actions: <Widget>[
              new FlatButton(
                  onPressed: yes_call_back, child: Text(Constants.yes)),
              new FlatButton(
                  onPressed: no_callback,
                  child: Text(
                    Constants.no,
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          ));
}
