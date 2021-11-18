import 'package:get/get.dart';
import 'package:playstore_todo/core/model/task_model.dart';
import 'package:playstore_todo/core/services/db_helper.dart';

class TaskController extends GetxController{

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getTasks();
  }

  var taskList = <Task>[].obs;

  Future<int>? addTask({Task? task}) async{
    return await DBHelper.insert(task);
  }

  void getTasks() async {
    print('Query method called');
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void delete(Task task){
    DBHelper.delete(task);

  }

}