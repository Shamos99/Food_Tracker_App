import 'package:flutter/material.dart';
import 'package:food_tracker/Utility/FileHandler.dart';
import 'custom.dart';

class Page_2 extends StatefulWidget {

  var filehandler = new FileHandler(Constants.json_file);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    filehandler.writeData("this is a test....");
    return new Page_2_State();
  }
}

class Page_2_State extends State<Page_2> {

  String data="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.filehandler.readData().then((String string) {
      setState(() {
        data = string;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(title: new Text("Page 2")),
      body: new Column(),
    );
  }


}