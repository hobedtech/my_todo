import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_todo/model/TodoModel.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
CollectionReference _todoCollectionRef = _firestore.collection('todos');

class TodoService {
  Stream<List<TodoModel>> getAll() {
    return _todoCollectionRef
        .where("isDeleted", isEqualTo: false)
        .snapshots(includeMetadataChanges: true)
        .map((QuerySnapshot _querySnapshot) => _querySnapshot.docs
            .map((DocumentSnapshot _documentSnap) =>
                TodoModel.fromJson(_documentSnap))
            .toList());
  }

  Stream<List<TodoModel>> getAllDeleted() {
    return _todoCollectionRef
        .where("isDeleted", isEqualTo: true)
        .snapshots(includeMetadataChanges: true)
        .map((QuerySnapshot _querySnapshot) => _querySnapshot.docs
            .map((DocumentSnapshot _documentSnap) =>
                TodoModel.fromJson(_documentSnap))
            .toList());
  }

  Future<void> putDocument(TodoModel todoModel) {
    return _todoCollectionRef.doc(todoModel.id).update(todoModel.toJson());
  }

  Future<void> postDocument(TodoModel todoModel) {
    return _todoCollectionRef.doc().set(todoModel.toJson());
  }

  Future<void> deleteDocument(TodoModel todoModel) {
    todoModel.isDeleted = true;
    return _todoCollectionRef.doc(todoModel.id).update(todoModel.toJson());
  }
}
