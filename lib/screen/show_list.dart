import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testsql/model/list_model.dart';
import 'package:testsql/screen/add_item.dart';

import '../service/list_service.dart';

class ShowList extends StatefulWidget {
  const ShowList({Key? key}) : super(key: key);

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  var todoItemController = TextEditingController();
  var todoQuantityController = TextEditingController();

  var editItemController = TextEditingController();
  var editQuantityController = TextEditingController();

  var _listModel = ListModel();
  var _listService = ListService();

  var info;

  List<ListModel> _listModelInfo = <ListModel>[];
  @override
  void initState() {
    super.initState();
    getAllListModel();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllListModel() async {
    _listModelInfo = <ListModel>[];
    var test = await _listService.readList();
    test.forEach((info) {
      setState(() {
        var Model = ListModel();
        Model.name = info['name'];
        Model.quantity = info['quantity'];
        Model.id = info['id'];
        _listModelInfo.add(Model);
      });
    });
  }

  _editListModel(BuildContext context, listModelId) async {
    info = await _listService.readListById(listModelId);
    setState(() {
      editItemController.text = info[0]['name'] ?? 'No Name';
      editQuantityController.text = info[0]['quantity'] ?? 'No Quantity';
    });
    _editFormDialog(context);
  }

  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text("Edit Item & Quantity"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: editItemController,
                    decoration: InputDecoration(
                        labelText: 'Item',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: editQuantityController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4))),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  color: Colors.redAccent,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              FlatButton(
                  color: Colors.blueAccent,
                  onPressed: () async {
                    _listModel.id = info[0]['id'];
                    _listModel.name = editItemController.text;
                    _listModel.quantity = editQuantityController.text;

                    var result = await _listService.updateList(_listModel);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllListModel();
                      _showSuccessSnackBar(Text('Update Successful'));
                    }
                  },
                  child: Text("Update")),
            ],
          );
        });
  }

  _deleteFormDialog(BuildContext context, listModelId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text("Are you sure you want to delete Item?"),
            actions: <Widget>[
              FlatButton(
                  color: Colors.redAccent,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              FlatButton(
                  color: Colors.green,
                  onPressed: () async {
                    var result = await _listService.deleteList(listModelId);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllListModel();
                      _showSuccessSnackBar(Text('Delete Successful'));
                    }
                  },
                  child: Text("Delete")),
            ],
          );
        });
  }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState?.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Stack(
        children: [
          Positioned(
            child: Column(
              children: [
                Container(
                  height: 100,
                  padding:
                      EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                      color: Color(0xFFfcab88),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Center(
                          child: Text(
                            "Test",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 110,
            left: 280,
            right: 10,
            bottom: 540,
            child: FlatButton(
                color: Colors.green[300],
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddItem()));
                },
                child: Text("Add+",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white))),
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 10,
            //color: Colors.red,
            child: Container(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                    itemCount: _listModelInfo.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 2, left: 4, right: 4),
                        child: Card(
                          elevation: 8,
                          child: ListTile(
                            title:
                                Text('Item :  ' + _listModelInfo[index].name),
                            subtitle: Text('Quantity :  ' +
                                _listModelInfo[index].quantity),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        _editListModel(
                                            context, _listModelInfo[index].id);
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blueAccent,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        _deleteFormDialog(
                                            context, _listModelInfo[index].id);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          )

          //
        ],
      ),
    );
  }
}
