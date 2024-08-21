import 'dart:convert';
import 'dart:typed_data';

class TodoTaskModel{
   int? id;
   String? title;
   String? description;
   Uint8List? image;
  bool isCompleted;
  TodoTaskModel({
    this.id,
    this.title,
    this.description,
    this.image,
    this.isCompleted=false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'title': title,
      'description': description,
      'image':base64Encode(image ?? []),
      'isCompleted':isCompleted ? 1:0
    };
  }
  static TodoTaskModel fromMap(Map<String, dynamic> map) {
    return TodoTaskModel(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        image: map['image'] == null ? null : base64Decode(map['image']),
        isCompleted: map['isCompleted'] == 1 ? true : false
    );
  }

}
