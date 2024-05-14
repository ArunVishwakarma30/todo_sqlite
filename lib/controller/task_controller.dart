import 'package:get/get.dart';
import 'package:todo_sqlite/db/db_helper.dart';
import 'package:todo_sqlite/models/task_model.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var taskList = <Task>[].obs;

  // add the tasks in the table
  Future<int> addTask({Task? task}) async {
    return await DBHelper.insertTask(task);
  }

  // get all the tasks from the table
  void getTasks() async {
    List<Map<String, dynamic>>? tasks = await DBHelper.query();
    if (tasks != null && tasks.isNotEmpty) {
      taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    }
  }

  // delete tasks from table
  void delete(Task task) async {
    await DBHelper.delete(task);
    getTasks();

  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
