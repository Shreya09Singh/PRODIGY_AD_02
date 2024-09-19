import 'package:flutter/material.dart';
import 'package:flutter_hivee/models/Boxes.dart';
import 'package:flutter_hivee/models/NotesModel.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final titlecontroller = TextEditingController();
  final contentcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
      ),
      body: ValueListenableBuilder(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, _) {
            var data = box.values.toList().cast<NotesModel>();
            return ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: box.length,
                itemBuilder: (context, index) {
                  return Card(
                    // margin: EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(data[index].title.toString()),
                              Spacer(),

                              IconButton(
                                  onPressed: () {
                                    editDialog(
                                        data[index],
                                        data[index].title.toString(),
                                        data[index].content.toString());
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    size: 18,
                                  )),
                              // SizedBox(
                              //   width: 10,
                              // ),
                              IconButton(
                                  onPressed: () {
                                    delete(data[index]);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    size: 18,
                                  )),
                            ],
                          ),
                          Text(data[index].content.toString()),
                        ],
                      ),
                    ),
                  );
                });
          }),

      //Column(
      //children: [
      //     FutureBuilder(
      //         future: Hive.openBox('Flutter'),
      //         builder: (context, snapshot) {
      //           if (snapshot.hasData) {
      //             return Text(snapshot.data!.get('job').toString());
      //           }
      //           return CircularProgressIndicator(
      //             color: Colors.red,
      //           );
      //         }),
      //     FutureBuilder(
      //         future: Hive.openBox('shreya'),
      //         builder: (context, snapshot) {
      //           if (snapshot.hasData) {
      //             // return Text(snapshot.data!.get('details').toString());
      //             return ListTile(
      //               title: Text(snapshot.data!.get('name').toString()),
      //               subtitle: Text(snapshot.data!.get('details').toString()),
      //               trailing: IconButton(
      //                   onPressed: () {
      //                     snapshot.data!.put('name', 'Shreyaarijit');
      //                     snapshot.data!.delete('name');
      //                     setState(() {});
      //                   },
      //                   icon: Icon(Icons.edit)),
      //             );
      //           }
      //           return CircularProgressIndicator(
      //             color: Colors.red,
      //           );
      //         }),
      //  ],
      //),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FloatingActionButton(
            onPressed: () async {
              _showmyDialog();
              // var box = await Hive.openBox('shreya');
              // var box2 = await Hive.openBox('Flutter');
              // box.put('name', 'shreya singh');
              // box.put('age', '22');
              // box.put('details', {
              //   'title': 'Flutter Developer',
              //   'clg': 'Parul University',
              //   'love': 'arijit'
              // });
              // box2.put('job', 'Flutter Cross-platform Developer');
              // print(box.get('name'));
              // print(box.get('age'));
              // print(box.get('details')['love']);
            },
            child: Icon(
              Icons.add,
              size: 30,
            )),
      ),
    );
  }

  void delete(NotesModel notesmodel) async {
    await notesmodel.delete();
  }

  Future<void> _showmyDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Create Notes'),
            content: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: titlecontroller,
                    decoration: InputDecoration(
                        hintText: 'title', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: contentcontroller,
                    decoration: InputDecoration(
                        hintText: 'content', border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    final data = NotesModel(
                        title: titlecontroller.text,
                        content: contentcontroller.text);

                    final box = Boxes.getData();
                    box.add(data);
                    // data.save();
                    print(box);

                    titlecontroller.clear();
                    contentcontroller.clear();

                    Navigator.pop(context);
                  },
                  child: Text('Add')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancle')),
            ],
          );
        });
  }

  Future<void> editDialog(
      NotesModel notesmodel, String title, String content) async {
    titlecontroller.text = title;
    contentcontroller.text = content;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Create Notes'),
            content: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: titlecontroller,
                     
                    decoration: InputDecoration(
                        hintText: 'title', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: contentcontroller,
                    decoration: InputDecoration(
                        hintText: 'content', border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    notesmodel.title = titlecontroller.text.toString();
                    notesmodel.content = contentcontroller.text.toString();
                    notesmodel.save();

                    titlecontroller.clear();
                    contentcontroller.clear();


                    Navigator.of(context).pop();
                  },
                  child: Text('Edit')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancle')),
            ],
          );
        });
  }
}
