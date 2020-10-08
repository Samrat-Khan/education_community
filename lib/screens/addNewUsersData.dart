import 'dart:io';

import 'package:education_community/screens/HomePage.dart';
import 'package:education_community/services/firebase_service_for_setData.dart';
import 'package:education_community/services/photo_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNewUsersData extends StatefulWidget {
  final User user;

  AddNewUsersData({this.user});

  @override
  _AddNewUsersDataState createState() => _AddNewUsersDataState();
}

class _AddNewUsersDataState extends State<AddNewUsersData> {
  File fileImage;
  String displayName, aboutUser;
  bool isAllFieldEmpty = true;
  bool isUserEmailEmpty = true;

  TextEditingController _displayNameTextEditController =
      TextEditingController();
  TextEditingController _aboutUserTextEditController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _displayNameTextEditController.dispose();
    _aboutUserTextEditController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Bio"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            photoChooseContainer(),
            SizedBox(
              height: 20,
            ),
            displayNameTextField(),
            SizedBox(
              height: 10,
            ),
            userFixedEmailField(),
            SizedBox(
              height: 10,
            ),
            aboutUserTextField(),
            MaterialButton(
              color: Colors.green,
              child: Text("Submit"),
              onPressed: uploadUserDataToFireStore,
            ),
          ],
        ),
      ),
    );
  }

  PhotoPicker photoPicker = PhotoPicker();

  imagePicFromGallery() async {
    fileImage = await photoPicker.pickImageFromGallery();
  }

  checkTextFieldEmptyOrNot() {
    if (_displayNameTextEditController.text.isEmpty == true ||
        fileImage == null) {
      setState(() {
        isAllFieldEmpty = true;
      });
    } else {
      setState(() {
        isAllFieldEmpty = false;
      });
    }
  }

  uploadUserDataToFireStore() async {
    FirebaseServiceSetData fireBaseService = FirebaseServiceSetData();
    String userPhotoUrl = await fireBaseService
        .uploadUserProfilePhotoToFireStorage(fileImage, widget.user.uid);
    fireBaseService
        .updateUserDataToFirebase(
      displayName: displayName,
      aboutUser: aboutUser,
      userEmail: widget.user.email,
      photoUrl: userPhotoUrl,
      uid: widget.user.uid,
    )
        .whenComplete(() {
      Navigator.of(context).pushNamed(
        "Homepage",
        arguments: Homepage(),
      );
    });
  }

  Container photoChooseContainer() {
    return Container(
      height: 110,
      width: 110,
      child: InkWell(
        child: Stack(
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                  image: fileImage == null
                      ? AssetImage("images/14.png")
                      : FileImage(fileImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              child: IconButton(
                  icon: Icon(
                    Icons.add_photo_alternate_rounded,
                    size: 30,
                    color: Colors.black,
                  ),
                  onPressed: imagePicFromGallery),
              bottom: 10,
              right: 7,
            ),
          ],
        ),
        onTap: imagePicFromGallery,
      ),
    );
  }

  Container displayNameTextField() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black)),
      child: TextField(
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: "ImGoogle",
          border: InputBorder.none,
          labelText: "Display Name",
        ),
        controller: _displayNameTextEditController,
        onChanged: (String text) {
          displayName = text;
        },
      ),
    );
  }

  Container userFixedEmailField() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black)),
      child: TextField(
        decoration: InputDecoration(
          hintText: widget.user.email,
          border: InputBorder.none,
        ),
        enabled: false,
      ),
    );
  }

  Container aboutUserTextField() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black)),
      child: TextField(
        maxLines: 5,
        maxLength: 180,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: "Max 5 Lines",
          border: InputBorder.none,
          labelText: "About Yourself",
        ),
        controller: _aboutUserTextEditController,
        onChanged: (String text) {
          aboutUser = text;
        },
      ),
    );
  }
}
