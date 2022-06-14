import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  CollectionReference messages = FirebaseFirestore.instance.collection(
      'messages');
  CollectionReference listings = FirebaseFirestore.instance.collection(
      'listings');


  createChatRoom({chatData}) {
    // need change to  catch error
    messages.doc(chatData['chatRoomId']).set(chatData).catchError((e) {
      print(e.toString());
    });
  }

  createChat(String chatRoomId, message) {
    messages.doc(chatRoomId).collection('chats').add(message).catchError((e) {
      print(e.toString());
    });
    messages.doc(chatRoomId).update({
      'lastChat': message['message'],
      'lastChatTime' : message['time'],

    });
  }
  getChat(chatRoomId) async{
    return messages.doc(chatRoomId).collection('chats').orderBy('time').snapshots();
  }

  Future<DocumentSnapshot> getProductDetails(id)async{
    DocumentSnapshot doc = await listings.doc(id).get();
    return doc;
  }
}