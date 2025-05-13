import 'dart:developer';
import 'dart:io';

import 'package:art_elevate/chats/chat_services.dart';
import 'package:art_elevate/chats/chatbubble.dart';
import 'package:art_elevate/views/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessagePage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  final bool isAdmin;

  const MessagePage(
      {super.key,
      required this.receiverEmail,
      required this.receiverID,
      this.isAdmin = false});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? selectedImage;
  Timestamp? _timestamp;
  String previousDate = '';

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (await File(image.path).exists()) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    }
  }

  Future uploadImage() async {
    if (selectedImage != null) {
      try {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child("chats").child(fileName);
        final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

        final snapshot = await task;
        if (snapshot.state == TaskState.success) {
          var downloadUrl = await snapshot.ref.getDownloadURL();
          return downloadUrl;
        }
      } catch (e) {
        return Text(AppLocalizations.of(context)!.error);
      }
    }
    return null;
  }

  String _formatTimestamp(Timestamp timeStamp) {
    final DateTime dateTime = timeStamp.toDate();
    final now = DateTime.now();
    if (DateFormat('yyyyMMdd').format(dateTime) ==
        DateFormat('yyyyMMdd').format(now)) {
      return 'Today';
    } else if (DateFormat('yyyyMMdd').format(dateTime) ==
        DateFormat('yyyyMMdd').format(now.subtract(
          const Duration(days: 1),
        ))) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM dd,yyyy').format(dateTime);
    }
  }

  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollDown();
    });
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  final ChatServices _chatServices = ChatServices();

  User? user = FirebaseAuth.instance.currentUser;

  getUserID() {
    if (user != null) {
      return user!.uid;
    }
  }

  getImageUrl() async {
    await uploadImage();
  }

  Future<void> sendImageIntoChat(String receiverID, String imageUrl) async {
    log(imageUrl);

    await _chatServices.sendImageToChat(receiverID, imageUrl);

    scrollDown();
  }

  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(
          widget.receiverID, _messageController.text);
      _messageController.clear();
    }
    scrollDown();
  }

  Future<void> sendReportingMessage() async {
    await FirebaseFirestore.instance.collection('reported_users').add({
      'reporterID': getUserID(),
      'reporterEmail': user!.email,
      'reportedEmail': widget.receiverEmail,
      'reportedID': widget.receiverID,
      'reason': "Reported on Chats : ${_reportController.text}",
      'timestamp': Timestamp.now(),
    });
    _reportController.clear();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  final TextEditingController _reportController = TextEditingController();

  void _showReportDialog() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsOverflowButtonSpacing: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Report this user?",
            style: GoogleFonts.poppins(color: Colors.black, fontSize: 19),
          ),
          actions: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _reportController,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reason';
                  }
                  return null;
                },
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                cursorColor: Colors.black,
                cursorOpacityAnimates: true,
                cursorWidth: 1,
                onTapOutside: (PointerDownEvent event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: 'Reason',
                  labelStyle: GoogleFonts.notoSans(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(overlayColor: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(overlayColor: Colors.black),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                          content: Text(AppLocalizations.of(context)!.report_sent_successfully),
                          backgroundColor: Colors.green,
                        ),
                      );
                      sendReportingMessage();
                    }
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: widget.isAdmin ? true : false,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: widget.isAdmin ? 24 : 20,
          fontWeight: widget.isAdmin ? FontWeight.w500 : FontWeight.w400,
        ),
        title: Text(widget.isAdmin ? 'Admin' : widget.receiverEmail),
        backgroundColor: kprimaryColor,
        titleSpacing: 0,
        actions: [
          if (!widget.isAdmin)
            PopupMenuButton<String>(
              onSelected: (value) {
                // Handle the menu item selection here
                if (value == 'report') {
                  _showReportDialog();
                }
              },
              icon: const Icon(Icons.more_vert), // Three dots icon
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              itemBuilder: (context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'report',
                  child: Text(
                    'Report user',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput()
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = getUserID();
    return StreamBuilder(
      stream: _chatServices.getMessages(senderID, widget.receiverID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(AppLocalizations.of(context)!.error);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.black), // Progress color
                backgroundColor: Colors.white, // Background color of the circle
                strokeWidth: 5.0),
          );
        }
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(doc, previousDate))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc, String previousDate) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == getUserID();
    String? imageUrl = data['imageUrl'];
    log(data['imageUrl']);
    String senderID = getUserID();
    Timestamp timestamp = data['timestamp'];

    String messageDate = DateFormat('hh:mm a').format(timestamp.toDate());
    String currentDate = DateFormat('yyyyMMdd').format(DateTime.now());

    bool showDateLabel = messageDate == currentDate;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        alignment: alignment,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (showDateLabel)
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('Today'),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Chatbubble(
                      timestamp: timestamp,
                      receiverID: widget.receiverID,
                      senderID: senderID,
                      message: data['message'],
                      isCurrentUser: isCurrentUser,
                      imageUrl: imageUrl,
                    ),
                  ],
                ),
                SizedBox(
                  height: 18,
                  child: Padding(
                    padding: isCurrentUser
                        ? const EdgeInsets.only(right: 10.0)
                        : const EdgeInsets.only(left: 15.0),
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 10.0, top: 0, left: 5),
                        child: Text(
                          messageDate,
                          style: GoogleFonts.openSans(fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0, right: 0),
          child: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                shape: BoxShape.rectangle,
                color: Colors.white),
            child: IconButton(
              onPressed: () async {
                await getImage();
                if (selectedImage != null) {
                  String imageUrl = await uploadImage();
                  if (imageUrl.isNotEmpty) {
                    await sendImageIntoChat(widget.receiverID, imageUrl);
                  }
                }
              },
              icon: const Icon(
                Iconsax.gallery_add_copy,
                color: Colors.grey,
                size: 44,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 4, right: 10),
            child: Container(
              height: 56, // Match the height of the icon buttons
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Colors.grey[100],
              ),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                focusNode: myFocusNode,
                cursorColor: Colors.black,
                cursorWidth: 1,
                // onTapOutside: (PointerDownEvent event) =>
                //     FocusManager.instance.primaryFocus?.unfocus(),
                controller: _messageController,
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.black)),
                    fillColor: Colors.grey[100],
                    filled: true,
                    hintText: 'Type a message',
                    hintStyle: GoogleFonts.notoSans(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.1),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 15)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 8),
          child: Container(
            height: 49,
            width: 49,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                shape: BoxShape.rectangle,
                color: Colors.green.shade800),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward_rounded,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
