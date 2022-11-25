import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layered_architecture/core/app_extension.dart';

import '../../../../common/controller/api_operation.dart';
import '../../../../common/widget/date_time_picker.dart';
import '../../../../common/widget/drop_down.dart';
import '../../../../common/widget/empty_widget.dart';
import '../../../../common/widget/popup_menu.dart';
import '../../../../common/widget/spinkit_indicator.dart';
import '../../../../common/widget/text_input.dart';
import '../../../../common/dialog/retry_dialog.dart';
import '../../../../common/dialog/progress_dialog.dart';
import '../../../user/data/model/user.dart';
import '../../controller/todo_controller.dart';
import '../../data/model/todo.dart';
import '../widget/todo_list_item.dart';

enum Mode { create, update }

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  final ToDoController _controller = Get.put(ToDoController());

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      centerTitle: true,
      title: const Text("Todos"),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          const Text(
            "Todo",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.archive_outlined, color: Color(0xFFF4511E)),
          Obx(
            () => Text(
              _controller.todosCount.string,
              style: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold),
            ).paddingAll(20),
          ),
          const Spacer(),
          PopupMenu<Status>(
            items: Status.values,
            onChanged: (Status status) {
              _controller.getTodos(widget.user.id!, status: status);
            },
          )
        ],
      ),
    );
  }

  Widget createTodo() {
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFF4511E)),
          borderRadius: BorderRadius.circular(5),
        ),
        onTap: () {
          todoBottomSheet(
            context,
            currentDateTime: DateTime.now(),
            taskTitle: '',
          );
        },
        leading: const Icon(Icons.add, color: Color(0xFFF4511E)),
        title: const Text(
          "Add task",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  createOrUpdateTodo(ToDo todo, Mode mode) {
    if (mode == Mode.create) {
      _controller.createTodo(todo);
    } else {
      _controller.updateTodo(todo);
    }
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (_) {
        return Obx(
          () {
            switch (_controller.apiStatus.value) {
              case ApiState.loading:
                return ProgressDialog(
                  title: "${mode.name}ing task...",
                  isProgressed: true,
                );
              case ApiState.success:
                return ProgressDialog(
                  title: "Successfully ${mode.name}ed",
                  onPressed: () {
                    _controller.getTodos(widget.user.id!);
                    Navigator.pop(context);
                  },
                  isProgressed: false,
                );
              case ApiState.failure:
                return RetryDialog(
                  title: _controller.errorMessage.value,
                  onRetryPressed: () {
                    if (mode == Mode.create) {
                      _controller.createTodo(todo);
                    } else {
                      _controller.updateTodo(todo);
                    }
                  },
                );
            }
          },
        );
      },
    );
  }

  void todoBottomSheet(BuildContext context,
      {Mode mode = Mode.create,
      //required for edit mode
      int? todoId,
      Status todoStatus = Status.pending,
      required DateTime currentDateTime,
      String? taskTitle}) {
    final formKey = GlobalKey<FormState>();
    String title = taskTitle ?? "";
    DateTime dateTime = currentDateTime;
    Status status = todoStatus;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (_) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextInput(
                  initialValue: title,
                  hint: "Enter title",
                  onChanged: (String value) {
                    title = value;
                  },
                  validator: (String? input) {
                    if (input!.length > 3) return null;
                    return "Title must be at least 4 characters";
                  },
                ),
                const SizedBox(height: 15),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return DropDown<Status>(
                      initialItem: todoStatus,
                      items: const [Status.pending, Status.completed],
                      onChanged: (Status value) {
                        setState(() {
                          status = value;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 15),
                DateTimePicker(
                  dateTime: mode == Mode.update ? currentDateTime : null,
                  selectedDateTime: (DateTime date) {
                    dateTime = date;
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool isValid = formKey.currentState?.validate() ?? false;
                      if (isValid) {
                        ToDo todo = ToDo(
                          id: todoId,
                          userId: widget.user.id!,
                          title: title,
                          dueOn: dateTime,
                          status: status,
                        );
                        createOrUpdateTodo(todo, mode);
                      }
                    },
                    child: Text(mode.name.toCapital),
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 30, vertical: 30),
          ),
        );
      },
    );
  }

  Widget taskList(List<ToDo> todos) {
    return TodoListItem(
      items: todos,
      onDeletePressed: (ToDo todo) {
        _controller.deleteTodo(todo);
        showDialog(
          context: context,
          builder: (_) {
            return Obx(
              () {
                switch (_controller.apiStatus.value) {
                  case ApiState.loading:
                    return const ProgressDialog(
                      title: "Deleting task...",
                      isProgressed: true,
                    );
                  case ApiState.success:
                    return ProgressDialog(
                      title: "Successfully deleted",
                      onPressed: () {
                        _controller.getTodos(widget.user.id!);
                        Navigator.pop(context);
                      },
                      isProgressed: false,
                    );
                  case ApiState.failure:
                    return RetryDialog(
                      title: _controller.errorMessage.value,
                      onRetryPressed: () => _controller.deleteTodo(todo),
                    );
                }
              },
            );
          },
        );
      },
      onEditPressed: (ToDo todo) {
        todoBottomSheet(
          context,
          todoId: todo.id,
          mode: Mode.update,
          taskTitle: todo.title,
          todoStatus: todo.status,
          currentDateTime: todo.dueOn,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _controller.getTodos(widget.user.id!);
    return Scaffold(
      appBar: _appBar(context),
      body: SafeArea(
        child: ListView(
          children: [
            header(),
            createTodo(),
            _controller.obx(
              (state) => taskList(state!),
              onLoading: const SpinKitIndicator(),
              onError: (error) => RetryDialog(
                title: "$error",
                onRetryPressed: () => _controller.getTodos(widget.user.id!),
              ),
              onEmpty: const EmptyWidget(message: "No Todos"),
            ),
          ],
        ).paddingAll(15.0),
      ),
    );
  }
}
