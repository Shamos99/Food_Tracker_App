import 'package:flutter/material.dart';
import 'package:food_tracker/Utility/FileHandler.dart';
import 'custom.dart';
import 'ingredient_add.dart';
import 'package:food_tracker/Model/Ingredient.dart';
import 'package:food_tracker/Model/ModelManager.dart';
import 'package:json_annotation/json_annotation.dart';

class IngredientMain extends StatefulWidget {
  var filehandler = new FileHandler(Constants.ingredients_json);
  ModelManager manager = ModelManager();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new IngredientMainState();
  }
}

class IngredientMainState extends State<IngredientMain> {
  List<Ingredient> ingredients = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._startroutine();
  }

  void _startroutine() {
    widget.filehandler.readData().then((String value) {
      widget.manager.createIngredients(value);
      mysetState();
    });
  }

  void mysetState() {
    setState(() {
      ingredients = widget.manager.ingredients;
    });
  }

  void saveData() {
    String myjson = widget.manager.ingredientsJson();
    widget.filehandler.writeData(myjson).then((value) {
      mysetState();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(title: new Text(Constants.ingredientPageTitle)),
        body: Builder(builder: (BuildContext context) {
          return MyColumn([
            new Container(
              child: new Align(
                //Add a new ingredient
                child: new FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new IngredientAdd()))
                        .then((value) {
                      this._startroutine();
                    });
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.lightBlueAccent,
                ),
              ),
              padding: EdgeInsets.all(5.0),
            ),
            new Expanded(
                child: ingredients.isEmpty
                    ? Center(child: Text(Constants.noIngredients))
                    : ListView.builder(
                        itemBuilder: this._listBuilder,
                        itemCount: this.ingredients.length))
          ]);
        }));
  }

  String _getMacros(int index) {
    Ingredient thisIngredient = ingredients[index];
    String toReturn = thisIngredient.protein.toString() + "p";
    if (thisIngredient.carbs != null) {
      toReturn += " " + thisIngredient.carbs.toString() + "c";
    }
    if (thisIngredient.fats != null) {
      toReturn += " " + thisIngredient.fats.toString() + "f";
    }
    return toReturn;
  }

  Widget _listBuilder(BuildContext context, int index) {
    return Card(
        child: ListTile(
      title: Text(ingredients[index].name),
      subtitle: Text(_getMacros(index)), //TODO need to make this proper
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(Constants.delete),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {
                        //delete shit and set state and all
                        widget.manager.deleteIngredient(ingredients[index]);
                        saveData();
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
    ));
  }

  @deprecated
  void _navigate(BuildContext context) async {
    final result = await Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new IngredientAdd()));

    if (result == null) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(":("),
          duration: Duration(seconds: Constants.snackbar_duration),
          backgroundColor: Colors.deepOrange,
        ));
    } else {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text("yass girl"),
          duration: Duration(seconds: Constants.snackbar_duration),
          backgroundColor: Colors.yellowAccent,
        ));
      this.initState();
    }
  }
}
