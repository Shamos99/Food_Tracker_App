import 'package:flutter/material.dart';
import 'package:food_tracker/UI/ingredient_add.dart';
import 'package:food_tracker/Model/Ingredient.dart';
import 'package:food_tracker/Model/ModelManager.dart';
import 'custom.dart';
import 'package:food_tracker/Model/IngredientAmount.dart';

class IngredientSearch extends StatefulWidget {
  List<IngredientAmount> selectedIngredients;
  List<Ingredient> all_ingredients;
  List<Ingredient> toSearch = new List<Ingredient>();
  ModelManager manager = ModelManager();

  IngredientSearch(this.selectedIngredients, this.all_ingredients) {
    this.start_routine();
  }

  void start_routine() {
    toSearch.clear();
    for (Ingredient ingredient in all_ingredients) {
      if (selectedIngredients
          .every((selected) => selected.thisingredient != ingredient)) {
        toSearch.add(ingredient);
      }
    }
  }

  @override
  State<StatefulWidget> createState() {
    return IngredientSearchSate();
  }
}

class IngredientSearchSate extends State<IngredientSearch> {
  List<Ingredient> allIngredients;
  List<Ingredient> toSearch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Constants.search_ingredients),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _addingredient,
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: SearchHandler(toSearch));
              },
            ),
          ],
        ),
        body: toSearch.isEmpty
            ? Center(
                child: Text(Constants.noIngredients),
              )
            : myIngredientListView_add_to_meal(context, toSearch, false));
  }

  @override
  void initState() {
    this.start_routine();
  }

  void start_routine() {
    setState(() {
      allIngredients = widget.all_ingredients;
      toSearch = widget.toSearch;
    });
  }

  void _addingredient() {
    Navigator.push(context,
            new MaterialPageRoute(builder: (context) => IngredientAdd()))
        .then((value) {
      if (value == Constants.success) {
        widget.manager.initModel().then((value) {
          widget.all_ingredients = widget.manager.ingredients;
          widget.start_routine();
          this.start_routine();
        });
      }
    });
  }
}

class SearchHandler extends SearchDelegate<String> {
  List<Ingredient> toSearch = new List<Ingredient>();

  SearchHandler(this.toSearch);

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
    final results = searchResults_ingredients(query, toSearch);

    return results.isEmpty
        ? Center(
            child: Text(Constants.nothingfound),
          )
        : myIngredientListView_add_to_meal(context, results, true);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Ingredient> suggestionlist =
        searchResults_ingredients(query, toSearch);

    return suggestionlist.isEmpty
        ? Center(child: Text(Constants.noIngredients))
        : myIngredientListView_add_to_meal(context, suggestionlist, true);
  }
}
