import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/src/firebaseService.dart';
import 'package:seller_app/src/screens/chatConversation.dart';

class RequestDescriptionScreen extends StatefulWidget {
  var buyerName;
  var buyerID;
  var sellerName;
  var category;
  var deadline;
  var description;
  var price;
  var title;
  var requestID;
  var accepted;
  var iconButton;
  var deleted;

  RequestDescriptionScreen({
    this.buyerName,
    this.buyerID,
    this.sellerName,
    this.category,
    this.deadline,
    this.description,
    this.price,
    this.title,
    this.requestID,
    this.accepted,
    required this.iconButton,
    required this.deleted,
  });

  @override
  State<RequestDescriptionScreen> createState() => _RequestDescriptionScreenState();
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
}

class _RequestDescriptionScreenState extends State<RequestDescriptionScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseService _service = FirebaseService();
  CollectionReference requests = FirebaseFirestore.instance.collection('requests');
  String _sellerName = '';

  createChatRoom() async {
    Map <String, dynamic> request = {
      'buyerName': widget.buyerName,
      'buyerID': widget.buyerID,
      'sellerName': widget.sellerName,
      'category': widget.category,
      'deadline': widget.deadline,
      'description': widget.description,
      'price': widget.price,
      'title': widget.title,
      'requestID': widget.requestID,
      'deleted' : widget.deleted,
    };

    List<String> users = [
      widget.buyerID,
      auth.currentUser!.uid
    ];

    String chatRoomId = '${widget.buyerID}.${auth.currentUser!.uid}.${widget.requestID}';

    Map<String, dynamic> chatData = {
      'users' : users,
      'chatRoomId' : chatRoomId,
      'request' : request,
      'lastChat' : null,
      'lastChatTime' : DateTime.now().microsecondsSinceEpoch,
    };

    _service.createRequestChatRoom(
      chatData: chatData,
    );

    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChatConversations(chatRoomId: chatRoomId, type: 'requests')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan.shade900,
        title: const Text(
          'Request Description',
          style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    Text(
                      '\$' + widget.price,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'by ' + widget.buyerName,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Deadline: ' + widget.deadline,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              widget.deleted == 'true' ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '[DELETED]',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ) :
              widget.iconButton ?
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  widget.sellerName == 'null' ?
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              final uid = AuthService().currentUser?.uid;
                              DocumentSnapshot ds = await FirebaseFirestore.instance.collection('sellers').doc(uid).get();
                              _sellerName = ds.get('Name');
                              DocumentReference dr = FirebaseFirestore.instance.collection('requests').doc(widget.requestID);
                              dr.update({'Seller Name' : _sellerName});
                              dr.update({'Accepted' : 'true'});
                              Navigator.pop(context);
                            },
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.add_task,
                                  size: 28.0,
                                  color: Colors.green,
                                ),
                                Text(
                                  'Accept Request',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: createChatRoom,
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.chat,
                                  size: 28.0,
                                  color: Colors.blue,
                                ),
                                Text(
                                  'Chat',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) :
                  widget.accepted == 'true' ?
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              DocumentReference dr = FirebaseFirestore.instance.collection('requests').doc(widget.requestID);
                              dr.update({'Accepted' : 'completed'});
                              Navigator.pop(context);
                            },
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.domain_verification,
                                  size: 28.0,
                                  color: Colors.green,
                                ),
                                Text(
                                  'Mark Completed',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: createChatRoom,
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.chat,
                                  size: 28.0,
                                  color: Colors.blue,
                                ),
                                Text(
                                  'Chat',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) :
                  Container(),
                ],
              ) :
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
