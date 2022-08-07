import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:testsql/model/list_model.dart';
import 'package:testsql/service/list_service.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  var todoItemController = TextEditingController();
  var todoQuantityController = TextEditingController();

  var _listModel = ListModel();
  var _listService = ListService();

  var info;

  List<ListModel> _listModelInfo = <ListModel>[];

  @override
  void initState() {
    super.initState();
    getAllListModel();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          )),
      body: Container(
        margin: EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 10),
        child: Padding(
          padding: EdgeInsets.only(top: 15, bottom: 15),
          child: ListView(
            children: [
              TextField(
                controller: todoItemController,
                decoration: InputDecoration(
                    labelText: 'Item',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4))),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: todoQuantityController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4))),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.redAccent,
                          child: Text(
                            'Cancle',
                            style: TextStyle(color: Colors.white),
                            textScaleFactor: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: RaisedButton(
                          onPressed: () async {
                            _listModel.name = todoItemController.text;
                            _listModel.quantity = todoQuantityController.text;

                            var result =
                                await _listService.saveList(_listModel);
                            print(result);
                            if (result != null) {
                              Navigator.pop(context);
                              getAllListModel();
                            }
                            setState(() {});
                          },
                          color: Colors.blue,
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                            textScaleFactor: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
