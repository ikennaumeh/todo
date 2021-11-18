import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:playstore_todo/core/helpers/theme.dart';
import 'package:playstore_todo/core/model/task_model.dart';
import 'package:playstore_todo/core/services/notification_service.dart';
import 'package:playstore_todo/core/services/theme_services.dart';
import 'package:get/get.dart';
import 'package:playstore_todo/ui/controllers/task_controller.dart';
import 'package:playstore_todo/ui/views/task/task_view.dart';
import 'package:playstore_todo/ui/widgets/button.dart';
import 'package:playstore_todo/ui/widgets/task_tile.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  NotificationService? notificationService;
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationService = NotificationService();
    notificationService!.initializeNotification();
    notificationService!.requestIOSPermissions();
    print('i am here');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: InkWell(
          onTap: () {
            ThemeService().switchTheme();
            notificationService!.displayNotification(
                title: "Theme Changed",
                body: Get.isDarkMode
                    ? "Activated Light Theme"
                    : "Activated Dark Theme");
            notificationService!.scheduledNotification();
          },
          child: Icon(
            Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
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
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: 10.h),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            print(_taskController.taskList.length);
            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showBottomSheet(
                              context, _taskController.taskList[index]);
                        },
                        child: TaskTile(task: _taskController.taskList[index]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  _showBottomSheet(context, Task task) {
    Get.bottomSheet(
      Container(
        color: Get.isDarkMode ? darkGreyColor : Colors.white,
        padding: EdgeInsets.only(top: 4.h),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * .24
            : MediaQuery.of(context).size.height * .32,
        child: Column(
          children: [
            Container(
              height: 6.h,
              width: 120.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            const Spacer(),
            task.isCompleted == 1
                ? const SizedBox.shrink()
                : _bottomSheetButton(
                    label: "Task Completed",
                    onTap: () {
                      Get.back();
                    },
                    color: primaryColor,
                    context: context),

            _bottomSheetButton(
                label: "Delete task",
                onTap: () {
                  Get.back();
                },
                color: Colors.red[300]!,
                context: context),
            SizedBox(height: 20.h),
            _bottomSheetButton(
                label: "Close",
                onTap: () {
                  Get.back();
                },
                isClose: true,
                color: Colors.red[300]!,
                context: context),
            SizedBox(height: 10.h)
          ],
        ),
      ),
    );
  }

  _bottomSheetButton(
      {required String label,
      required Function()? onTap,
      required Color color,
      bool isClose = false,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55.h,
        width: MediaQuery.of(context).size.width * .9,
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2.w,
            color: isClose == true ? Get.isDarkMode ? Colors.grey[600]! : Colors.grey[300]! : color,
          ),
          borderRadius: BorderRadius.circular(20.r),
          color: isClose == true ? Colors.transparent : color,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? GoogleFonts.lato(
              textStyle:  TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            )
                : GoogleFonts.lato(
              textStyle:  TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ).copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: EdgeInsets.only(top: 10.h, left: 10.w),
      child: DatePicker(
        DateTime.now(),
        height: 88.h,
        width: 70.w,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryColor,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          _selectedDate = date;
        },
      ),
    );
  }

  _addTaskBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
          AppButton(
            title: "+ Add Task",
            onTap: () async {
              await Get.to(() => const TaskView());
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }
}
