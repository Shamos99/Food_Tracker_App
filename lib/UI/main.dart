// Copyright 2017, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:food_tracker/Model/ModelManager.dart';
import 'package:food_tracker/UI/meal_add.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_tracker/Utility/SharedPref.dart';
import 'custom.dart';
import 'ingredient_main.dart';
import 'meal_main.dart';
import 'ingredient_add.dart';
import 'meal_add.dart';
import 'package:food_tracker/Model/Meal.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Constants.appTitle,
            initialRoute: AppRoutes.main_page,
            routes: {
              AppRoutes.main_page: (context) => _MainPage(),
              AppRoutes.main_ingredient: (context) => IngredientMain(),
              AppRoutes.add_ingredient: (context) => IngredientAdd(),
              AppRoutes.main_meal: (context) => Meal_Main(),
              AppRoutes.add_meal: (context) => MealAdd(),
            },
          )));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: Constants.appTitle,
      home: _MainPage(),
    );
  }
}

class _MainPage extends StatefulWidget {
  ModelManager manager = new ModelManager();

  @override
  State<StatefulWidget> createState() {
    return new _MainPageState();
  }
}

class _MainPageState extends State<_MainPage> {
  List<Meal> todays_meals = List<Meal>();
  double calorie_goal = Constants.defaultCalorieGoal;
  double _dialogueVal;

  void _loadCalories() async {
    SharedPreferences pref =
        await MySharedPref.get_pref(key: Constants.key_calorie_goal);
    if (pref != null) {
      setState(() {
        calorie_goal = pref.getDouble(Constants.key_calorie_goal);
      });
    }
  }

  void _setcalories(double calories) async {
    SharedPreferences pref = await MySharedPref.get_pref();
    pref.setDouble(Constants.key_calorie_goal, calories.roundToDouble());
    _loadCalories();
  }

  void _init_todays_meals() async {
    SharedPreferences pref =
        await MySharedPref.get_pref(key: Constants.key_meals);

    List<Meal> tmp_meals = List<Meal>();
    if (pref != null) {
      List<String> stored_meals = pref.getStringList(Constants.key_meals);
      stored_meals.forEach((item) {
        Meal cur_meal = widget.manager.getMeal(item);
        if (cur_meal != null) {
          tmp_meals.add(cur_meal);
        }
      });
      setState(() {
        todays_meals = new List<Meal>.from(tmp_meals);
      });
    }
  }

  void _insert_meal_into_pref(Meal meal_to_add) async {
    SharedPreferences pref = await MySharedPref.get_pref();
    setState(() {
      this.todays_meals.add(meal_to_add);
    });
    List<String> string_meals = MySharedPref.meals_to_string(this.todays_meals);
    pref.setStringList(Constants.key_meals, string_meals);
  }

  @override
  void initState() {
    _loadCalories();
    widget.manager.initModel().then((value) {
      this._init_todays_meals();
    });
  }

