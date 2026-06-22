
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../const.dart';

addReport(BuildContext context, User user) {
  ValueNotifier<String?> type = ValueNotifier(null);
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  

  final ImagePicker picker = ImagePicker();
  Map<String, List<dynamic>> mediaMap = {
    "photos": [],
    "videos": [],
  };


  showDialog(context: context, builder: (_) => AlertDialog(
    title: Text("Add Report"),
    content: StatefulBuilder(builder: (context, setState) {
      return Container(
        height: 320,
        width: 300,
        child: Column(
          spacing: 10,
          children: [
            ValueListenableBuilder(
              valueListenable: type, builder: (BuildContext context, value, Widget? child) {
              return ListTile(
                leading: type.value != null ? Icon(IconData(int.parse(type.value!.split("_")[1]), fontFamily: 'MaterialIcons')) : null,
                title: Text('${type.value?.split("_")[0] ?? 'Report Type: Select'}'),
                onTap: () async {
                  final result = await selectType(context);
                  print(result.toString());
                  type.value = result.toString();
                },
              );
            },
            ),
            TextField(
              controller: title,
              maxLength: 50,
              decoration: InputDecoration(
                  hintText: 'Title'
              ),
            ),
            TextField(
              controller: description,
              maxLength: 500,
              maxLines: 4,
              decoration: InputDecoration(
                  hintText: 'Description'
              ),
            ),
            mediaMap["photos"]!.isEmpty && mediaMap["videos"]!.isEmpty ?  TextButton(onPressed: () async {
              final List<XFile>? pickedFiles = await picker.pickMultipleMedia(
                limit: 5,
              );

              List<String> videoExtensions = ['.mp4' , '.mov','.avi', '.mkv'];


              if (pickedFiles != null && pickedFiles.isNotEmpty) {
                for (int i = 0; i < pickedFiles.length; i++) {
                  final currentFile = pickedFiles[i];
                  final pathLower = currentFile.path.toLowerCase();

                  bool isVideo = videoExtensions.any((ext) => pathLower.endsWith(ext));

                  final mediaData = await currentFile.readAsBytes();
                  final mediaPath = File(currentFile.path);

                  if (isVideo) {
                    if (kIsWeb) {
                      mediaMap['videos']!.add(mediaData);
                    } else {
                      mediaMap['videos']!.add(mediaPath);
                    }
                  } else {
                    if (kIsWeb) {
                      mediaMap['photos']!.add(mediaData);
                    } else {
                      mediaMap['photos']!.add(mediaPath);
                    }
                  }
                }
              }


              setState((){});

            }, child: Text("Add Attachments"),) : TextButton(onPressed: () {
              showDialog(context: context, builder: (_) => AlertDialog(
                title: Text("Attachments"),
                content: StatefulBuilder(builder: (context, setState) {


                  final photosLength = mediaMap['photos']!.length;


                  List<dynamic> allMedia = [
                    ...mediaMap["photos"]!,
                    ...mediaMap["videos"]!,
                  ];

                  return Container(
                    height: 500,
                    width: 500,
                    child: ListView.builder(
                        itemCount: allMedia.length,
                        itemBuilder: (context, i) {
                          return Card(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              height: 120,
                              child: Row(
                                spacing: 10,
                                children: [
                                  InkWell(
                                    onTap:() {

                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      height: 100,
                                      width: 100,
                                      child: FittedBox(
                                        clipBehavior: Clip.hardEdge,
                                        fit: BoxFit.cover,
                                        child: i > photosLength ? Image.memory(allMedia[i]) :  VideoPlayer(VideoPlayerController.file(allMedia[i])),
                                      ),
                                    ),
                                  ),
                                  Text("File ${i + 1}", overflow: TextOverflow.ellipsis,),
                                  Spacer(),
                                  IconButton(onPressed: () {
                                    allMedia.removeAt(i);
                                    setState((){});
                                  }, icon: Icon(Icons.delete),)
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                }),

                actions: [
                  TextButton(onPressed: () {
                    mediaMap['videos']!.clear();
                    mediaMap['photos']!.clear();
                    Navigator.pop(context);
                    setState((){});
                  },  child: Text("Clear Attachments"))
                ],
              ));
            }, child: Text("See Attachments"))

          ],
        ),
      );
    }),
    actions: [
      TextButton(onPressed: () {
        submitReport(context, user, title.text.trim(), description.text.trim(), type.value!.trim());
      }, child: Text("Add Report"))
    ],
  ));
}


Future<FilePickerResult?> pickMediaFiles() async {
  try {

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      print(result.files.single.name);
    }
  } catch(e){
    print(e);
  }

}

submitReport(BuildContext context, User user, String title, String description, String type) async {
  if (type.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a report type."))
    );
    return;
  }

  if (title.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a title."))
    );
    return;
  }

  if (description.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a description."))
    );
    return;
  }

  await firestore.collection('reports').add({
    'email': user.email,
    'phone': user.phoneNumber,
    'displayName': user.displayName,
    'createdAt': FieldValue.serverTimestamp(),
    'status': 'Pending',
    'type': type,
    'title': title,
    'description': description
  });

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Report Submitted")));
}

selectType(BuildContext context) {
  return showDialog(context: context, builder: (_) => AlertDialog(
    content: Container(
      height: 300,
      width: 300,
      child: StreamBuilder(stream: firestore.collection('reportTypes').snapshots(), builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Container(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }

        return snapshot.data!.docs.isEmpty ? Center(child: Text(
            "No Report Types", style: TextStyle(color: Colors.grey))) : ListView
            .builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, i) {
              return ListTile(
                leading: Icon(IconData(snapshot.data!.docs[i].get('codePoint'), fontFamily: 'MaterialIcons')),
                title: Text(snapshot.data!.docs[i].get('name')),
                onTap: () {
                  final typeValue = "${snapshot.data!.docs[i].get('name')}_${snapshot.data!.docs[i].get('codePoint')}";
                  Navigator.pop(context, typeValue);

                },
              );

            });


      }
    ),
  )));
}
