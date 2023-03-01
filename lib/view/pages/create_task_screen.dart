// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:core';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:to_do_app/core/services/notification_services.dart';
import 'package:to_do_app/core/view%20model/task_controller.dart';
import 'package:to_do_app/view/components/button.dart';

import '../components/input_field.dart';

class CreateTaskScreen extends GetWidget<TaskController> {
  final GlobalKey<FormState> _globalKey = GlobalKey();
  CreateTaskScreen();

  final task = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // this widget contain textTitle and icon svg
              header(context),
              // this widget contain textFormField title and note
              titleNnote(),
              // this widget contain date and dateTime
              dateNtme(context),
              // this widget contain remind and repeat
              remindNrepeat(),
              // this widget contain color picker block
              colorPickerTodo(context),
              const SizedBox(height: 20),
              // button to create task
              Center(
                child: CustomButton(
                  onTap: () => validateData(context),
                  label: 'Create Task',
                  icon: Icons.create,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Center header(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Add Task',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          SvgPicture.asset(
            'assets/images/add_note.svg',
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget titleNnote() {
    return Column(
      children: [
        InputField(
            controller: controller.titleCN,
            label: 'Title',
            icon: Icons.title,
            fun: (value) {
              controller.title = value!;
            }),
        InputField(
            controller: controller.noteCN,
            label: 'Note',
            icon: Icons.note,
            fun: (value) {
              controller.note = value!;
            }),
      ],
    );
  }

  Widget dateNtme(ctx) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20, //SizeConfig.screenWidth * 0.03,
        vertical: 20,
      ),
      child: Column(
        children: [
          showDateNTime((value) {
            controller.date = DateTime.parse(value);
          }, 'Start', controller.date, DateTimePickerType.date, 'yyyy-MM-dd'),
          const SizedBox(
            height: 20,
          ),
          showDateNTime((value) {
            controller.endDate = DateTime.parse(value);
          }, 'End', controller.endDate, DateTimePickerType.dateTime,
              'd MMM,yyyy -- hh:mm a'),
        ],
      ),
    );
  }

  Widget showDateNTime(fun, label, initDate, type, pattern) {
    return DateTimePicker(
      decoration: InputDecoration(
        labelText: '$label DateTime',
        icon: Icon(Icons.event),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      autofocus: controller.focus,
      type: type,
      dateMask: pattern,
      initialValue: initDate.toString(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      onChanged: fun,
      validator: (val) {
        print(val);
        return null;
      },
      onSaved: (val) => print(val),
    );
  }

  Widget remindNrepeat() {
    return Column(
      children: [
        Field(
          enabled: true,
          hint: '${controller.selectedRemind} minutes early',
          widget: DropdownButton(
            hint: Text('Remind'),
            items: controller.remindList
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      '$e minutes',
                    ),
                  ),
                )
                .toList(),
            icon: Icon(Icons.keyboard_arrow_down),
            onChanged: (int? value) {
              controller.selectedRemind = value!;
            },
          ),
        ),
        Field(
          enabled: true,
          hint: '${controller.selectedRepeat}',
          widget: DropdownButton(
            hint: Text('Repeat'),
            items: controller.repeatList
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      '$e',
                    ),
                  ),
                )
                .toList(),
            icon: Icon(Icons.keyboard_arrow_down),
            onChanged: (String? value) {
              controller.selectedRepeat = value!;
            },
          ),
        ),
      ],
    );
  }

  Widget colorPickerTodo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            'Color',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          InkWell(
            child: CircleAvatar(backgroundColor: controller.pickerColor),
            onTap: () {
              showDialog(
                builder: (context) => AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: BlockPicker(
                      pickerColor: controller.currentColor,
                      onColorChanged: controller.changeColor,
                    ),
                  ),
                ),
                context: context,
              );
            },
          ),
        ],
      ),
    );
  }

  validateData(context) {
    if (!_globalKey.currentState!.validate()) {
      return;
    }
    _globalKey.currentState!.save();
    if (controller.endDate
        .subtract(Duration(minutes: controller.selectedRemind))
        .isBefore(DateTime.now())) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'you selected invalid end date',
        descTextStyle: TextStyle(color: Colors.black),
        btnCancelText: 'cancel',
        btnCancelOnPress: () {
          controller.focus = true;
        },
      ).show();
      return;
    }
    _createTask().then(
      (value) {
        print(value);
        if (value != null && value > -1) {
          _buildAwesomeDialog(context, value).show();
        } else
          print('null');
      },
    );
  }

  AwesomeDialog _buildAwesomeDialog(context, int value) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Success',
      desc: 'Your task is beging',
      descTextStyle: TextStyle(color: Colors.black),
      btnCancelText: 'add more',
      btnOkText: 'main Menu',
      btnCancelOnPress: () {
        controller.titleCN.clear();
        controller.noteCN.clear();
        controller.task.setId = value;
        NotifyHelper().showScheduleNotification(controller.task);
      },
      btnOkOnPress: () {
        controller.task.setId = value;
        NotifyHelper().showScheduleNotification(controller.task);
        Navigator.pop(context);
      },
    );
  }

  Future<int?> _createTask() async {
    return await controller.addTask();
  }
}