  void _addmeal() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new Meal_Main(
                  to_select: true,
                ))).then((value) {
      widget.manager.initModel().then((a_value) {
        Meal new_meal = widget.manager.getMeal(value);
        if (new_meal != null) {
          this._insert_meal_into_pref(new_meal);
        }
      });
    });
  }

  //APP BAR, SCAFFOLD AND POPUP MENU
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text(Constants.appTitle), actions: <Widget>[
        PopupMenuButton<String>(
          itemBuilder: (BuildContext context) {
            return [Options.refresh, Options.calorieGoal].map((String option) {
              return PopupMenuItem<String>(value: option, child: Text(option));
            }).toList();
          },
          onSelected: _choice,
        )
      ]),
      body: SingleChildScrollView(
        child: _buildPage(),
        padding: EdgeInsets.all(10.0),
      ),
      //SIDE DRAWER
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Text(
                      Constants.menu,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textScaleFactor: 1.5,
                    ),
                    decoration: BoxDecoration(color: Colors.lightBlueAccent),
                  ),
                  ListTile(
                    title: Text(Options.meallib),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.main_meal)
                          .then((value) {
                        widget.manager
                            .initModel()
                            .then((value) => this._init_todays_meals());
                      });
                    },
                  ),
                  ListTile(
                    title: Text(Options.ingredientlib),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.main_ingredient)
                          .then((value) {
                        widget.manager
                            .initModel()
                            .then((value) => this._init_todays_meals());
                      });
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(50.0),
              child: ListTile(),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _gen_food_list() {
    return todays_meals
        .asMap()
        .map((int index, Meal meal) => MapEntry(
            index,
            Card(
              child: ExpansionTile(
                children: todays_meals[index].ingredientList.map((item) {
                  return ListTile(
                    leading: Icon(Icons.change_history),
                    title: Text(
                      item.thisingredient.name,
                      textScaleFactor: 0.9,
                    ),
                    subtitle: Text(
                      "Servings " +
                          item.amount.toStringAsFixed(1) +
                          "\n" +
                          getIngredientMacros(item.thisingredient,
                              amount: item.amount),
                      maxLines: 2,
                    ),
                  );
                }).toList(),
                title: ListTile(
                  leading: Text(
                    (index + 1).toString(),
                    textScaleFactor: 1.5,
                  ),
                  title: Text(todays_meals[index].name),
                  subtitle:
                      Text(getMealMacros(todays_meals[index].ingredientList)),
                  onTap: () {},
                  onLongPress: () {
                    show_yes_no_dialogue(context, Constants.delete,
                        yes_call_back: () {
                      MySharedPref.get_pref(key: Constants.key_meals)
                          .then((value) {
                        setState(() {
                          todays_meals.removeAt(index);
                          value.setStringList(Constants.key_meals,
                              MySharedPref.meals_to_string(todays_meals));
                        });
                      });
                      Navigator.pop(context);
                    }, no_callback: () {
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
              elevation: 0,
              color: Colors.lightBlue.withOpacity(0.05),
            )))
        .values
        .toList();
  }

  //Main Page
  Widget _buildPage() {
    Map<Macros, int> mymap = get_macros_map(todays_meals);
    return MyColumn([
      new Padding(padding: EdgeInsets.all(5.0)),
      Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border(right: BorderSide(color: Colors.black87))),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Text(mymap[Macros.p].toString() + "p"),
                            Text(mymap[Macros.c].toString() + "c"),
                            Text(mymap[Macros.f].toString() + "f")
                          ],
                        ),
                      ),
                    ),
                    top: 80,
                  ),
                  Center(
                    child: _MyProgressBar.get_circular_indicator(
                        todays_meals, calorie_goal.round()),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      new Padding(padding: EdgeInsets.all(10.0)),
      new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(Constants.todays_meals, textScaleFactor: 1.5),
          new RaisedButton(
            onPressed: () {
              _addmeal();
            },
            child: new Icon(Icons.add),
          )
        ],
      ),
      new Padding(padding: EdgeInsets.all(5.0)),
      this.todays_meals.isEmpty
          ? Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(100.0),
                  child: Text(
                    Constants.noMeals,
                    textScaleFactor: 1.1,
                    style: TextStyle(
                      color: Colors.blueGrey.withOpacity(0.8),
                    ),
                  ),
                )
              ],
            )
          : Column(children: _gen_food_list())
    ]);
  }

  //APPBAR
  @deprecated
  Widget _appBar(String title) {
    return new AppBar(
        title: Text(title),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return Options.options.map((String option) {
                return PopupMenuItem<String>(
                    value: option, child: Text(option));
              }).toList();
            },
            onSelected: _choice,
          )
        ]);
  }

  void _refresh() {
    show_yes_no_dialogue(context, Constants.refresh_meals, yes_call_back: () {
      MySharedPref.get_pref().then((value) {
        setState(() {
          todays_meals = [];
          value.setStringList(Constants.key_meals, List<String>());
        });
      });
      Navigator.pop(context);
    }, no_callback: () {
      Navigator.pop(context);
    });
  }

  void _choice(String choice) {
    if (choice == Options.meallib) {
    } else if (choice == Options.ingredientlib) {
      Navigator.pushNamed(context, AppRoutes.main_ingredient).then((value) {
        this._init_todays_meals();
      });
    } else if (choice == Options.refresh) {
      _refresh();
    } else if (choice == Options.calorieGoal) {
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              MySetCalAlert(successfullCallback: this._setcalories));
    }
  }

  @deprecated
  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(Constants.calorie_goal_promopt),
            content: new TextField(
                decoration: new InputDecoration(
                    hintText: Constants.type, border: OutlineInputBorder()),
                keyboardType: platformspecificKeyboard(),
                onChanged: (String val) {
                  this._dialogueVal = double.parse(val);
                },
                onSubmitted: (String val) {
                  this._dialogueVal = double.parse(val);
                }),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(Constants.cancel,
                      style: TextStyle(color: Colors.red))),
              FlatButton(
                onPressed: () {
                  if (this._dialogueVal < 0) {}
                  this._setcalories(this._dialogueVal);
                  Navigator.pop(context);
                },
                child: Text(Constants.okay),
              )
            ],
          );
        });
  }
}

class _MyProgressBar {
  static Widget get_circular_indicator(List<Meal> meals, int calorie_goal) {
    double cals = _get_total_cals(meals, calorie_goal);
    Color color = Colors.green;
    double percent = cals / calorie_goal.roundToDouble();
    double round_down = percent;
    if (percent > 1) {
      round_down = 1;
      color = Colors.red;
    }
    int calories = cals.toInt();
    return CircularPercentIndicator(
      percent: round_down,
      animation: true,
      animationDuration: 1500,
      radius: 200.0,
      lineWidth: 10.0,
      header: Text("Your Progress", textScaleFactor: 2.0),
      footer: Text("Goal: $calories/$calorie_goal", textScaleFactor: 1.25),
      center: Text(
        (percent * 100).round().toString() + "%",
        textScaleFactor: 2.0,
      ),
      progressColor: color,
    );
  }

  static double _get_total_cals(List<Meal> meals, int calorie_goal) {
    double cals = 0;
    meals.forEach((meal) {
      cals += meal.getCalories();
    });
    return cals;
  }

  static double _get_percent(List<Meal> meals, int calorie_goal) {
    return _get_total_cals(meals, calorie_goal) / calorie_goal;
  }
}
