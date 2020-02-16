part of "RaveApi.dart";

class RaveModel {
  Map<String, Object> items = new Map();
  Map<String, Object> itemUpdate = new Map();
  Map<String, Map> itemUpdateList = new Map();

  RaveModel({Map items}) {
    if (items != null) {
      Map<String, Object> theItems = Map.from(items);
      this.items = theItems;
    }
  }

  void put(String key, Object value) {
    items[key] = value;
    itemUpdate[key] = value;
  }

  void putInList(String key, Object value, bool add) {
    List itemsInList = items[key] == null ? List() : List.from(items[key]);
    if (add) {
      if (!itemsInList.contains(value)) itemsInList.add(value);
    } else {
      itemsInList.removeWhere((E) => E == value);
    }
    items[key] = itemsInList;

    Map update = Map();
    update[ADD] = add;
    update[VALUE] = value;

    itemUpdateList[key] = update;
  }

  void remove(String key) {
    items.remove(key);
    itemUpdate[key] = null;
  }

  String getObjectId() {
    Object value = items[OBJECT_ID];
    return value == null || !(value is String) ? "" : value.toString();
  }

  List getList(String key) {
    Object value = items[key];
    return value == null || !(value is List) ? new List() : List.from(value);
  }

  Map getMap(String key) {
    Object value = items[key];
    return value == null || !(value is Map)
        ? new Map<String, String>()
        : Map.from(value);
  }

  BaseModel getModel(String key) {
    return BaseModel(items: getMap(key));
  }

  Object get(String key) {
    return items[key];
  }

  String getString(String key) {
    Object value = items[key];

    return value == null || !(value is String) ? "" : value.toString();
  }

  int getInt(String key) {
    Object value = items[key];
    return value == null || !(value is int) ? 0 : (value);
  }

  double getDouble(String key) {
    Object value = items[key];
    return value == null || !(value is double) ? 0 : value;
  }

  bool getBoolean(String key) {
    Object value = items[key];
    return value == null || !(value is bool) ? false : value;
  }
}
