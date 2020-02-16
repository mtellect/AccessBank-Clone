import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'assets.dart';

class BaseModel {
  Map<String, Object> items = new Map();
  Map<String, Object> itemUpdate = new Map();
  Map<String, Map> itemUpdateList = new Map();

  BaseModel({Map items, DocumentSnapshot doc}) {
    if (items != null) {
      Map<String, Object> theItems = Map.from(items);
      this.items = theItems;
    }
    if (doc != null && doc.exists) {
      this.items = doc.data;
      this.items[DOCUMENT_ID] = doc.documentID;
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
    Object value = items[DOCUMENT_ID];
    return value == null || !(value is String) ? "" : value.toString();
  }

  List getList(String key) {
    Object value = items[key];
    return value == null || !(value is List) ? new List() : List.from(value);
  }

  List<Object> addToList(String key, Object value, bool add) {
    List<Object> list = items[key];
    list = list == null ? new List<Object>() : list;
    if (add) {
      if (!list.contains(value)) list.add(value);
    } else {
      list.remove(value);
    }
    put(key, list);
    return list;
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

  String getUserId() {
    Object value = items[USER_ID];

    return value == null || !(value is String) ? "" : value.toString();
  }

  String getImage() {
    Object value = items[IMAGE];

    return value == null || !(value is String) ? "" : value.toString();
  }

  String getString(String key) {
    Object value = items[key];

    return value == null || !(value is String) ? "" : value.toString();
  }

  String getEmail() {
    Object value = items[EMAIL];
    return value == null || !(value is String) ? "" : value.toString();
  }

  String getPassword() {
    Object value = items[PASSWORD];
    return value == null || !(value is String) ? "" : value.toString();
  }

  String getNotificationTitle() {
    Object value = items[NOTIFICATION_TITLE];
    return value == null || !(value is String) ? "" : value.toString();
  }

  String getNotificationSender() {
    Object value = items[NOTIFICATION_SENDER_NAME];
    return value == null || !(value is String) ? "" : value.toString();
  }

  bool isEmpty() {
    return items.isEmpty;
  }

  bool myItem() {
    return getUserId() == (userModel.getUserId());
  }

  int getInt(String key) {
    Object value = items[key];
    return value == null || !(value is int) ? 0 : (value);
  }

  int getType() {
    Object value = items[TYPE];
    return value == null || !(value is int) ? 0 : value;
  }

  double getDouble(String key) {
    Object value = items[key];
    return value == null || !(value is double) ? 0 : value;
  }

  int getTime() {
    Object value = items[TIME];
    return value == null || !(value is int) ? 0 : value;
  }

  bool getBoolean(String key) {
    Object value = items[key];
    return value == null || !(value is bool) ? false : value;
  }

  bool isAdminItem() {
    return getBoolean(IS_ADMIN);
  }

  bool isJohn() {
    return getEmail() == ("johnebere58@gmail.com");
  }

  bool isMaugost() {
    return getEmail() == ("ammaugost@gmail.com");
  }

  String getUId() {
    Object value = items[USER_ID];
    return value == null || !(value is String) ? "" : value.toString();
  }

  String getFullName() {
    Object value = items[FULL_NAME];
    return value == null || !(value is String) ? "" : value.toString();
  }

  String getCity() {
    Object value = items[CITY];
    return value == null || !(value is String) ? "" : value.toString();
  }

  String getToken() {
    Object value = items[TOKEN_ID];
    return value == null || !(value is String) ? "" : value.toString();
  }

  int getIsOnline() {
    Object value = items[IS_ONLINE];
    return value == null || !(value is int) ? 0 : (value);
  }

  bool getCanShowDate() {
    Object value = items[SHOW_DATE];
    return value == null || !(value is bool) ? false : value;
  }

  bool getIsVerified() {
    Object value = items[IS_VERIFIED];
    return value == null || !(value is bool) ? false : value;
  }

  bool getIsNetwork() {
    Object value = items[IS_NETWORK_IMAGE];
    return value == null || !(value is bool) ? false : value;
  }

  String getMessage() {
    Object value = items[MESSAGE];
    return value == null || !(value is String) ? "" : value.toString();
  }

  int getStatus() {
    Object value = items[NOTIFICATION_STATUS];
    return value == null || !(value is int) ? 0 : (value);
  }

  int getNotificationType() {
    Object value = items[NOTIFICATION_TYPE];
    return value == null || !(value is int) ? 0 : (value);
  }

  void updateItems({bool updateTime = true, int delaySeconds = 0}) async {
    String dName = items[DATABASE_NAME];
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map data = jsonDecode(pref.getString(dName) ?? "{}");

    for (String k in itemUpdate.keys) {
      data[k] = itemUpdate[k];
    }

    for (String k in itemUpdateList.keys) {
      Map update = itemUpdateList[k];
      bool add = update[ADD];
      var value = update[VALUE];

      List dataList = data[k] == null ? List() : List.from(data[k]);
      if (add) {
        if (!dataList.contains(value)) dataList.add(value);
      } else {
        dataList.removeWhere((E) => E == value);
      }
      data[k] = dataList;
    }
    pref.setString(dName, jsonEncode(data));
  }

  void deleteItem() async {
    String dName = items[DATABASE_NAME];
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(dName);
  }

  void saveItem(String name, bool addMyInfo, {document, onComplete}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(name, jsonEncode(items)).whenComplete(() {
      onComplete();
    });
  }
}
