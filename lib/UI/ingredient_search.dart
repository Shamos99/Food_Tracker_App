import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:food_tracker/Model/Ingredient.dart';
import 'package:food_tracker/Model/ModelManager.dart';
import 'custom.dart';
import 'package:food_tracker/Model/IngredientAmount.dart';

class IngredientSearch extends StatefulWidget {
  final List<IngredientAmount> selectedIngredients;
  final List<Ingredient> all_ingredients;
  List<Ingredient> toSearch = new List<Ingredient>();

  IngredientSearch(this.selectedIngredients, this.all_ingredients) {
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
              icon: Icon(Icons.map),
              onPressed: () {},
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
    allIngredients = widget.all_ingredients;
    toSearch = widget.toSearch;
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
    final List<Ingredient> suggestionlist = searchResults_ingredients(query, toSearch);

    return suggestionlist.isEmpty
        ? Center(child: Text(Constants.noIngredients))
        : myIngredientListView_add_to_meal(context, suggestionlist, true);
  }
}
