import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String id;
  String content;
  bool completed;
  bool isDeleted;
  TodoModel({this.id, this.content, this.completed, this.isDeleted});
  factory TodoModel.fromJson(DocumentSnapshot json) => TodoModel(
      id: json.id,
      content: json.data()['content'] ?? "",
      completed: json.data()['completed'] ?? "",
      isDeleted: json.data()['isDeleted'] ?? "");

  Map<String, dynamic> toJson() =>
      {'content': content, 'completed': completed, 'isDeleted': isDeleted};
}
