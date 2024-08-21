import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../../controllers/location_controller.dart';
import '../../../controllers/task_controller.dart';
import '../../../model/todo_task_model.dart';
import '../../screens/tasks/manage_task_screen.dart';
import '../constant/colors.dart';

class TaskItemWidget extends StatelessWidget {
  final TodoTaskModel task;
  final Function(bool? value) onCompletedTap;
  const TaskItemWidget({
    super.key,
    required this.task, required this.onCompletedTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: PhysicalModel(
        color: tdBGColor,
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 280,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                    ),
                    child: task.image != null
                        ? Image.memory(
                      task.image!,
                      fit: BoxFit.cover,
                    )
                        : const Icon(Icons.person, size: 100),
                  ),
                ),
                Positioned(
                  right: 5,
                  top: 10,
                  child: PopupMenuButton<int>(
                    iconSize: 30,
                    iconColor: Colors.white,
                    color: Colors.white,
                    onSelected: (item) => _onSelected(context, item, task),
                    itemBuilder: (context) => [
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.blueAccent),
                            SizedBox(width: 10),
                            Text("Edit", style: TextStyle(color: Colors.blueAccent)),
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        onTap: () {
                          _deleteDialog(context, task);
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.delete, color: tdRed),
                            SizedBox(width: 10),
                            Text("Delete", style: TextStyle(color: tdRed)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 1, thickness: 1),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Title: ${task.title}", style: const TextStyle(fontSize: 16)),
                  Text("Description: ${task.description}", style: const TextStyle(fontSize: 16)),
                  Consumer<LocationController>(
                    builder: (context, locationController, child) {
                      return Text("Address: ${locationController.locationName}", style: const TextStyle(fontSize: 16));
                    },
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      task.isCompleted ? "Completed" : "Uncompleted",
                      style: TextStyle(color: task.isCompleted ? Colors.green : Colors.red),
                    ),
                    value: task.isCompleted,
                    visualDensity: VisualDensity.comfortable,
                    checkColor: Colors.white,
                    activeColor: Colors.green,
                    secondary: Icon(
                      task.isCompleted ? Icons.check_circle : Icons.error,
                      color: task.isCompleted ? Colors.green : tdRed,
                    ),
                    onChanged: onCompletedTap,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSelected(BuildContext context, int item, TodoTaskModel task) {
    switch (item) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ManageTaskScreen(task: task)),
        );
        break;
      case 1:
        _deleteDialog(context, task);
        break;
    }
  }

  void _deleteDialog(BuildContext context, TodoTaskModel task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            "Are you sure you want to delete this task?",
            textAlign: TextAlign.center,
          ),
          title: const Center(
            child: Text(
              "Confirm Deletion!",
              style: TextStyle(fontSize: 18),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: tdBlack, fontSize: 15),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text(
                    "OK",
                    style: TextStyle(color: tdBlack, fontSize: 15),
                  ),
                  onPressed: () {
                    Provider.of<TaskController>(context, listen: false)
                        .deleteTask(taskId: task.id ?? 0);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

