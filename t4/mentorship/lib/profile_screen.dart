import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:mentorship/services/db_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:mentorship/services/authservice.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({@required this.auth});

  final Auth auth;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    dbService = DbStorage(widget.auth);
    _isLoading = false;
  }

  bool _isLoading = false;
  DbStorage dbService;
  File _image;
  String _uploadedFileURL;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            RawMaterialButton(
              onPressed: () {
                print('a');
              },
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.black54,
              ),
              shape: new CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.white,
            ),
            _image != null
                ? Image.file(
                    _image,
                    height: 150,
                  )
                : Container(height: 150),
            _image == null
                ? RaisedButton(
                    child: Text('Choose File'),
                    onPressed: chooseFile,
                    color: Colors.cyan,
                  )
                : Container(),
            _image != null
                ? RaisedButton(
                    child: Text('Upload File'),
                    onPressed: uploadFile,
                    color: Colors.cyan,
                  )
                : Container(),
            _uploadedFileURL != null
                ? Image.network(
                    _uploadedFileURL,
                    height: 150,
                  )
                : Container(),
            showCircularProgress()
          ],
        ),
      ),
    );
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadFile() async {
    setState(() {
      _isLoading = true;
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profiles/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String fileURL = await storageReference.getDownloadURL();

    setState(() {
      _uploadedFileURL = fileURL;
    });
    await dbService.updateProfilePic(fileURL);

    setState(() {
      _isLoading = false;
    });
  }

  Widget showCircularProgress() {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.red[300]),
      ));
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}
