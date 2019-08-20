import 'package:flutter/material.dart';
import 'package:food_tracker/Utility/FileHandler.dart';
import 'custom.dart';

class Page_3 extends StatefulWidget {
  var filehandler = new FileHandler(Constants.json_file);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    filehandler.writeData("this is a test....");
    return new Page_3_State();
  }
}

class Page_3_State extends State<Page_3> {
  List<String> data = ["item1", "item2", "item3", "item4"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  //TODO POPUP
  void _addIngredient() {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(title: new Text(Constants.ingredientPage)),
        body: MyColumn([
          new Container(
            child: new Align(
              child: new FloatingActionButton(
                onPressed: _addIngredient,
                child: Icon(Icons.add),
                backgroundColor: Colors.lightBlueAccent,
              ),
            ),
            padding: EdgeInsets.all(5.0),
          ),
          new Expanded(
              child: ListView.builder(
                  itemBuilder: this._listBuilder, itemCount: this.data.length))
        ]));
  }

  Widget _listBuilder(BuildContext context, int index) {
    return Card(
        child: ListTile(
      title: Text(data[index]),
      subtitle: Text("22f 33c 55p"),
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
                          data.removeAt(index);
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
    ));
  }
}
