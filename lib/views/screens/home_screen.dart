import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_zip/views/screens/tasks/manage_task_screen.dart';
import '../../controllers/task_controller.dart';
import '../utils/constant/colors.dart';
import '../utils/widgets/internet_indicator.dart';
import '../utils/widgets/task_widget.dart';

class HomeScreen extends StatelessWidget {
 const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ManageTaskScreen()),
          );
        },
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "ToDo All Lists",
          style: TextStyle(color: tdBlack),
        ),
        actions:  [
        InternetIndicator()
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Consumer<TaskController>(
            builder: (context, taskController, child) {
              if (taskController.todoListData.isEmpty) {
                return const Center(child: Text('No tasks found'));
              } else {
                var data = taskController.todoListData;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final task = data[index];
                    return TaskItemWidget(task: task, onCompletedTap: (bool? value) {
                      taskController.updateTaskCheckBox(value:value,index:index);
                    },);
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}



