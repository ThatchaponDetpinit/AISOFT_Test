import 'package:testsql/database/repository.dart';

import '../model/list_model.dart';

class ListService {
  Repository? _repository;

  ListService() {
    _repository = Repository();
  }
  //Create data
  saveList(ListModel listModel) async {
    print(listModel.name);
    return await _repository?.insertData('test', listModel.listModelMap());
  }

  //Read data from table
  readList() async {
    return await _repository?.readData('test');
  }

  //Read data from Id
  readListById(listModelId) async {
    return await _repository?.readDataById('test', listModelId);
  }

  //Update data from table
  updateList(ListModel listModel) async {
    return await _repository?.updateData('test', listModel.listModelMap());
  }

  //delete data from table
  deleteList(listModelId) async {
    return await _repository?.deleteData('test', listModelId);
  }
}
