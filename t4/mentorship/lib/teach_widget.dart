import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorship/add_listing.dart';
import 'package:mentorship/services/authservice.dart';
import 'package:mentorship/services/db_storage.dart';

import 'listing_detail.dart';

class TeachWidget extends StatefulWidget {
  const TeachWidget({@required this.auth});

  final Auth auth;
  @override
  _TeachWidgetState createState() => _TeachWidgetState();
}

class _TeachWidgetState extends State<TeachWidget> {
  DbStorage dbService;

  @override
  void initState() {
    super.initState();
    dbService = DbStorage(widget.auth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(44, 53, 57, 1),
        elevation: 0,
        title: Text("Teaching"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddListing(dbService: dbService)));
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Colors.black, Colors.black87],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListingsList(
            dbService: dbService,
          ),
        ),
      ),
    );
  }
}

class ListingsList extends StatefulWidget {
  const ListingsList({@required this.dbService});
  final DbStorage dbService;
  @override
  _ListingsListState createState() => _ListingsListState();
}

class _ListingsListState extends State<ListingsList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('listings').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              itemExtent: 80,
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return ListCard(
                  document: document,
                );
              }).toList(),
            );
        }
      },
    );
  }
}

class ListCard extends StatefulWidget {
  const ListCard({
    @required this.document,
    Key key,
  }) : super(key: key);
  final DocumentSnapshot document;
  @override
  _ListCardState createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  String _imageURL =
      "https://www.pngkey.com/png/full/230-2301779_best-classified-apps-default-user-profile.png";

  @override
  void initState() {
    super.initState();
    setImage(widget.document['uid']);
  }

  void setImage(String uid) async {
    var documents =
        await Firestore.instance.collection('profile-pics').getDocuments();
    if (documents.documents.isNotEmpty) {
      for (DocumentSnapshot document in documents.documents) {
        if (document.data.isNotEmpty) {
          if (document.data['uid'] == uid) {
            setState(() {
              _imageURL = document.data['url'];
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.all(2),
      color: Color.fromRGBO(34, 43, 47, 1),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ListingDetail(document: widget.document)));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  _imageURL,
                ),
                backgroundColor: Colors.transparent,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.document['title'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                        widget.document['description'],
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey[600]),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
