import 'package:flutter/material.dart';

class Options {
  static const String foodlib = "Food Library";
  static const String ingredientlib = "Ingredient Library";
  static const String refresh = "Refresh Goals";
  static const String calorieGoal = "Change Calorie Goal";

  static const List<String> options = <String>[
    foodlib,
    ingredientlib,
    refresh,
    calorieGoal
  ];
}

class Constants {
  //file/storage handling
  static const String meals_json = "test.txt";
  static const String ingredients_json = "test.txt";
  static const String calorie_goal_key = "calories";

  //string constants
  static const String appTitle = "EZ Calories";
  static const String delete = "Delete?";
  static const String yes = "Yes";
  static const String no = "No";
  static const String calorie_goal_promopt = "Enter your calorie goal";
  static const String cancel = "Cancel";
  static const String okay = "Okay";
  static const String type = "Type...";
  static const int defaultCalorieGoal = 2000;
  static const String ingredientPageTitle = "Ingredient Library";
  static const String add_ingredient = "Add Ingerdient";
  static const String per_100_gm_or_ml = "per 100gm or 100ml";
  static const String emptyError = "Enter something maybe???";
  static const String number_error_prompt = "idiot baka...";
  static const String ingredientName = "Ingredient Name";
  static const String calories = "Calories";
  static const String protein = "Protein";
  static const String carbs = "Carbs";
  static const String fats = "Fats";
  static const String noIngredients = "No ingredients yet to show :(";
  static const String protein_cals_explanation =
      "Protein and Calories are Mandatory";
  static const String total_cals_not_adding =
      "All macros do not add up to the given calories...dumbass";
  static const String cals_prompt_not_all_macros =
      "The given macros should be less than the fucking calories dumbfuck";

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
