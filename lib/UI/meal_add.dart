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
  bool added_invis_cals = false;

  //final _dialoguekey = new GlobalKey<FormState>();
  String currentName;
  ModelManager manager;

  @override
  void initState() {
    manager = widget.manager;
    if (widget.meal_to_edit != null) {
      selectedIngredients = widget.meal_to_edit.ingredientList;
      currentName = widget.meal_to_edit.name;
      if (!selectedIngredients.every(
          (ing) => ing.thisingredient.name != Constants.invis_cal_name)) {
        this.added_invis_cals = true;
      }
    }
    currentMacros = getMealMacros(selectedIngredients);
  }

  void _cals_manually_set(IngredientAmount ingredientAmount) {
    setState(() {
      selectedIngredients.add(ingredientAmount);
      currentMacros = getMealMacros(selectedIngredients);
      added_invis_cals = true;
    });
  }

  void _choice(String option) {
    if (option == Options.add_cals_manually) {
      if (!added_invis_cals) {
        //_set_meal_cal(context: context, set_cal_callback: _cals_manually_set);
        showDialog(
            context: context,
            builder: (context) =>
                _MealAlert(set_cal_callback: _cals_manually_set));
      } else {
        show_simple_dialogue(context, Constants.already_added_invis_cals);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal_to_edit == null
            ? Constants.createMeal
            : Constants.editMeal),
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return [Options.add_cals_manually].map((String option) {
                return PopupMenuItem<String>(
                    value: option, child: Text(option));
              }).toList();
            },
            onSelected: _choice,
          )
        ],
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
                  } else if (currentName.trim().length == 0) {
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
              autovalidate: true,
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
              onEditingComplete: () {
                setState(() {
                  currentMacros;
                });
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
                              if (ingredient.thisingredient.name ==
                                  Constants.invis_cal_name) {
                                this.added_invis_cals = false;
                              }
                              selectedIngredients.remove(ingredient);
                              currentMacros =
                                  getMealMacros(selectedIngredients);
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
        show_simple_dialogue(context, Constants.emptyError);
        return;
      }

      if (selectedIngredients.length < 1) {
        show_simple_dialogue(context, Constants.angry2);
        return;
      }

      currentName = currentName.trim();

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

class _MealAlert extends StatefulWidget {
  Function set_cal_callback;

  @override
  State<StatefulWidget> createState() {
    return _MealAlertAState();
  }

  _MealAlert({@required this.set_cal_callback});
}

class _MealAlertAState extends State<_MealAlert> {
  String error_msg = "";
  double _cals, _protein, _carbs, _fats;
  final _alert_form_key = new GlobalKey<FormState>();

  void display_error(String error) {
    setState(() {
      error_msg = error;
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            error_msg = "";
          });
        }
      });
    });
  }

  void resetvariables() {
    _cals = null;
    _protein = null;
    _fats = null;
    _carbs = null;
  }

  void validate() {
    final form = _alert_form_key.currentState;
    if (form.validate()) {
      HandleItemCreation myItemCreation = HandleItemCreation(
          cals: _cals, fats: _fats, protein: _protein, carbs: _carbs);
      if (myItemCreation.do_my_shit()) {
        _cals = myItemCreation.cals;
        _protein = myItemCreation.protein;
        _carbs = myItemCreation.carbs;
        _fats = myItemCreation.fats;
        widget.set_cal_callback(IngredientAmount(
            Ingredient(
                Constants.invis_cal_name, _cals, _protein, _carbs, _fats),
            1));
        Navigator.pop(context);
      } else {
        String prompt = myItemCreation.prompt;
        display_error(prompt);
      }
    }
    resetvariables();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Constants.enter_extra_cals),
      content: Form(
        key: _alert_form_key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      keyboardType: platformspecificKeyboard(),
                      decoration: InputDecoration(
                          labelText: Constants.calories,
                          labelStyle: TextStyle(color: Colors.blueGrey),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.lightBlue[50]))),
                      validator: (String value) {
                        if (value.isEmpty) {
                          _cals = null;
                          return null;
                        } else if (isValidNum(value)) {
                          if (double.parse(value) == 0) {
                            return Constants.zero_cals;
                          }
                          _cals = double.parse(value);
                          return null;
                        }
                        return Constants.number_error_prompt;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Flexible(
                    child: TextFormField(
                      keyboardType: platformspecificKeyboard(),
                      decoration: InputDecoration(
                          labelText: Constants.protein,
                          labelStyle: TextStyle(color: Colors.blueGrey),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.lightBlue[50]))),
                      validator: (String value) {
                        if (value.isEmpty) {
                          _protein = null;
                          return null;
                        } else if (isValidNum(value)) {
                          _protein = double.parse(value);
                          return null;
                        }
                        return Constants.number_error_prompt;
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      keyboardType: platformspecificKeyboard(),
                      decoration: InputDecoration(
                          labelText: Constants.carbs,
                          labelStyle: TextStyle(color: Colors.blueGrey),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.lightBlue[50]))),
                      validator: (String value) {
                        if (value.isEmpty) {
                          _carbs = null;
                          return null;
                        } else if (isValidNum(value)) {
                          _carbs = double.parse(value);
                          return null;
                        }
                        return Constants.number_error_prompt;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Flexible(
                    child: TextFormField(
                      keyboardType: platformspecificKeyboard(),
                      decoration: InputDecoration(
                          labelText: Constants.fats,
                          labelStyle: TextStyle(color: Colors.blueGrey),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.lightBlue[50]))),
                      validator: (String value) {
                        if (value.isEmpty) {
                          _fats = null;
                          return null;
                        } else if (isValidNum(value)) {
                          _fats = double.parse(value);
                          return null;
                        }
                        return Constants.number_error_prompt;
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(2.5),
              child: Text(
                error_msg,
                textScaleFactor: 0.8,
                style: TextStyle(color: Colors.red),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(2.5),
              child: RaisedButton(
                child: Text(Constants.done),
                onPressed: () {
                  validate();
                },
              ),
            )
          ],
          //mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }
}
