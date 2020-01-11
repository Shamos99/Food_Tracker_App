import 'package:flutter/material.dart';
import 'package:food_tracker/Model/Meal.dart';
import 'package:food_tracker/Model/ModelManager.dart';
import 'custom.dart';
import 'meal_add.dart';

class Meal_Main extends StatefulWidget {
  ModelManager manager = new ModelManager();
  bool to_select = false;

  Meal_Main({bool to_select = false}) {
    this.to_select = to_select;
  }

  @override
  State<StatefulWidget> createState() {
    return Meal_Main_State();
  }
}

class Meal_Main_State extends State<Meal_Main> {
  List<Meal> meals = [];
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    this._startroutine();
  }

  void _startroutine() {
    widget.manager.initModel().then((value) {
      mysetState();
    });
  }

  void mysetState() {
    setState(() {
      meals = widget.manager.meals;
    });
  }

  void saveData() {
    widget.manager.saveModel().then((value) {
      mysetState();
    });
  }

  void newMeal() {
    Navigator.pushNamed(context, AppRoutes.add_meal).then((value) {
      scaffoldState.currentState.removeCurrentSnackBar();
      if (Constants.success == value) {
        scaffoldState.currentState.showSnackBar(myGenericSnackbar(value));
      }
      this._startroutine();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          title: Text(Constants.meallib),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: newMeal,
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: SearchHandler(
                        meals, this._handle_tap, this._handle_delete));
              },
            )
          ],
        ),
        body: Builder(builder: (BuildContext context) {
          return MyColumn([
            new Expanded(
                child: meals.isEmpty
                    ? Center(child: Text(Constants.noMeals))
                    : ListView.builder(
                        itemBuilder: this._listBuilder,
                        itemCount: this.meals.length))
          ]);
        }));
  }

  Widget _listBuilder(BuildContext context, int index) {
    return Card(
        child: ExpansionTile(
      children: meals[index].ingredientList.map((item) {
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
                getIngredientMacros(item.thisingredient, amount: item.amount),
            maxLines: 2,
          ),
        );
      }).toList(),
      title: ListTile(
        title: Text(meals[index].name),
        subtitle: Text(getMealMacros(meals[index].ingredientList)),
        //ON TAP EDIT
        onTap: () {
          _handle_tap(meals[index], false);
        },
        //HERE WE DELETE
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
                          this._handle_delete(meals[index]);
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
    ));
  }

  void _handle_delete(Meal meal) {
    widget.manager.initModel().then((value) {
      widget.manager.deleteMeal(meal);
      saveData();
      Navigator.of(context).pop();
    });
  }

  void _handle_meal_select_tap(Meal meal, bool pop) {
    if (pop) {
      Navigator.pop(context);
    }
    Navigator.pop(context, meal.name);
  }

  void _handle_tap(Meal meal, bool pop) {
    if (widget.to_select) {
      this._handle_meal_select_tap(meal, pop);
    } else {
      this._handle_editing(meal, pop);
    }
  }

  void _handle_editing(Meal meal, bool pop) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new MealAdd(
                  meal_edit: meal,
                ))).then((value) {
      if (pop) {
        Navigator.of(context).pop();
      }
      if (value == Constants.success) {
        scaffoldState.currentState.removeCurrentSnackBar();
        scaffoldState.currentState.showSnackBar(myGenericSnackbar(value));
      }
      this._startroutine();
    });
  }
}

class SearchHandler extends SearchDelegate {
  List<Meal> all_meals = new List<Meal>();
  Function editing;
  Function delete;

  SearchHandler(meals, editing, delete) {
    this.all_meals = List.from(meals);
    this.editing = editing;
    this.delete = delete;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Meal> results = searchResults_meals(query, all_meals);

    return results.isEmpty
        ? Center(child: Text(Constants.nothingfound))
        : _SearchListView(results, this.editing, this.delete);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Meal> suggestionlist = searchResults_meals(query, all_meals);

    return all_meals.isEmpty
        ? Center(child: Text(Constants.noMeals))
        : _SearchListView(suggestionlist, this.editing, this.delete);
  }
}

class _SearchListView extends StatefulWidget {
  List<Meal> results = new List<Meal>();
  Function editing;
  Function delete;
  ModelManager manager = new ModelManager();

  _SearchListView(this.results, this.editing, this.delete);

  @override
  State<StatefulWidget> createState() {
    return _SearchListViewState(results);
  }
}

class _SearchListViewState extends State<_SearchListView> {
  List<Meal> results = new List<Meal>();

  _SearchListViewState(this.results);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: this._listBuilder, itemCount: results.length);
  }

  Widget _listBuilder(BuildContext context, int index) {
    return Card(
        child: ExpansionTile(
      children: results[index].ingredientList.map((item) {
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
                getIngredientMacros(item.thisingredient, amount: item.amount),
            maxLines: 2,
          ),
        );
      }).toList(),
      title: ListTile(
        title: Text(results[index].name),
        subtitle: Text(getMealMacros(results[index].ingredientList)),
        //ON TAP EDIT
        onTap: () {
          //EDITING CALLBACK
          widget.editing(results[index], true);
        },
        //HERE WE DELETE
        onLongPress: () {
          //DELETE CALLBACK
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(Constants.delete),
                  actions: <Widget>[
                    new FlatButton(
                        onPressed: () {
                          //delete shit and set state and all
                          widget.delete(results[index]);
                          setState(() {
                            results.remove(results[index]);
                          });
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
    ));
  }
}
