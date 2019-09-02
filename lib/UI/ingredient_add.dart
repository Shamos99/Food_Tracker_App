import 'package:flutter/material.dart';
import 'custom.dart';
import 'package:food_tracker/Model/ModelManager.dart';
import 'package:food_tracker/Model/Ingredient.dart';
import 'package:food_tracker/Utility/FileHandler.dart';

class IngredientAdd extends StatefulWidget {
  ModelManager manager = new ModelManager();
  FileHandler fileHandler = new FileHandler(Constants.ingredients_json);

  //constructor
  IngredientAdd() {
    fileHandler.readData().then((String value) {
      manager.createIngredients(value);
    });
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return IngredientAddState();
  }
}

class IngredientAddState extends State<IngredientAdd> {
  final _formkey = new GlobalKey<FormState>();
  String _ingredientName;
  int _cals, _protein, _carbs, _fats;

  void _validateAdd() {
    final form = _formkey.currentState;
    if (form.validate()) {
      if (_validateIngredient()) {
        //TODO WE CAN MAKE AN INGREDIENT
        widget.manager.addIngedient(
            Ingredient(_ingredientName, _cals, _protein, _carbs, _fats));
        widget.fileHandler
            .writeData(widget.manager.ingredientsJson())
            .then((value) {
          Navigator.pop(context);
        });
      }
    } else {
      resetvariables();
    }
  }

  void _showDialog(String prompt) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(prompt), actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:
                    Text(Constants.okay, style: TextStyle(color: Colors.blue))),
          ]);
        });
  }

  //TODO need to flesh this out
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

  //SEE IF WE CAN MAKE AN INGREDIENT OR NOT
  bool _validateIngredient() {
    //check if the same named ingredient exists
    widget.manager.ingredients.forEach((Ingredient ingredient) {
      if (true) {
        //TODO INGREDIENT SIMILARITY ERROR
        //_showMaterialDialog();
        //resetvariables();
        return false;
      }
    });
    int total = 0;
    //now see if numbers add up
    if (_carbs != null && _fats != null) {
      int total = _carbs * Constants.carbs_cals_per_gram +
          _fats * Constants.fats_cals_per_gram +
          _protein * Constants.protein_cals_per_gram;
      if (_cals != total) {
        _showDialog(Constants.total_cals_not_adding);
        resetvariables();
        return false;
      }
    }
    total = _protein * Constants.protein_cals_per_gram;
    if (_carbs != null) {
      total += _carbs * Constants.carbs_cals_per_gram;
    } else if (_fats != null) {
      total += _fats * Constants.fats_cals_per_gram;
    }

    if (total == 0 || total > _cals) {
      _showDialog(Constants.cals_prompt_not_all_macros);
      resetvariables();
      return false;
    }

    return true;
  }

  void resetvariables() {
    _ingredientName = null;
    _cals = null;
    _protein = null;
    _fats = null;
    _carbs = null;
  }

  //see if a num is greater than zero or parsable
  bool _isValidNum(value) {
    int myval = int.tryParse(value);
    if (myval == null) {
      return false;
    } else if (myval < 0) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(Constants.add_ingredient),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formkey,
            child: new Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  Constants.per_100_gm_or_ml,
                  style: TextStyle(
                      color: Colors.pinkAccent.withOpacity(0.5),
                      fontStyle: FontStyle.italic),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  //Ingredient Validator
                  validator: (value) {
                    if (value.isEmpty) {
                      return Constants.emptyError;
                    }
                    this._ingredientName = value;
                    return null;
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
                        keyboardType: TextInputType.number,
                        //Calories Validator
                        //WE MUST HAVE CALORIES
                        validator: (value) {
                          if (value.isEmpty) {
                            return Constants.protein_cals_explanation;
                          } else if (_isValidNum(value)) {
                            this._cals = int.parse(value);
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
                        keyboardType: TextInputType.number,
                        //Protein Validator
                        //WE MUST HAVE PROTEIN
                        validator: (value) {
                          if (value.isEmpty) {
                            return Constants.protein_cals_explanation;
                          } else if (_isValidNum(value)) {
                            this._protein = int.parse(value);
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
                        keyboardType: TextInputType.number,
                        //Carbs Validator
                        validator: (value) {
                          if (_isValidNum(value)) {
                            this._carbs = int.parse(value);
                            return null;
                          } else if (value.isEmpty) {
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
                        keyboardType: TextInputType.number,
                        //Fats Validator
                        validator: (value) {
                          if (_isValidNum(value)) {
                            this._fats = int.parse(value);
                            return null;
                          } else if (value.isEmpty) {
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
                child: Icon(Icons.add),
              )
            ])),
      ),
    );
  }
}
