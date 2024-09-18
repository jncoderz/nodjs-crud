import 'dart:convert';

import 'package:frontend/constant.dart';
import 'package:frontend/models/item.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<List<Item>> getItem() async {
    List<Item> itemList = [];
    final response = await http.get(Uri.parse("$url/api/v1/items"));
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      for (final json in responseBody) {
        itemList.add(Item.fromJson(json));
      }
      return itemList;
    } else {
      throw Exception("Item not found");
    }
  }

  Future<Item> addItem(String name) async {
    final response = await http.post(
      Uri.parse("$url/api/v1/items"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name}),
    );
    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      return Item.fromJson(responseBody);
    } else {
      throw Exception("Item not added");
    }
  }

  Future<void> updateItem(String id, String name) async {
    final response = await http.put(
      Uri.parse("$url/api/v1/items/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name}),
    );
    if (response.statusCode != 200) {
      throw Exception("item not updated");
    }
  }

  Future<void> deleteItem(String id) async {
    final response = await http.delete(Uri.parse("$url/api/v1/items/$id"));
    if (response.statusCode != 200) {
      throw Exception("item not deleted");
    }
  }
}
