import 'package:flutter/material.dart';
import 'custom.dart';
import 'package:food_tracker/Model/ModelManager.dart';
import 'package:food_tracker/Model/Ingredient.dart';

class IngredientAdd extends StatefulWidget {
  ModelManager manager = new ModelManager();
  Ingredient ingredient_to_edit;

  //constructor
  IngredientAdd({Ingredient edit_ingredient: null}) {
    ingredient_to_edit = edit_ingredient;
    manager.initModel();
  }

  @override
  State<StatefulWidget> createState() {
    return IngredientAddState();
  }
}

class IngredientAddState extends State<IngredientAdd> {
  final _formkey = new GlobalKey<FormState>();
  String _ingredientName;
  double _cals, _protein, _carbs, _fats;

  @override
  void initState() {
    if (widget.ingredient_to_edit != null) {
      _ingredientName = widget.ingredient_to_edit.name;
      _cals = widget.ingredient_to_edit.calories;
      _protein = widget.ingredient_to_edit.protein;
      _carbs = widget.ingredient_to_edit.carbs;
      _fats = widget.ingredient_to_edit.fats;
    }
  }

  void _round_down_all() {
    if (_protein != null) {
      _protein = double.parse(_protein.toStringAsFixed(2));
    }
    if (_carbs != null) {
      _carbs = double.parse(_carbs.toStringAsFixed(2));
    }
    if (_fats != null) {
      _fats = double.parse(_fats.toStringAsFixed(2));
    }
    if (_fats != null) {
      _fats = double.parse(_fats.toStringAsFixed(2));
    }
  }

  void _validateAdd() {
    final form = _formkey.currentState;
    if (form.validate()) {
      if (_validateIngredient()) {
        if (_cals == 0) {
          resetvariables();
          _showDialog(Constants.angry2);
          return;
        }
        if (widget.ingredient_to_edit != null) {
          widget.manager.edit_ingredient(widget.ingredient_to_edit,
              Ingredient(_ingredientName, _cals, _protein, _carbs, _fats));
        } else {
          widget.manager.addIngedient(
              Ingredient(_ingredientName, _cals, _protein, _carbs, _fats));
        }
        widget.manager.saveModel().then((value) {
          Navigator.pop(context, Constants.success);
        });
      }
    }
    resetvariables();
  }

  void _showDialog(String prompt) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Text(
                prompt,
                textScaleFactor: 1.25,
              ),
              title: Icon(
                Icons.warning,
                color: Colors.red,
                size: 40,
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(Constants.okay,
                        style: TextStyle(color: Colors.blue))),
              ]);
        });
  }

  //SEE IF WE CAN MAKE AN INGREDIENT OR NOT
  bool _validateIngredient() {
    //check if the same named ingredient exists
    if (widget.ingredient_to_edit == null) {
      if (widget.manager.does_exist_ingredient_name(_ingredientName)) {
        _showDialog(Constants.sameNamePromtIngredient);
        resetvariables();
        return false;
      }
    } else {
      if (widget.manager.does_ingredient_exist_edit(
          widget.ingredient_to_edit.name, _ingredientName)) {
        _showDialog(Constants.sameNamePromtIngredient);
        resetvariables();
        return false;
      }
    }

    HandleItemCreation handleItemCreation = HandleItemCreation(
        cals: _cals, carbs: _carbs, fats: _fats, protein: _protein);

    if (handleItemCreation.do_my_shit()) {
      _cals = handleItemCreation.cals;
      _protein = handleItemCreation.protein;
      _carbs = handleItemCreation.carbs;
      _fats = handleItemCreation.fats;
      return true;
    } else {
      _showDialog(handleItemCreation.prompt);
      return false;
    }
  }

  void resetvariables() {
    _ingredientName = null;
    _cals = null;
    _protein = null;
    _fats = null;
    _carbs = null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.ingredient_to_edit == null
            ? Constants.add_ingredient
            : Constants.editIngredient),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formkey,
            child: new Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  Constants.per_serving_size,
                  style: TextStyle(
                      color: Colors.pinkAccent.withOpacity(0.5),
                      fontStyle: FontStyle.italic),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  //Ingredient Validator
                  initialValue: _ingredientName,
                  validator: (value) {
                    this._ingredientName = value;
                    if (value.isEmpty) {
                      return Constants.emptyError;
                    } else if (_ingredientName.trim().length == 0) {
                      return Constants.emptyError;
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: Constants.ingredientName,
                    labelStyle: TextStyle(
                      color: Colors.lightBlueAccent,
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                ),
              ),
              new Row(
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: platformspecificKeyboard(),
                        //Calories Validator
                        //WE MUST HAVE CALORIES
                        initialValue: _cals == null ? "" : _cals.toString(),
                        validator: (value) {
                          if (value.isEmpty) {
                            _cals = null;
                            return null;
                          } else if (isValidNum(value)) {
                            if (double.parse(value) == 0) {
                              return Constants.zero_cals;
                            }
                            this._cals = double.parse(value);
                            return null;
                          }
                          return Constants.number_error_prompt;
                        },
                        decoration: InputDecoration(
                            labelText: Constants.calories,
                            labelStyle: TextStyle(
                              color: Colors.lightBlueAccent,
                            ),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(25.0))),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: platformspecificKeyboard(),
                        initialValue:
                            _protein == null ? "" : _protein.toString(),
                        //Protein Validator
                        //WE MUST HAVE PROTEIN
                        validator: (value) {
                          if (value.isEmpty) {
                            _protein = null;
                            return null;
                          } else if (isValidNum(value)) {
                            this._protein = double.parse(value);
                            return null;
                          }
                          return Constants.number_error_prompt;
                        },
                        decoration: InputDecoration(
                            labelText: Constants.protein,
                            labelStyle: TextStyle(
                              color: Colors.lightBlueAccent,
                            ),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(25.0))),
                      ),
                    ),
                  ),
                ],
              ),
              new Row(
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: platformspecificKeyboard(),
                        initialValue: _carbs == null ? "" : _carbs.toString(),
                        //Carbs Validator
                        validator: (value) {
                          if (isValidNum(value)) {
                            this._carbs = double.parse(value);
                            return null;
                          } else if (value.isEmpty) {
                            _carbs = null;
                            return null;
                          }
                          return Constants.number_error_prompt;
                        },
                        decoration: InputDecoration(
                            labelText: Constants.carbs,
                            labelStyle: TextStyle(
                              color: Colors.lightBlueAccent,
                            ),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(25.0))),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: _fats == null ? "" : _fats.toString(),
                        keyboardType: platformspecificKeyboard(),
                        //Fats Validator
                        validator: (value) {
                          if (isValidNum(value)) {
                            this._fats = double.parse(value);
                            return null;
                          } else if (value.isEmpty) {
                            _fats = null;
                            return null;
                          }
                          return Constants.number_error_prompt;
                        },
                        decoration: InputDecoration(
                            labelText: Constants.fats,
                            labelStyle: TextStyle(
                              color: Colors.lightBlueAccent,
                            ),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(25.0))),
                      ),
                    ),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: _validateAdd,
                child: Text(Constants.saveingredient),
              )
            ])),
      ),
    );
  }

  @deprecated
  void _IngredientMisMatchDialogue() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Baka"),
              content: Text("explanation..."),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(Constants.cancel,
                        style: TextStyle(color: Colors.red))),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(Constants.okay),
                )
              ]);
        });
  }
}
