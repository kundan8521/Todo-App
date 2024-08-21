import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../controllers/location_controller.dart';
import '../../../controllers/task_controller.dart';
import '../../../model/todo_task_model.dart';
import '../../utils/constant/colors.dart';
import '../../utils/widgets/internet_indicator.dart';

class ManageTaskScreen extends StatefulWidget {
  final TodoTaskModel? task;
  const ManageTaskScreen({super.key, this.task});

  @override
  _ManageTaskScreenState createState() => _ManageTaskScreenState();
}

class _ManageTaskScreenState extends State<ManageTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title.toString();
      descriptionController.text = widget.task!.description.toString();
      if (widget.task?.image != null) {
        _imageBytes = widget.task!.image!;
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, imageQuality: 50);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    } else {
      print("image null");
    }
  }


  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Choose Image Source",
              style: TextStyle(fontSize: 18),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: const Row(
                    children: [
                      Icon(Icons.photo_library),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          "Gallery",
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: tdBlack),
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  child: const Row(
                    children: [
                      Icon(Icons.camera_alt),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          "Camera",
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: tdBlack),
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addOrUpdateTask() async {
    final task = TodoTaskModel(
      id: widget.task?.id,
      title: titleController.text,
      description: descriptionController.text,
      image: _imageBytes,
      isCompleted: widget.task?.isCompleted ?? false,
    );

    try {
      final taskController = Provider.of<TaskController>(context, listen: false);
      if (widget.task == null) {
        taskController.addTodoTask(task);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.grey,
            content: Center(
              child: Text(
                'Tasks added successfully!',
                style: TextStyle(color: tdBGColor),
              ),
            ),
          ),
        );
      } else {
        int index=taskController.findTaskIndexById(widget.task!.id!);
        taskController.updateTask(task: task, index: index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.grey[600],
            content: const SizedBox(
              width: 100,
              child: Center(
                child: Text(
                  'Tasks updated successfully!',
                  style: TextStyle(color: tdBGColor),
                ),
              ),
            ),
          ),
        );
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? "Add Your Tasks" : "Update Your Tasks",
          style: const TextStyle(fontSize: 24, color: tdBlack),
        ),
        actions: [
          InternetIndicator()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Center(
                      child: _imageBytes == null
                          ? const Icon(
                        Icons.title,
                        color: Colors.white,
                        size: 50,
                      )
                          : ClipOval(
                        child: Image.memory(
                          _imageBytes!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: const TextStyle(color: tdBlack),
                  hintText: 'Enter your title',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: const TextStyle(color: tdBlack),
                  hintText: 'Enter your description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  filled: true,
                  prefixIcon: const Icon(Icons.description),
                  fillColor: Colors.grey[300],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: 5,
                minLines: 1,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Consumer<LocationController>(
                  builder: (BuildContext context, value, child) {
                    return ElevatedButton(
                      onPressed: value.isLoading
                          ? null
                          : () async {
                        if (_imageBytes == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.grey[300],
                              content: const Center(
                                child: Text(
                                  "Please choose your image",
                                  style: TextStyle(color: tdRed),
                                ),
                              ),
                            ),
                          );
                        } else if (titleController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.grey[300],
                              content: const Text("Please fill your title"),
                            ),
                          );
                        } else if (descriptionController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.grey[300],
                              content: const Text(
                                "Please fill your description",
                                style: TextStyle(color: tdRed),
                              ),
                            ),
                          );
                        } else {
                          await value.sendLocation(context);
                          _addOrUpdateTask();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: value.isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                        widget.task == null ? "Add Task" : "Update Task",
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
