import 'package:flutter/material.dart';
import 'package:mentorship/services/db_storage.dart';
import 'package:toast/toast.dart';

class AddListing extends StatefulWidget {
  const AddListing({@required this.dbService});
  final DbStorage dbService;
  @override
  _AddListingState createState() => _AddListingState();
}

class _AddListingState extends State<AddListing> {
  String _title;
  String _description;
  @override
  void initState() {
    _title = "";
    _description = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Colors.black, Colors.black87],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: TextField(
                  onChanged: (value) {
                    _title = value;
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[100]),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[300]),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.red[300],
                    ),
                    labelText: 'Title',
                    focusColor: Colors.white,
                  ),
                  cursorColor: Colors.red[300],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: TextField(
                  maxLines: null,
                  minLines: 7,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {
                    _description = value;
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[100]),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[300]),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.red[300],
                    ),
                    labelText: 'Description',
                    focusColor: Colors.white,
                  ),
                  cursorColor: Colors.red[300],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: MaterialButton(
                  onPressed: () {
                    validateAndUpload(_title, _description);
                  },
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Text('Submit'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validateAndUpload(String title, String description) {
    if (title.isNotEmpty && description.isNotEmpty) {
      widget.dbService.uploadListing(title, description);
      Toast.show("Listed!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      Navigator.pop(context);
    } else {
      Toast.show("Empty fields!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    }
  }
}
