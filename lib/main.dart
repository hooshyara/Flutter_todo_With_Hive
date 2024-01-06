import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/data.dart';
import 'edit.dart';

const taskBoxName = 'tasks';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<Task>(taskBoxName);
  runApp(const MyApp());
}

const Color primaryColor = Color(0xff794cff);
final secondaryTextColor = Color(0xffAFBED0);
final normalPriority = Color(0xffF09816);
final lowPriority = Color(0xff3BE1F1);
final highPriority = primaryColor;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = Color(0xff1D2830);
    return MaterialApp(
      theme: ThemeData(

        textTheme: GoogleFonts.poppinsTextTheme(
            TextTheme(headline6: TextStyle(fontWeight: FontWeight.bold))),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: secondaryTextColor),
          iconColor: secondaryTextColor,
          border: InputBorder.none,
        ),
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          background: Color(0xffF3F5F8),
          onSurface: primaryTextColor,
          onBackground: primaryTextColor,
          secondary: primaryColor,
          onSecondary: Colors.white,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: primaryColor
        ),
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Task>(taskBoxName);
    final themData = Theme.of(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('To Do List'),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => EditTaskScreen(
                task: Task(),
              ),
            ),
          );
        },
        label: Text('Add a New Task'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                color: themData.colorScheme.primaryContainer,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'To Do List',
                          style: themData.textTheme.headline6!.apply(
                            color: themData.colorScheme.onPrimary,
                          ),
                        ),
                        Icon(
                          CupertinoIcons.share,
                          color: themData.colorScheme.onPrimary,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      height: 38,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19),
                          color: themData.colorScheme.onPrimary,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                            ),
                          ]),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(CupertinoIcons.search),
                          label: Text('Search tasks  ...'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<Box<Task>>(
                valueListenable: box.listenable(),
                builder: (context, value, child) {
                  if(box.isNotEmpty){
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      child: ListView.builder(
                        itemCount: box.values.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Today',
                                      style: themData.textTheme.headline6!
                                          .apply(fontSizeFactor: 0.9),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 3,
                                      width: 70,
                                      margin: const EdgeInsets.only(top: 4),
                                      decoration: BoxDecoration(
                                        color: themData.colorScheme.primary,
                                        borderRadius: BorderRadius.circular(1.5),
                                      ),
                                    ),
                                  ],
                                ),
                                MaterialButton(
                                  color: Color(0xffEAEFF5),
                                  textColor: secondaryTextColor,
                                  onPressed: () {
                                    box.clear();
                                  },
                                  elevation: 0,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Delete All',
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Icon(
                                        CupertinoIcons.delete_solid,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          } else {
                            final Task task = box.values.toList()[index - 1];
                            return TaskItem(task: task);
                          }
                        },
                      ),
                    );
                  }else{
                    return EmptyState();

                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class SnakBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column();
  }
  
}
class EmptyState extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Image.asset( 'assets/emptyState.jpg' ,),
        const SizedBox(
          height: 10,
        ),
        Text('your Task List is Empty !!!', style: Theme.of(context).textTheme.headline6,)
      ],
    );
  }
  
}
class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final priorityColor;
    switch (widget.task.priority) {
      case Priority.normal:
        priorityColor = normalPriority;
        break;
      case Priority.low:
        priorityColor = lowPriority;
        break;
      case Priority.high:
        priorityColor = highPriority;
        break;
    }
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditTaskScreen(
                task: widget.task,
              ),
            ),
          );
        });
      },
      onLongPress: () {
        widget.task.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task ${widget.task.name} is Deleted'), )
          
        );




      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 84,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: themeData.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(0.2),
                ),
              ]),
          child: Row(
            children: [
              MyCheckBox(value: widget.task.isCompleted, onTap: () {
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                });
              },),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  widget.task.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
              Container(
                width: 4,
                height: 90,
                decoration: BoxDecoration(
                    color: priorityColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final bool value;
  final GestureTapCallback onTap;
  const MyCheckBox({
    super.key,
    required this.value, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 2),
        child: Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border:
                !value ? Border.all(color: secondaryTextColor, width: 2) : null,
            color: value ? primaryColor : null,
          ),
          child: value
              ? Icon(
                  CupertinoIcons.check_mark,
                  color: Theme.of(context).colorScheme.surface,
                  size: 16,
                )
              : null,
        ),
      ),
    );
  }
}
