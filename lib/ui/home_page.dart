import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_sqlite/controller/task_controller.dart';
import 'package:todo_sqlite/services/notification_services.dart';
import 'package:todo_sqlite/ui/add_task_page.dart';
import 'package:todo_sqlite/ui/theme.dart';
import 'package:todo_sqlite/ui/widgets/button.dart';
import 'package:todo_sqlite/ui/widgets/task_tile.dart';

import '../models/task_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyHelper;
  DateTime _seletedDate = DateTime.now();
  final _taskController = Get.put(TaskController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermission();
    notifyHelper.displayNotification(title: "Demo Title", body: "demo body");
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: Column(
        children: [_addTaskBar(), _addDateBar(), _showTasks()],
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Icon(Icons.sunny, color: Colors.black),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage("assets/images/zoro.jpg"),
        ),
        SizedBox(
          width: 15,
        )
      ],
    );
  }

  _addDateBar() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: whiteClr,
        height: 100,
        width: 80,
        onDateChange: (date) {
          _seletedDate = date;
          setState(() {});
        },
      ),
    );
  }

  _addTaskBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat.yMMMd().format(DateTime.now()),
                  style: subHeadingStyle),
              Text(
                "Today",
                style: headingStyle,
              )
            ],
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () async {
                await Get.to(() => AddTaskPage(),
                    transition: Transition.rightToLeft);
                _taskController.getTasks();
              })
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(child: Obx(() {
      return ListView.builder(
        itemCount: _taskController.taskList.length,
        itemBuilder: (context, index) {
          Task task = _taskController.taskList[index];
          print(task.toJson());
          if (task.repeat == 'Daily') {
            List<String> parts = task.startTime!.split(':');
            int hour = int.parse(parts[0]);
            int minute = int.parse(parts[1]);
            var dateParts = task.date!.split('/');
            DateTime date = DateTime(int.parse(dateParts[2]), int.parse(dateParts[0]), int.parse(dateParts[1]), hour, minute);
            // var myTime = DateFormat('hh:mm').format(date);
            // print(myTime);
           if(isFutureDate(date)){
             notifyHelper.scheduleNotification(hour, minute, task);
           }
            return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        )
                      ],
                    ),
                  ),
                ));
          } else if (task.date == DateFormat.yMd().format(_seletedDate)) {
            List<String> parts = task.startTime!.split(':');
            int hour = int.parse(parts[0]);
            int minute = int.parse(parts[1]);
            var dateParts = task.date!.split('/');
            DateTime date = DateTime(int.parse(dateParts[2]), int.parse(dateParts[0]), int.parse(dateParts[1]), hour, minute);
            // var myTime = DateFormat('hh:mm').format(date);
            // print(myTime);
            if(isFutureDate(date)){
              notifyHelper.scheduleNotification(hour, minute, task);
            }
            return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        )
                      ],
                    ),
                  ),
                ));
          } else {
            return Container();
          }
        },
      );
    }));
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.32,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.grey),
          ),
          Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  label: "Task Complete",
                  onTap: () {
                    _taskController.markTaskCompleted(task.id!);
                    Get.back();
                  },
                  color: primaryClr),
          const SizedBox(
            height: 8,
          ),
          _bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                print("deleteing");
                _taskController.delete(task);
                Get.back();
              },
              color: Colors.red.shade200),
          const SizedBox(
            height: 25,
          ),
          _bottomSheetButton(
              isClose: true,
              label: "Close",
              onTap: () {
                Get.back();
              },
              color: Colors.red.shade200),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    ));
  }

  _bottomSheetButton(
      {required String label,
      required Function()? onTap,
      required Color color,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: isClose ? Colors.white : color,
            border: Border.all(width: 2, color: isClose ? Colors.grey : color),
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22,
                color: isClose ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  bool isFutureDate(DateTime givenDate) {
    print(givenDate);
    DateTime now = DateTime.now();
    print(now);
    return givenDate.isAfter(now) || givenDate.isAtSameMomentAs(now);
  }
}
