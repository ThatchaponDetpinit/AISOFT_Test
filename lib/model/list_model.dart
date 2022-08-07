class ListModel {
  int? id;
  late String name;
  late String quantity;

  listModelMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['quantity'] = quantity;

    return mapping;
  }
}
