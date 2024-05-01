import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TaskTile extends StatefulWidget {
  final int index;

  TaskTile({required this.index});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final task = taskProvider.tasks[widget.index];

    return GestureDetector(
      onTap: () {
        if (!task.isCompleted) {
          _controller.reset();
          _controller.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Container(
              child: ListTile(
                title: Text(
                  task.name,
                ),
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    taskProvider.toggleTask(widget.index);
                  },
                ),
              ),
            ),
            secondaryActions: [
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Task'),
                        content: Text('Are you sure you want to delete this task?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              taskProvider.deleteTask(widget.index);
                              Navigator.of(context).pop();
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
