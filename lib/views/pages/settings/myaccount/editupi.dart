import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditUpi extends StatefulWidget {
  final String upiId;
  final String docId;
  final Function(String) onUpiUpdated;
  const EditUpi(
      {super.key,
      required this.upiId,
      required this.docId,
      required this.onUpiUpdated});

  @override
  State<EditUpi> createState() => _EditUpiState();
}

class _EditUpiState extends State<EditUpi> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _upiController;

  @override
  void initState() {
    super.initState();
    _upiController = TextEditingController(text: widget.upiId);
  }

  @override
  void dispose() {
    super.dispose();
    _upiController.dispose();
  }

  Future<void> updateUpi() async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('payment')
            .doc(widget.docId)
            .update({
          'upiId': _upiController.text,
        });

        widget.onUpiUpdated(_upiController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("UPI ID updated successfully"),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating artwork: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        "Edit UPI ID",
        style: TextStyle(fontSize: 20),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextFormField(
                onFieldSubmitted: (value) {
                  if (_formKey.currentState?.validate() ?? false) {
                    updateUpi(); // You can call the update method or any logic you want
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your UPI ID';
                  }
                  if (value.length < 5 || value.length > 50) {
                    return 'UPI ID should be more than 15 characters';
                  }
                  final RegExp regex =
                      RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+$');
                  if (!regex.hasMatch(value)) {
                    return 'Please enter a valid UPI ID';
                  }
                  return null;
                },
                controller: _upiController,
                cursorColor: Colors.black,
                cursorWidth: 1,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: 'UPI ID',
                ),
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            style: TextButton.styleFrom(overlayColor: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
                style: TextStyle(color: Colors.black, fontSize: 17), "Cancel")),
        const SizedBox(
          width: 10,
        ),
        TextButton(
          style: TextButton.styleFrom(overlayColor: Colors.black),
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              updateUpi();
            }
          },
          child: const Text(
              style: TextStyle(color: Colors.black, fontSize: 17), "Save"),
        ),
      ],
    );
  }
}
