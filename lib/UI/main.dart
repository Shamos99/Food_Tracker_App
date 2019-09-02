// Copyright 2017, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:food_tracker/Utility/FileHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom.dart';
import 'page_2.dart';
import 'ingredient_main.dart';

void main() => runApp(MyApp());

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
  //var fileHandler = FileHandler(Constants.json_file);

  @override
  State<StatefulWidget> createState() {
    return new _MainPageState();
  }
}

class _MainPageState extends State<_MainPage> {
  List<String> data = ["item1", "item2", "item3", "item4"];
  int calorie_goal = Constants.defaultCalorieGoal;
  int _dialogueVal;

  _loadCalories() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      if (pref.containsKey(Constants.calorie_goal_key)) {
        this.calorie_goal = pref.getInt(Constants.calorie_goal_key);
      }
    });
  }

  _setcalories(int calories) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(Constants.calorie_goal_key, calories);
    _loadCalories();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCalories();
  }

  //APP BAR, SCAFFOLD AND POPUP MENU
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(actions: <Widget>[
        PopupMenuButton<String>(
          itemBuilder: (BuildContext context) {
            return Options.options.map((String option) {
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
    );
  }

  //List of foods for today
  List<Widget> _generateFoodList() {
    return data.map((String item) {
      return new Row(
        children: <Widget>[
          new Padding(padding: EdgeInsets.all(2.0)),
          new Align(
              alignment: Alignment.centerLeft,
              child: new InkWell(
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(Constants.delete),
                          actions: <Widget>[
                            new FlatButton(
                                onPressed: () {
                                  setState(() {
                                    data.remove(item);
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text(Constants.yes)),
                            new FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  Constants.no,
                                  style: TextStyle(color: Colors.red),
                                ))
                          ],
                        );
                      });
                },
                child: new Text(item, textScaleFactor: 1.25),
              ))
        ],
      );
    }).toList();
  }

  //Main Page
  Widget _buildPage() {
    return MyColumn([
      new Padding(padding: EdgeInsets.all(5.0)),
      new _ProgressBar(0.8, this.calorie_goal),
      new Padding(padding: EdgeInsets.all(5.0)),
      new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text("Todays Meals", textScaleFactor: 1.5),
          new RaisedButton(
            onPressed: () {}, //TODO: ADD MEALS
            child: new Icon(Icons.add),
          )
        ],
      ),
      new Padding(padding: EdgeInsets.all(5.0)),
      new Column(
        children: _generateFoodList(),
      )
    ]);
  }

  //APPBAR
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

  //TODO MAKE THIS ITS OWN PAGE
  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(Constants.calorie_goal_promopt),
            content: new TextField(
              decoration: new InputDecoration(hintText: Constants.type),
              keyboardType: TextInputType.number,
              onSubmitted: (String val) {
                this._dialogueVal = int.parse(val);
              },
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(Constants.cancel,
                      style: TextStyle(color: Colors.red))),
              FlatButton(
                onPressed: () {
                  this._setcalories(this._dialogueVal);
                  Navigator.pop(context);
                },
                child: Text(Constants.okay),
              )
            ],
          );
        });
  }

  void _choice(String choice) {
    if (choice == Options.foodlib) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => new Page_2()));
    } else if (choice == Options.ingredientlib) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new IngredientMain()));
    } else if (choice == Options.refresh) {
    } else if (choice == Options.calorieGoal) {
      _showMaterialDialog();
    }
  }
}

class _ProgressBar extends CircularPercentIndicator {
  _ProgressBar(double percentage, int calorie_display)
      : super(
            percent: percentage,
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
}
