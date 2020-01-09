import 'package:flutter/material.dart';
import 'package:food_tracker/Model/Ingredient.dart';
import 'package:food_tracker/Model/IngredientAmount.dart';
import 'package:food_tracker/Model/ModelManager.dart';
import 'custom.dart';
import 'ingredient_search.dart';
import 'package:food_tracker/Model/Meal.dart';

class MealAdd extends StatefulWidget {
  ModelManager manager = new ModelManager();
  Meal meal_to_edit;

  MealAdd({meal_edit: null}) {
    manager.initModel();
    meal_to_edit = meal_edit;
  }

  @override
  State<StatefulWidget> createState() {
    return MealAddState();
  }
}

class MealAddState extends State<MealAdd> {
  List<IngredientAmount> selectedIngredients = new List<IngredientAmount>();
  String currentMacros;
  final _formkey = new GlobalKey<FormState>();
  final _nameformkey = new GlobalKey<FormState>();
  String currentName;
  ModelManager manager;

  @override
  void initState() {
    manager = widget.manager;
    if (widget.meal_to_edit != null) {
      selectedIngredients = widget.meal_to_edit.ingredientList;
      currentName = widget.meal_to_edit.name;
    }
    currentMacros = getMealMacros(selectedIngredients);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal_to_edit == null
            ? Constants.createMeal
            : Constants.editMeal),
      ),
      body: Column(
        children: <Widget>[
          //Meal Name
          Padding(
            padding: EdgeInsets.only(
                left: 10.0, right: 10.0, top: 15.0, bottom: 5.0),
            child: Form(
              autovalidate: true,
              key: _nameformkey,
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: Constants.mealName,
                    labelStyle: TextStyle(color: Colors.lightBlueAccent),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    )),
                initialValue: this.currentName,
                validator: (value) {
                  currentName = value;
                  if (value.isEmpty) {
                    return Constants.emptyError;
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          //Current Macros
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  currentMacros,
                  maxLines: 2,
                ),
              ),
            ),
          ),
          //Meal List
          Expanded(
            child: Form(
              key: _formkey,
              autovalidate: true,
              child: ListView(
                children: _mealList(),
              ),
            ),
          ),

          //FINAL ADD BUTTON

          Padding(
            padding: EdgeInsets.all(10.0),
            child: FloatingActionButton(
              onPressed: _addButtonPressed,
              child: Icon(Icons.add),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
              onPressed: handleSaveMeal,
              child: Text(Constants.saveMeal),
            ),
          )
        ],
      ),
    );
  }

  void _addButtonPressed() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new IngredientSearch(
                selectedIngredients, manager.ingredients))).then((value) {
      handleNewIngredient(value);
    });
  }

  void handleNewIngredient(Ingredient ingredient) {
    if (ingredient != null) {
      setState(() {
        selectedIngredients.add(IngredientAmount(ingredient, 1.0));
        currentMacros = getMealMacros(selectedIngredients);
      });
    }
  }

  //generate and handle the current ingredient selection list
  List<Widget> _mealList() {
    return selectedIngredients.map((ingredient) {
      return Card(
        child: ListTile(
          title: Text(ingredient.thisingredient.name),
          subtitle: Text(getIngredientMacros(ingredient.thisingredient,
              amount: ingredient.amount)),
          trailing: FractionallySizedBox(
            child: TextFormField(
              initialValue: ingredient.amount.toString(),
              decoration: InputDecoration(
                  prefix: Text('x  '),
                  hintText: Constants.enteramount,
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlue))),
              keyboardType: platformspecificKeyboard(),
              validator: (value) {
                if (value == "") {
                  return null;
                }
                double thisamount = double.tryParse(value);
                if (thisamount == null || thisamount <= 0) {
                  return Constants.angry;
                } else {
                  ingredient.amount = thisamount;
                  currentMacros = getMealMacros(
                    selectedIngredients,
                  );
                  return null;
                }
              },
            ),
            widthFactor: 0.35,
          ),
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
                              selectedIngredients.remove(ingredient);
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
        ),
      );
    }).toList();
  }

  void handleSaveMeal() {
    final form = _formkey.currentState;
    final nameform = _nameformkey.currentState;

    if (form.validate()) {
      if (currentName == null || currentName.length < 1) {
        show_simple_dialogue(context, Constants.emptyError);
        return;
      } else if (!nameform.validate()) {
        //show_simple_dialogue(context, Constants.sameNamePromptMeal);
        return;
      }

      if (selectedIngredients.length < 1) {
        show_simple_dialogue(context, Constants.angry2);
        return;
      }

      if (this.widget.meal_to_edit == null) {
        if (manager.does_meal_name_exist(currentName)) {
          show_simple_dialogue(context, Constants.sameNamePromptMeal);
          return;
        } else {
          manager.addMeal(Meal(currentName, selectedIngredients));
          manager.saveModel().then((value) {
            Navigator.pop(context, Constants.success);
          });
        }
      } else {
        if (manager.does_meal_name_exist_edit(
            widget.meal_to_edit.name, currentName)) {
          show_simple_dialogue(context, Constants.sameNamePromptMeal);
        } else {
          manager.edit_meal(
              widget.meal_to_edit, Meal(currentName, selectedIngredients));
          manager.saveModel().then((value) {
            Navigator.pop(context, Constants.success);
          });
        }
      }
    }
  }
}
