import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback? onTapParent;
  final VoidCallback? onTap;
  const TaskTile({
    Key? key,
    required this.task,
    this.onTapParent,
    this.onTap,
  }) : super(key: key);

  String configDate(date) {
    return DateFormat('d MMMM,yyyy  (hh:mm a)')
        .format(DateFormat('yyyy-MM-dd hh:mm a').parse(date));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapParent, 
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 30,
        ),
        height: 350,
        decoration: BoxDecoration(
          color: Color(task.getColor),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            leftSideOfTaskTile(),
            VerticalDivider(
              thickness: 1,
              color: useWhiteForeground(Color(task.getColor))
                  ? Colors.white.withOpacity(0.60)
                  : Colors.black.withOpacity(0.60),
            ),
            Center(child: rightSideOfTaskTile())
          ],
        ),
      ),
    );
  }

  Widget leftSideOfTaskTile() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.getTitle,
                style: TextStyle(
                  fontSize: 24,
                  color: useWhiteForeground(
                    Color(task.getColor),
                  )
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${configDate(task.getEndDate)} \nremider ${task.getRemind} minutes ago',
                style: TextStyle(
                  fontSize: 16,
                  color: useWhiteForeground(
                    Color(task.getColor),
                  )
                      ? Colors.white.withOpacity(0.60)
                      : Colors.black.withOpacity(0.60),
                ),
              ),
              Divider(
                thickness: 1,
                color: useWhiteForeground(Color(task.getColor))
                    ? Colors.white.withOpacity(0.60)
                    : Colors.black.withOpacity(0.60),
              ),
              Text(
                task.getNote,
                style: TextStyle(
                  fontSize: 18,
                  color: useWhiteForeground(
                    Color(task.getColor),
                  )
                      ? Colors.white.withOpacity(0.87)
                      : Colors.black.withOpacity(0.87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rightSideOfTaskTile() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: double.infinity,
        alignment: Alignment.center,
        color: Color(task.getColor),
        child: RotatedBox(
          quarterTurns: 3,
          child: Text(
            task.getIsCompleted == 0 ? 'TODO' : 'COMPLETED',
            style: TextStyle(
              fontSize: 18,
              color: useWhiteForeground(Color(task.getColor))
                  ? Colors.white.withOpacity(0.87)
                  : Colors.black.withOpacity(0.87),
            ),
          ),
        ),
      ),
    );
  }
}
