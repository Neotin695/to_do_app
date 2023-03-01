// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:to_do_app/core/services/theme_services.dart';
import 'package:to_do_app/core/view%20model/task_controller.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/view/components/button.dart';
import 'package:to_do_app/view/components/task_tile.dart';
import 'package:to_do_app/view/pages/create_task_screen.dart';
import 'package:to_do_app/view/pages/notification_screen.dart';
import 'package:to_do_app/view/size_config.dart';
import 'package:to_do_app/view/style/const_color.dart';

class HomeScreen extends GetWidget<TaskController> {
  HomeScreen();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ThemeServices().switchThemeMode();
          },
          icon: Get.isDarkMode
              ? Icon(Icons.wb_sunny_outlined)
              : Icon(Icons.nightlight_outlined),
        ),
        actions: [
          IconButton(
            onPressed: () => controller.deleteAll(),
            icon: Icon(Icons.clear_all),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            headingHomePage(context),
            const SizedBox(height: 20),
            datePickerTImeLine(),
            showTasks(context),
          ],
        ),
      ),
    );
  }

  Widget headingHomePage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${DateFormat.yMMMd().format(DateTime.now())}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 7),
            Text(
              'Today',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        CustomButton(
          onTap: () async {
            await Get.to(() => CreateTaskScreen());

            controller.getTask();
          },
          label: 'Add Task',
          icon: Icons.add,
        ),
      ],
    );
  }

  Widget datePickerTImeLine() {
    return Container(
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        height: 100,
        width: 70,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        daysCount: 90,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 24,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
        onDateChange: (newDate) {
          controller.selectedDate = newDate;
        },
      ),
    );
  }

  Widget showTasks(BuildContext context) {
    return Expanded(
      child: Obx(
        () {
          if (controller.listTask.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () => controller.getTask(),
              child: ListView.builder(
                itemCount: controller.listTask.length,
                itemBuilder: (BuildContext context, int index) {
                  var task = controller.listTask[index];

                  if ((task.getRepeat == Repeat.Daily ||
                          task.getStartDate ==
                              DateFormat.yMd()
                                  .format(controller.selectedDate)) ||
                      (task.getRepeat == Repeat.Weekly &&
                          controller.selectedDate
                                      .difference(DateFormat.yMd()
                                          .parse(task.getStartDate))
                                      .inDays %
                                  7 ==
                              0) ||
                      (task.getRepeat == Repeat.Monthly &&
                          controller.selectedDate.day ==
                              DateFormat.yMd().parse(task.getStartDate).day)) {
                    return listOfNote(task, context, index);
                  } else {
                    return Container();
                  }
                },
              ),
            );
          } else {
            return notData(context);
          }
        },
      ),
    );
  }

  Widget notData(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/not_found.svg',
          height: 150,
        ),
        const SizedBox(height: 20),
        Text(
          "you don't have notes yet!",
          style: Theme.of(context).textTheme.titleLarge,
        )
      ],
    );
  }

  Widget listOfNote(Task task, BuildContext context, int index) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 300),
      child: SlideAnimation(
        horizontalOffset: 100,
        child: FadeInAnimation(
          duration: Duration(milliseconds: 200),
          child: TaskTile(
            task: task,
            onTap: () {
              showBottomsSheet(context, index);
            },
            onTapParent: () {
              Get.to(
                () => NotificationScreen(
                  task: task,
                  fromNotify: false,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<dynamic> showBottomsSheet(BuildContext context, int index) {
    Task task = controller.listTask[index];
    return showModalBottomSheet(
      constraints: BoxConstraints(maxWidth: 400),
      isScrollControlled: true,
      context: context,
      backgroundColor: Color(task.getColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            button(
                label: 'Make a complete',
                onTap: () {
                  controller.notifyHelper.cancelNotificatin(task);
                  controller.updateState(task, 1);
                  Get.back();
                },
                color: useWhiteForeground(Color(task.getColor))
                    ? Colors.white.withOpacity(0.87)
                    : Colors.black.withOpacity(0.87),
                size: 20,
                weight: FontWeight.bold),
            Divider(
              thickness: 2,
            ),
            button(
              label: 'Edit Note',
              onTap: () async {
                await Get.to(() => CreateTaskScreen(), arguments: task);
              },
              size: 20,
              color: useWhiteForeground(Color(task.getColor))
                  ? Colors.white.withOpacity(0.87)
                  : Colors.black.withOpacity(0.87),
            ),
            Divider(
              thickness: 2,
            ),
            button(
              label: 'Delete Note',
              onTap: () {
                controller.notifyHelper.cancelNotificatin(task);
                controller.delete(controller.listTask[index]);
                Get.back();
              },
              size: 18,
              color: useWhiteForeground(Color(task.getColor))
                  ? Colors.white.withOpacity(0.87)
                  : Colors.black.withOpacity(0.87),
            ),
          ],
        );
      },
    );
  }

  Widget button(
      {String? label,
      VoidCallback? onTap,
      Color? color,
      double? size,
      FontWeight? weight}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: Text(
          label ?? 'button',
          style: TextStyle(
            fontSize: size,
            fontWeight: weight,
            color: color,
          ),
        ),
      ),
    );
  }
}
