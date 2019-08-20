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
  static const String appTitle = "EZ Calories";
  static const String delete = "Delete?";
  static const String yes = "Yes";
  static const String no = "No";
  static const String json_file = "test.txt";
  static const String calorie_goal_key = "calories";
  static const String calorie_goal_promopt = "Enter your calorie goal";
  static const String cancel = "Cancel";
  static const String okay = "Okay";
  static const String type = "Type...";
  static const int defaultCalorieGoal = 2000;
  static const String ingredientPage = "Ingredient Library";
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
