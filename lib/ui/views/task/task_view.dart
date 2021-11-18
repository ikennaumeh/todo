import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:playstore_todo/core/helpers/theme.dart';
import 'package:playstore_todo/core/model/task_model.dart';
import 'package:playstore_todo/ui/controllers/task_controller.dart';
import 'package:playstore_todo/ui/widgets/button.dart';
import 'package:playstore_todo/ui/widgets/input_field.dart';

class TaskView extends StatefulWidget {
  const TaskView({Key? key}) : super(key: key);

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final TaskController _taskController = Get.put(TaskController());
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String endTime = "9:15 PM";
  String startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int selectReminder = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];
  String selectRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];
  int selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          Icon(
            Icons.perm_identity_outlined,
            size: 20,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
          SizedBox(
            width: 20.w,
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Task',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
                AppInputField(
                  title: 'Title',
                  hint: 'Enter your title',
                  controller: titleController,
                ),
                AppInputField(
                  title: 'Note',
                  hint: 'Enter your note',
                  controller: noteController,
                ),
                AppInputField(
                  title: 'Date',
                  hint: DateFormat.yMd().format(selectedDate),
                  widget: IconButton(
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      _getDateFromUser();
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppInputField(
                        title: 'Start Time',
                        hint: startTime,
                        widget: IconButton(
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _getTimeFromUser(isStartTime: true);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Expanded(
                      child: AppInputField(
                        title: 'End Time',
                        hint: endTime,
                        widget: IconButton(
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _getTimeFromUser(isStartTime: false);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                AppInputField(
                  title: 'Remind',
                  hint: "$selectReminder minutes early",
                  widget: DropdownButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: const SizedBox(
                      height: 0,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectReminder = int.parse(newValue!);
                      });
                    },
                    items:
                        remindList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        child: Text(value.toString()),
                        value: value.toString(),
                      );
                    }).toList(),
                  ),
                ),
                AppInputField(
                  title: 'Repeat',
                  hint: selectRepeat,
                  widget: DropdownButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: const SizedBox(
                      height: 0,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectRepeat = newValue!;
                      });
                    },
                    items: repeatList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        value: value,
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 18.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _colorPallete(),
                    AppButton(
                      onTap: () => _validateData(),
                      title: 'Create Task',
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _validateData() {
    if (titleController.text.isNotEmpty && noteController.text.isNotEmpty) {
      //add to database
      _addTaskToDb();
      Get.back();
    } else if (titleController.text.isEmpty || noteController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required !",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          icon: const Icon(Icons.warning_amber_rounded),
          colorText: Colors.red);
    }
  }

  _addTaskToDb() async {
    int? value = await _taskController.addTask(
        task: Task(
      note: noteController.text,
      title: titleController.text,
      date: DateFormat.yMd().format(selectedDate),
      startTime: startTime,
      endTime: endTime,
      remind: selectReminder,
      repeat: selectRepeat,
      color: selectedColor,
      isCompleted: 0,
    ));

    print("My id is $value");
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
        firstDate: DateTime(2015),
        initialDate: DateTime.now(),
        context: context,
        lastDate: DateTime(2121));
    if (pickerDate != null) {
      setState(() {
        selectedDate = pickerDate;
      });
    }
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        SizedBox(
          height: 8.h,
        ),
        Wrap(
          children: List.generate(3, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = index;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: CircleAvatar(
                  radius: 14.r,
                  backgroundColor: index == 0
                      ? primaryColor
                      : index == 1
                          ? pink
                          : yellow,
                  child: selectedColor == index
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 20.sp,
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formattedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print('Time cancelled');
    } else if (isStartTime == true) {
      setState(() {
        startTime = _formattedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        endTime = _formattedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
      initialTime: TimeOfDay(
          hour: int.parse(startTime.split(":")[0]),
          minute: int.parse(startTime.split(":")[1].split("")[0])),
    );
  }
}
