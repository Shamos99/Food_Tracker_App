import 'package:flutter/material.dart';
import 'custom.dart';
import 'ingredient_add.dart';
import 'package:food_tracker/Model/Ingredient.dart';
import 'package:food_tracker/Model/ModelManager.dart';

class IngredientMain extends StatefulWidget {
  ModelManager manager = ModelManager();

  @override
  State<StatefulWidget> createState() {
    return new IngredientMainState();
  }
}

class IngredientMainState extends State<IngredientMain> {
  List<Ingredient> ingredients = [];
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  bool search = false;

  @override
  void initState() {
    super.initState();
    this._startroutine();
  }

  void _startroutine() {
    widget.manager.initModel().then((value) {
      mysetState();
    });
  }

  void mysetState() {
    setState(() {
      ingredients = widget.manager.ingredients;
    });
  }

  void saveData() {
    widget.manager.saveModel().then((value) {
      mysetState();
    });
  }

  List<Widget> this_appbar() {
    return [
      IconButton(
        icon: Icon(Icons.add),
        onPressed: addIngredient,
      ),
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          showSearch(
              context: context,
              delegate: SearchHandler(
                  ingredients, this._handle_editing, this.delete_callback));
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldState,
        appBar: new AppBar(
            title: new Text(Constants.ingredientPageTitle),
            actions: this_appbar()),
        body: Builder(builder: (BuildContext context) {
          return MyColumn([
            new Expanded(
                child: ingredients.isEmpty
                    ? Center(child: Text(Constants.noIngredients))
                    : ListView.builder(
                        itemBuilder: this._listBuilder,
                        itemCount: this.ingredients.length))
          ]);
        }));
  }

  void addIngredient() {
    Navigator.pushNamed(context, AppRoutes.add_ingredient).then((value) {
      if (value == Constants.success) {
        scaffoldState.currentState.removeCurrentSnackBar();
        scaffoldState.currentState.showSnackBar(myGenericSnackbar(value));
      }
      this._startroutine();
    });
  }

  @deprecated
  void _choice(String option) {
    if (option == Options.createIngredient) {
      addIngredient();
    } else if (option == Options.searchIngredeint) {
      setState(() {
        search = true;
      });
    }
  }

  void delete_callback(Ingredient ingredient) {
    //delete shit and set state and all
    widget.manager.initModel().then((value) {
      widget.manager.deleteIngredient(ingredient);
      saveData();
      Navigator.of(context).pop();
    });
  }

  String _getMacros(int index) {
    Ingredient thisIngredient = ingredients[index];
    return getIngredientMacros(thisIngredient);
  }

  //ENSURE THIS IS THE SAME AS THE LIST BUILDER IN THE SEARCH DELEGATE CLASS BELOW
  Widget _listBuilder(BuildContext context, int index) {
    return Card(
        child: ListTile(
      title: Text(ingredients[index].name),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          _handle_editing(ingredients[index], false);
        },
      ),
      subtitle: Text(_getMacros(index)),
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
                        delete_callback(ingredients[index]);
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

  void _handle_editing(Ingredient ingredient, bool pop) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new IngredientAdd(
                  edit_ingredient: ingredient,
                ))).then((value) {
      if (value == Constants.success) {
        if (pop) {
          Navigator.pop(context);
        }
        scaffoldState.currentState.removeCurrentSnackBar();
        scaffoldState.currentState.showSnackBar(myGenericSnackbar(value));
      }
      this._startroutine();
    });
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

class SearchHandler extends SearchDelegate {
  List<Ingredient> allingredients = new List<Ingredient>();
  Function editing;
  Function delete;

  SearchHandler(allingredients, editing, delete) {
    this.allingredients = List.from(allingredients);
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
    final List<Ingredient> results =
        searchResults_ingredients(query, allingredients);

    return results.isEmpty
        ? Center(child: Text(Constants.nothingfound))
        : _SearchListView(results, this.editing, this.delete);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Ingredient> suggestionlist =
        searchResults_ingredients(query, allingredients);

    return allingredients.isEmpty
        ? Center(child: Text(Constants.noIngredients))
        : _SearchListView(suggestionlist, this.editing, this.delete);
  }
}

class _SearchListView extends StatefulWidget {
  List<Ingredient> results = new List<Ingredient>();
  Function editing;
  Function delete;
  ModelManager manager = new ModelManager();

  _SearchListView(this.results, this.editing, this.delete);

  @override
  State<StatefulWidget> createState() {
    return _SearchListViewState(this.results);
  }
}

class _SearchListViewState extends State<_SearchListView> {
  List<Ingredient> results = new List<Ingredient>();

  _SearchListViewState(this.results);

  @override
  Widget build(BuildContext context) {
    return myIngredientListView_createIngredient(
        context, results, widget.editing, widget.delete);
  }

  //Creates the list view when we search for an ingredient
  Widget myIngredientListView_createIngredient(BuildContext context,
          List<Ingredient> ingredients, editing_callback, delete_callback) =>
      ListView.builder(
        itemBuilder: (context, index) => ListTile(
          title: Text(ingredients[index].name),
          subtitle: Text(getIngredientMacros(ingredients[index])),
          onTap: () {
            editing_callback(ingredients[index], true);
          },
          onLongPress: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(Constants.delete),
                    actions: <Widget>[
                      new FlatButton(
                          onPressed: () {
                            delete_callback(ingredients[index]);
                            setState(() {
                              results.remove(ingredients[index]);
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
        itemCount: ingredients.length,
      );
}
