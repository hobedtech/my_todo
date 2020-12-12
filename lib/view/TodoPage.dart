import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/provider/BottomNavBarProvider.dart';
import 'package:my_todo/provider/PageProvider.dart';
import 'package:my_todo/model/TodoModel.dart';
import 'package:my_todo/service/TodoService.dart';
import 'package:my_todo/view/BottomNavBar.dart';
import 'package:provider/provider.dart';

class TodoPage extends StatelessWidget {
  final TodoService _todoService = TodoService();
  bool _isDeleted;
  String todoContent;
  Stream _stream;
  getStream(BuildContext context, bool a) {}
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    dynamic _provider = Provider.of<ItemStateProvider>(context);

    if (_provider.isDeletedPage == false) {
      _stream = _todoService.getAll();
    } else {
      _stream = _todoService.getAllDeleted();
    }
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: InkWell(
            child: Text('Planlarım'),
            onTap: () => {_provider.desicion(a: false)},
          ),
        ),
        bottomNavigationBar: bottomNavBar(_provider, context),
        body: StreamBuilder<List<TodoModel>>(
            stream: _stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final List<TodoModel> todos = snapshot.data;

              return ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 16.0);
                  },
                  itemCount: todos.length,
                  padding: EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    final TodoModel todo = todos[index];
                    return Dismissible(
                      background: slideRightBackground(),
                      secondaryBackground: slideLeftBackground(),
                      key: Key(todo.id),
                      confirmDismiss: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                if (todo.isDeleted == false) {
                                  return CupertinoAlertDialog(
                                    content: Text(
                                        "Bu etkinliği silmek istediğinizden emin misiniz ?"),
                                    actions: [
                                      CupertinoButton(
                                        child: Text("Evet"),
                                        onPressed: () async => {
                                          await _todoService
                                              .deleteDocument(todo),
                                          todos.removeAt(index),
                                          Navigator.pop(context),
                                        },
                                      ),
                                      CupertinoButton(
                                        child: Text("Vazgeç"),
                                        onPressed: () async => {
                                          Navigator.pop(context),
                                        },
                                      ),
                                    ],
                                  );
                                } else {
                                  return CupertinoAlertDialog(
                                    content: Text("Bu etkinlik zaten silinmiş"),
                                    actions: [
                                      CupertinoButton(
                                        child: Text("Tamam"),
                                        onPressed: () async => {
                                          Navigator.pop(context),
                                        },
                                      ),
                                    ],
                                  );
                                }
                              });
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                if (todo.isDeleted == true) {
                                  return CupertinoAlertDialog(
                                    content: Text(
                                        "Bu etkinliği geri getirmek istediğinizden emin misiniz ?"),
                                    actions: [
                                      CupertinoButton(
                                        child: Text("Evet"),
                                        onPressed: () async => {
                                          todo.isDeleted = false,
                                          await _todoService.putDocument(todo),
                                          todos.removeAt(index),
                                          Navigator.pop(context),
                                        },
                                      ),
                                      CupertinoButton(
                                        child: Text("Vazgeç"),
                                        onPressed: () async => {
                                          Navigator.pop(context),
                                        },
                                      ),
                                    ],
                                  );
                                } else {
                                  Navigator.maybePop(context);
                                }
                              });
                        }
                      },
                      child: Container(
                        color: Colors.grey.shade300,
                        child: ListTile(
                          leading: todo.completed
                              ? Icon(Icons.check,
                                  color: Colors.green, size: 25.0)
                              : Icon(Icons.check,
                                  color: Colors.grey, size: 25.0),
                          title: Text(todo.content,
                              style: TextStyle(fontSize: 20.0)),
                          selected: todo.completed,
                          onTap: () async {
                            todo.completed = !todo.completed;
                            await _todoService.putDocument(todo);
                          },
                        ),
                      ),
                    );
                  });
            }));
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.replay,
              color: Colors.white,
            ),
            Text(
              " Geri getir",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Sil",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget bottomNavBar(_provider, context) {
    return Consumer<BottomNavBarProvider>(builder: (context, model, child) {
      int _currentIndex = model.currentIndex;
      return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          print("begin current index: " + value.toString());
          switch (value) {
            case 0:
              myPlans(
                  currentIndex: _currentIndex,
                  model: model,
                  provider: _provider);
              break;
            case 1:
              myDeletedPlans(
                  currentIndex: _currentIndex,
                  model: model,
                  provider: _provider);
              break;
            case 2:
              addPlans(context: context, model: model);
              break;
            default:
          }
        },
        items: [
          BottomNavigationBarItem(
            label: "planlarım",
            icon: Icon(CupertinoIcons.today),
            activeIcon: Icon(
              CupertinoIcons.today,
            ),
          ),
          BottomNavigationBarItem(
            label: "silinen planlarım",
            icon: Icon(CupertinoIcons.today_fill),
            activeIcon: Icon(
              CupertinoIcons.today_fill,
            ),
          ),
          BottomNavigationBarItem(
              label: "Ekle",
              icon: Icon(CupertinoIcons.add),
              activeIcon: Icon(
                CupertinoIcons.add,
              ))
        ],
      );
    });
  }

  myPlans({currentIndex, model, provider}) {
    currentIndex = model.setIndex(index: 0);
    print(currentIndex);
    provider.desicion(a: false);
  }

  myDeletedPlans({currentIndex, model, provider}) {
    currentIndex = model.setIndex(index: 1);
    provider.desicion(a: true);
  }

  addPlans({model, context, todoContent}) {
    TodoService _todoService = TodoService();
    model.setIndex(index: 0);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              decoration: InputDecoration(hintText: 'Planınızı yazın'),
              onChanged: (String value) {
                todoContent = value;
              },
            ),
            actions: <Widget>[
              RaisedButton(
                child: Text('Ekle'),
                onPressed: () async {
                  final TodoModel todo = TodoModel(
                      content: todoContent, completed: false, isDeleted: false);
                  await _todoService.postDocument(todo);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Vazgeç'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
