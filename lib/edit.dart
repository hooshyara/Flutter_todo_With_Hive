import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/main.dart';
import 'data.dart';
import 'main.dart';

const taskBoxName = 'tasks';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        title: Text(
          'Edit Task',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final task = Task();
          task.name = _controller.text;
          task.priority = widget.task.priority;
          if (task.isInBox) {
            task.save();
          } else {
            final Box<Task> box = Hive.box(taskBoxName);
            box.add(task);
          }
          Navigator.of(context).pop();
        },
        label: Row(
          children: [
            Text(
              'Save Change',
            ),
            const SizedBox(
              width: 5,
            ),
            Icon(
              CupertinoIcons.check_mark,
              size: 18,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                    onTap: () {
                      setState(() {
                        widget.task.priority = Priority.high;
                      });
                    },
                    label: 'High',
                    color: primaryColor,
                    isSelected: widget.task.priority == Priority.high,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                      onTap: () {
                        setState(() {
                          widget.task.priority = Priority.normal;
                        });
                      },
                      label: 'Normal',
                      color: Color(0xffF09816),
                      isSelected: widget.task.priority == Priority.normal),
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                      onTap: () {
                        setState(() {
                          widget.task.priority = Priority.low;
                        });
                      },
                      label: 'Low',
                      color: Color(0xff3BE1F1),
                      isSelected: widget.task.priority == Priority.low),
                ),
              ],
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                label: Text(
                  "Add a Task for today ...",
                  style: themeData.textTheme.bodyText1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;

  const PriorityCheckBox({
    super.key,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(width: 1),
          color: secondaryTextColor.withOpacity(0.01),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(label),
            ),
            Positioned(
              bottom: 11,
              top: 11,
              right: 0,
              child: _PriorityCheckBoxShape(value: isSelected, color: color),
            )
          ],
        ),
      ),
    );
  }
}

class _PriorityCheckBoxShape extends StatelessWidget {
  final bool value;
  final Color color;

  const _PriorityCheckBoxShape({
    super.key,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 2),
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: value
            ? Icon(
          CupertinoIcons.check_mark,
          color: Theme.of(context).colorScheme.surface,
          size: 12,
        )
            : null,
      ),
    );
  }
}