import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:to_do_app/core/db/db_helper.dart';
import 'package:to_do_app/core/services/notification_services.dart';
import 'package:intl/intl.dart';

import '../../models/task.dart';

class TaskController extends GetxController {
  RxList<Task> listTask = <Task>[].obs;
  final dbHelper = DBHelper();

  final NotifyHelper notifyHelper = NotifyHelper();

  DateTime selectedDate = DateTime.now();

  String title = '', note = '';
  TextEditingController noteCN = TextEditingController();
  TextEditingController titleCN = TextEditingController();

  DateTime date = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(minutes: 30));

  late Task task;

  int selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  void changeColor(Color color) {
    pickerColor = color;
    update();
  }

  bool focus = false;

  // color picker config
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  @override
  onInit() {
    super.onInit();
    notifyHelper.requestPermission();
    notifyHelper.initialize();
  }

  Future<int?> addTask(Task task) {
    task = initTask();
    return dbHelper.insert(task);
  }

  initTask() {
    return Task(
      title: title,
      note: note,
      startDate: DateFormat.yMd().format(date),
      endDate: DateFormat('yyyy-MM-dd hh:mm a').format(endDate),
      color: pickerColor.value,
      isCompleted: 0,
      repeat: Task.fromRepeats(selectedRepeat),
      remind: selectedRemind,
    );
  }

  Future<void> getTask() async {
    List<Map<String, dynamic>> tasks = await dbHelper.query();
    listTask.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void delete(Task task) async {
    await dbHelper.delete(task);
    getTask();
  }

  void deleteAll() async {
    NotifyHelper().cancelAllNotificatin();
    await dbHelper.deleteAll();
    listTask.clear();
  }

  void updateState(Task task, isCompleted) async {
    await dbHelper.updateState(isCompleted, task.getId);
    getTask();
  }

  void updateData(Task task) async {
    dbHelper.update(task, task.getId);
    getTask();
  }
}
