import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:food_tracker/Model/Ingredient.dart';
import 'package:food_tracker/Model/IngredientAmount.dart';
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
  static const String meallib = "Meal Library";
  static const String ingredientlib = "Ingredient Library";
  static const String refresh = "Refresh Goals";
  static const String calorieGoal = "Change Calorie Goal";
  static const String createIngredient = "Create Ingredient";
  static const String createMeal = "Create Meal";
  static const String searchIngredeint = "Search Ingredient";
  static const String add_cals_manually = "Add \"extra\" calories";

  static const List<String> options = <String>[
    meallib,
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
  static const String only_calories = "No Macros??";
  static const String cancel = "Cancel";
  static const String okay = "Okay";
  static const String type = "Type...";
  static const double defaultCalorieGoal = 2000;
  static const String ingredientPageTitle = "Ingredient Library";
  static const String add_ingredient = "Create Ingerdient";
  static const String per_serving_size = "per serving size";
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
  static const String protein_too_high = "Protein is too high...";
  static const String total_cals_not_adding =
      "All macros do not add up to the given calories...dumbass";
  static const String protein_mandatory = "Protein is mandatory..";
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
  static const String enter_extra_cals = "Enter \"extra\" macros";
  static const String already_added_invis_cals =
      "You already added invisible calories asshole. If you wanna change it then delete it and add again";
  static const String angry = "fuck u";
  static const String angry2 = "You gonna eat air? Dumbfuck";
  static const String alreadyexists = "already exists";
  static const String success = "success";
  static const String zero_cals = "zero calories?";
  static const String done = "Done";
  static String invis_cal_name = String.fromCharCode(1) + "\"Extra\" Macros";

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

  if (ingredient.protein != null) {
    toReturn += " " + (ingredient.protein * amount).round().toString() + "p";
  }
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
    if (ingredient.thisingredient.protein != null) {
      protein += ingredient.thisingredient.protein * ingredient.amount;
    }
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
      if (ingredient.thisingredient.protein != null) {
        protein += ingredient.thisingredient.protein * ingredient.amount;
      }
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
      if (ingredient.thisingredient.protein != null) {
        protein += ingredient.thisingredient.protein * ingredient.amount;
      }
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
    if (choice == Options.meallib) {
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

class HandleItemCreation {
  double cals, fats, protein, carbs;
  double _total = 0;
  String prompt;
  List<Macros> _nulls = List<Macros>();
  List<Macros> _non_nulls = List<Macros>();

  HandleItemCreation(
      {@required this.cals,
      @required this.fats,
      @required this.protein,
      @required this.carbs}) {
    if (fats != null) {
      _total += fats * Constants.fats_cals_per_gram;
      _non_nulls.add(Macros.f);
    } else {
      _nulls.add(Macros.f);
    }
    if (protein != null) {
      _total += protein * Constants.protein_cals_per_gram;
      _non_nulls.add(Macros.p);
    } else {
      _nulls.add(Macros.p);
    }
    if (carbs != null) {
      _total += carbs * Constants.carbs_cals_per_gram;
      _non_nulls.add(Macros.c);
    } else {
      _nulls.add(Macros.c);
    }
  }

  void __setzero(Macros macro) {
    if (macro == Macros.p) {
      protein = 0;
    } else if (macro == Macros.f) {
      fats = 0;
    } else if (macro == Macros.c) {
      carbs = 0;
    }
  }

  void _set_nulls_to_zero() {
    for (Macros macro in _nulls) {
      __setzero(macro);
    }
  }

  bool _set_remaining_macro() {
    double remaining = cals - _total;
    if (remaining < 0) {
      prompt = Constants.cals_prompt_not_all_macros;
      return false;
    }

    if (_nulls[0] == Macros.f) {
      fats = double.parse(
          (remaining / Constants.fats_cals_per_gram).toStringAsFixed(2));
    } else if (_nulls[0] == Macros.p) {
      protein = double.parse(
          (remaining / Constants.protein_cals_per_gram).toStringAsFixed(2));
    } else if (_nulls[0] == Macros.c) {
      carbs = double.parse(
          (remaining / Constants.carbs_cals_per_gram).toStringAsFixed(2));
    }

    return true;
  }

  bool _cals_is_null() {
    if (_nulls.length == 0) {
      cals = _total;
      return true;
    } else if (_nulls.length == 1 || _nulls.length == 2) {
      _set_nulls_to_zero();
      cals = _total;
      return true;
    } else if (_nulls.length == 3) {
      prompt = Constants.angry;
      return false;
    }
  }

  bool _cals_is_non_null() {
    if (_nulls.length == 0) {
      if (_total < cals - 10 || _total > cals + 10) {
        prompt = Constants.cals_prompt_not_all_macros;
        return false;
      } else {
        return true;
      }
    } else if (_nulls.length == 1) {
      return _set_remaining_macro();
    } else if (_nulls.length == 2) {
      if (_total > cals) {
        prompt = Constants.cals_prompt_not_all_macros;
        return false;
      } else if (_total == cals) {
        _set_nulls_to_zero();
        return true;
      }
      return true;
    } else if (_nulls.length == 3) {
      return true;
    }
  }

  bool do_my_shit() {
    if (cals == null) {
      return _cals_is_null();
    } else {
      return _cals_is_non_null();
    }
  }
}

//see if a num is greater than zero or parsable
bool isValidNum(value) {
  double myval = double.tryParse(value);
  if (myval == null) {
    return false;
  } else if (myval < 0) {
    return false;
  } else {
    return true;
  }
}

class MySetCalAlert extends StatefulWidget {
  Function successfullCallback;

  MySetCalAlert({@required this.successfullCallback});

  @override
  State<StatefulWidget> createState() {
    return MySetCalAlertState();
  }
}

class MySetCalAlertState extends State<MySetCalAlert> {
  double _dialogueval;
  final _formkey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Constants.calorie_goal_promopt),
      content: Form(
        autovalidate: true,
        key: _formkey,
        child: new TextFormField(
          decoration: new InputDecoration(
              hintText: Constants.type, border: OutlineInputBorder()),
          keyboardType: platformspecificKeyboard(),
          validator: (String value) {
            if (isValidNum(value)) {
              this._dialogueval = double.parse(value);
              return null;
            } else {
              return "fack you";
            }
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(Constants.cancel, style: TextStyle(color: Colors.red))),
        FlatButton(
          onPressed: () {
            final form = this._formkey.currentState;
            if (form.validate()) {
              Navigator.pop(context);
              widget.successfullCallback(this._dialogueval);
            }
          },
          child: Text(Constants.okay),
        )
      ],
    );
  }
}
