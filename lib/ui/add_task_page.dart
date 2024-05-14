import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';
import 'package:todo_sqlite/controller/task_controller.dart';
import 'package:todo_sqlite/models/task_model.dart';
import 'package:todo_sqlite/ui/theme.dart';
import 'package:todo_sqlite/ui/widgets/button.dart';
import 'package:todo_sqlite/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TaskController _taskController = Get.put(TaskController());
  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm").format(DateTime.now());
  String _endTime = DateFormat("hh:mm").format(DateTime.now());
  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];

  String _selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              MyInputField(
                  title: "Title",
                  hint: "Enter your title",
                  controller: _titleController),
              MyInputField(
                  title: "Note",
                  hint: "Enter your note",
                  controller: _noteController),
              MyInputField(
                  title: "Date",
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      _getDateFromUser(context);
                      print("object");
                    },
                  )),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                    title: "Start time",
                    hint: _startTime,
                    widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: const Icon(
                          Icons.access_time_outlined,
                          color: Colors.grey,
                        )),
                  )),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: MyInputField(
                    title: "End time",
                    hint: _endTime,
                    widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: const Icon(
                          Icons.access_time_outlined,
                          color: Colors.grey,
                        )),
                  )),
                ],
              ),
              MyInputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  underline: Container(
                    height: 0,
                  ),
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  style: titleStyle,
                  borderRadius: BorderRadius.circular(10),
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(
                        value.toString(),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                ),
              ),
              MyInputField(
                title: "Repeat",
                hint: "$_selectedRepeat",
                widget: DropdownButton(
                  underline: Container(
                    height: 0,
                  ),
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  style: titleStyle,
                  borderRadius: BorderRadius.circular(10),
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorPallate(),
                  MyButton(
                      label: "Create Task",
                      onTap: () {
                        _validateDate();
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Icon(Icons.arrow_back_ios, color: primaryClr),
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

  _getDateFromUser(BuildContext context) async {
    DateTime? _pickeDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (_pickeDate != null) {
      _selectedDate = _pickeDate;
      setState(() {});
    } else {
      print("User Closed the date picker and Null value returned.");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    if (pickedTime == null) {
      print("User Closed the time picker and Null value returned.");
    } else if (isStartTime) {
      String formatedTime = pickedTime.format(context);
      _startTime = formatedTime;
    } else {
      String formatedTime = pickedTime.format(context);
      _endTime = formatedTime;
    }
    setState(() {});
  }

  _showTimePicker() {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0])),
      initialEntryMode: TimePickerEntryMode.input,
    );
  }

  _colorPallate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        SizedBox(
          height: 6,
        ),
        Wrap(
            children: List<Widget>.generate(
          3,
          (int index) {
            return GestureDetector(
              onTap: () {
                _selectedColor = index;
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                  child: index == _selectedColor
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            );
          },
        )),
      ],
    );
  }

  _validateDate() {
    if (_titleController.text.toString().trim().isNotEmpty &&
        _noteController.text.toString().trim().isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.toString().trim().isEmpty ||
        _noteController.text.toString().trim().isEmpty) {
      Get.snackbar("Required", "All Fields are required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
          backgroundColor: Colors.grey,
          colorText: Colors.red,
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
  }

  _addTaskToDb() async {
    Task task = Task(
        note: _noteController.text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0);

    int value = await _taskController.addTask(task: task);
    print("Data inserted at ID : $value");
  }
}
