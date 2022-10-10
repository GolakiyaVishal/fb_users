import 'dart:convert';

import 'package:fb_users/data/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// [UserRepository]
/// A data access object to communicate with firebase realtime database

class UserRepository {
  UserRepository() {
    _reference = FirebaseDatabase.instance.ref('fb_users');
  }

  static const String dbUrl =
      'https://fb-users-baa92-default-rtdb.firebaseio.com/fb_users';

  late DatabaseReference _reference;

  // add new item in database
  Future<String> addNewItem(User item) async {
    final response = await http.post(
      Uri.parse('$dbUrl.json'),
      body: jsonEncode(item.toJson()),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final id = json['name']! as String;
    return id;
  }

  // db reference to show all users
  Query getAllItems() {
    return _reference;
  }

  // get list of all items auto generated ids
  // return two list of ids and list of item objects
  Future<List<dynamic>?> getUsersId() async {
    final resp = await http.get(Uri.parse('$dbUrl.json'));

    final body = jsonDecode(resp.body);
    if (body != null) {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;

      final idList = <String>[];
      final itemList = <User>[];

      json.forEach((key, value) {
        idList.add(key);
        itemList.add(User.fromJson(value as Map<String, dynamic>));
      });
      return [idList, itemList];
    }
    return null;
  }

  // update item property in fdb
  Future<String> updateItem(User item, String itemId) async {
    final response = await http.patch(
      Uri.parse('$dbUrl/$itemId.json'),
      body: jsonEncode(item.toJson()),
    );

    debugPrint('updateItem:: ${response.body}');
    return response.body;
  }

  // delete item from firebase database
  Future<String> deleteItem(String itemId) async {
    print('delete :: $itemId');
    final response =
        await http.delete(Uri.parse('$dbUrl/$itemId.json'));
    return response.body;
  }

  // get Map of each item and auto generated key of realtime database
  Future<Map<String, User>?> getUserList() async {
    final resp = await http.get(Uri.parse(dbUrl));

    final json = jsonDecode(resp.body) as Map<String, dynamic>;

    final returnable = json.map(
      (key, value) =>
          MapEntry(key, User.fromJson(value as Map<String, dynamic>)),
    );

    return returnable;
  }
}
