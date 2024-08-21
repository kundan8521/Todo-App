
import 'package:flutter/material.dart';


import '../db/database_helper.dart';
import '../model/todo_task_model.dart';

class TaskController  extends ChangeNotifier{
  TaskController(){
    getTodolist();
  }
  List<TodoTaskModel> todoListData = <TodoTaskModel> [];

  void addTodoTask(TodoTaskModel task){
    DatabaseHelper.insertData(task).then((value) {
      getTodolist();
    },);

  }

 void getTodolist()async{
   DatabaseHelper.fetchData().then((value) {
     todoListData.clear();
     todoListData.addAll(value);
     notifyListeners();
   },);
 }

 void deleteTask({required int taskId})async {
   DatabaseHelper.deleteTasks(taskId).then((value) {
     getTodolist();
   },);
 }
  void updateTaskCheckBox({required bool? value,required int index}) {
   todoListData.elementAtOrNull(index)?.isCompleted = value ?? false;
    notifyListeners();
  }
  void updateTask({required TodoTaskModel task, required int index}) async {
    DatabaseHelper.update(task).then((value) {
      todoListData[index] = task;
      notifyListeners();
    });
  }

  int findTaskIndexById(int id) {
    return todoListData.indexWhere((task) => task.id == id);
  }
 updateTaskCheckBoc(int index, bool isCompleted ){
   var todo = todoListData[index];
   todoListData[index] = TodoTaskModel(
     id: todo.id,
     image: todo.image,
     isCompleted: isCompleted ?? false,
     description: todo.description,
     title: todo.title,
   );
   notifyListeners();
 }


}


