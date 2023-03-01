import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import '../style/const_color.dart';

class NotificationScreen extends StatefulWidget {
  final Task task;
  final bool fromNotify;
  const NotificationScreen(
      {Key? key, required this.task, required this.fromNotify})
      : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            header(context),
            const SizedBox(height: 10),
            notecontent(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Column header(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.fromNotify
              ? 'Welcome back'
              : widget.task.getIsCompleted == 0
                  ? 'TODO'
                  : 'COMPLETED',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        widget.fromNotify
            ? Text(
                'you have a new reminder',
                style: Theme.of(context).textTheme.titleMedium,
              )
            : Container(),
      ],
    );
  }

  String configDate(date) {
    return DateFormat('d MMMM,yyyy  (hh:mm a)')
        .format(DateFormat('yyyy-MM-dd hh:mm a').parse(date));
  }

  Widget notecontent() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: widget.fromNotify ? bluishClr : Color(widget.task.getColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  widget.task.getTitle,
                  style: TextStyle(
                    fontSize: 22,
                    color: useWhiteForeground(widget.fromNotify ? bluishClr :Color(widget.task.getColor))
                        ? Colors.white.withOpacity(0.87)
                        : Colors.black.withOpacity(0.87),
                    wordSpacing: 3,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  configDate(widget.task.getEndDate),
                  style: TextStyle(
                    fontSize: 14,
                    color: useWhiteForeground(widget.fromNotify ? bluishClr :Color(widget.task.getColor))
                        ? Colors.white.withOpacity(0.87)
                        : Colors.black.withOpacity(0.87),
                    wordSpacing: 3,
                  ),
                ),
                const SizedBox(height: 15),
                Divider(
                  thickness: 1,
                  color: useWhiteForeground(widget.fromNotify ? bluishClr :Color(widget.task.getColor))
                      ? Colors.white.withOpacity(0.87)
                      : Colors.black.withOpacity(0.87),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    widget.task.getNote,
                    style: TextStyle(
                      fontSize: 20,
                      color: useWhiteForeground(widget.fromNotify ? bluishClr :Color(widget.task.getColor))
                          ? Colors.white.withOpacity(0.87)
                          : Colors.black.withOpacity(0.87),
                      wordSpacing: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
