import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PostFormScreen extends StatefulWidget {
  const PostFormScreen({Key? key}) : super(key: key);

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
}

class _PostFormScreenState extends State<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();

  PlatformFile? pickedVideoFile;
  UploadTask? uploadTaskVideo;
  PlatformFile? pickedImageFile;
  UploadTask? uploadTaskImage;
  final db = FirebaseFirestore.instance;

  late String _sellerName;
  late String _currentTitle;
  late String _currentDescription;
  late String _ImageURL;
  late String _VideoURL;
  bool videoSelected = false;
  bool imageSelected = false;


  Future<void> getName() async {
    final uid = AuthService().currentUser?.uid;
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('sellers').doc(uid).get();
    _sellerName = ds.get('Name');
  }

  Future selectVideoFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedVideoFile = result.files.first;
      videoSelected = true;
    });
  }

  Future uploadVideoFile() async {
    final path = 'files/${pickedVideoFile!.name}';
    final file = File(pickedVideoFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTaskVideo = ref.putFile(file);
    });
    ref.putFile(file);
    uploadTaskVideo = ref.putFile(file);
    final snapshot = await uploadTaskVideo!.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      _VideoURL = urlDownload;
      uploadTaskVideo = null;
      videoSelected = false;
    });
  }

  Future selectImageFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedImageFile = result.files.first;
      imageSelected = true;
    });
  }

  Future uploadImageFile() async {
    final path = 'files/${pickedImageFile!.name}';
    final file = File(pickedImageFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTaskImage = ref.putFile(file);
    });
    ref.putFile(file);
    uploadTaskImage = ref.putFile(file);
    final snapshot = await uploadTaskImage!.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      _ImageURL = urlDownload;
      uploadTaskImage = null;
      imageSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        centerTitle: true,
        title: const Text(
          'Add Post',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: const [
                    Text(
                      'Add Post',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Title',
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange.shade600,
                        width: 2.0,
                      ),
                    ),
                  ),
                  validator: (val) => val!.isEmpty ? 'Please enter a title' : null,
                  onChanged: (val) => setState(() => _currentTitle = val),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Description',
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange.shade600,
                        width: 2.0,
                      ),
                    ),
                  ),
                  validator: (val) => val!.isEmpty ? 'Please enter a description' : null,
                  onChanged: (val) => setState(() => _currentDescription = val),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.orange[600])),
                      onPressed: () async {
                        selectVideoFile();
                      },
                      child: const Text(
                        'Select Video',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.orange[600])),
                      onPressed: () async {
                        selectImageFile();
                      },
                      child: const Text(
                        'Select Thumbnail',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                imageSelected && videoSelected ?
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.orange[600])),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await uploadVideoFile();
                      await uploadImageFile();

                      final uid = AuthService().currentUser?.uid;
                      DocumentSnapshot ds = await FirebaseFirestore.instance.collection('sellers').doc(uid).get();
                      _sellerName = ds.get('Name');
                      DocumentReference dr = FirebaseFirestore.instance.collection('posts').doc();
                      Map<String, Object> post = new HashMap();
                      post.putIfAbsent('URL', () => _VideoURL);
                      post.putIfAbsent('Thumbnail', () => _ImageURL);
                      post.putIfAbsent('Title', () => _currentTitle);
                      post.putIfAbsent('Description', () => _currentDescription);
                      post.putIfAbsent('Post ID', () => dr.id);
                      post.putIfAbsent('Seller Name', () => _sellerName);
                      dr.set(post);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PostFormScreen()));
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.black),
                  ),
                ) :
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.amber[600])),
                  onPressed: () {},
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
