import 'package:flutter/material.dart';
import 'package:frontend/models/item.dart';
import 'package:frontend/services/api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Item>>? _items;
  @override
  void initState() {
    _updateItemList();
    super.initState();
  }

  _updateItemList() {
    setState(() {
      _items = Api().getItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("home Screen"),
      ),
      body: FutureBuilder<List<Item>>(
        future: _items,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _showFormDialog(snapshot.data![index]);
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            _deleteItem(snapshot.data![index].objectId);
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(null);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _showFormDialog(Item? item) {
    final _nameController = TextEditingController(text: item?.name ?? "");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item == null ? "Add Item" : "Update Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(hintText: "Enter Name"),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text;
                if (name.isNotEmpty) {
                  if (item == null) {
                    await Api().addItem(name);
                    _updateItemList();
                  } else {
                    await Api().updateItem(item.objectId, name);
                    _updateItemList();
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(item == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }

  _deleteItem(String id) async {
    await Api().deleteItem(id);
    _updateItemList();
  }
}
