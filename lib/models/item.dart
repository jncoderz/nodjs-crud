class Item {
  final String objectId;
  final String name;

  Item({required this.objectId, required this.name});

  Map<String, dynamic> toJson() {
    return {"_id": objectId, "name": name};
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(objectId: json["_id"], name: json["name"]);
  }
}
