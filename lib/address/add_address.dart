import 'package:art_elevate/address/savedaddress.dart';
import 'package:art_elevate/views/utils/constant.dart';
import 'package:art_elevate/views/pages/orderpages/order_summary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:art_elevate/l10n/app_localizations.dart';

class AddAddresspdt extends StatefulWidget {
  const AddAddresspdt({
    super.key,
  });

  @override
  State<AddAddresspdt> createState() => _AddAddresspdtState();
}

class _AddAddresspdtState extends State<AddAddresspdt> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> _addAddress() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      User? user = FirebaseAuth.instance.currentUser;
      final firestore = FirebaseFirestore.instance;
      CollectionReference addressRef =
          firestore.collection('users').doc(user?.uid).collection('addresses');
      if (user != null) {
        try {
          await addressRef.add({
            "fullName": _nameController.text,
            "phoneNumber": _phoneController.text,
            "state": _stateController.text,
            "city": _cityController.text,
            "houseNo": _houseController.text,
            "landmark": _landmarkController.text,
            "pincode": _pincodeController.text,
            "isDefault": true,
          }).then((value) {
            setState(() {
              isLoading = false;
            });
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(AppLocalizations.of(context)!.addressAdded)),
              );
            }
          });
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text(AppLocalizations.of(context)!.addressAddFailed)),
            );
          }
        }
      }
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _phoneController.dispose();
    _landmarkController.dispose();
    _houseController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: kprimaryColor,
        title: Text(AppLocalizations.of(context)!.addDeliveryAddress),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.black), // Progress color
                backgroundColor: Colors.white, // Background color of the circle
                strokeWidth: 5.0, // Thickness of the circle's stroke
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .pleaseEnterName;
                          }
                          if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                            return AppLocalizations.of(context)!
                                .pleaseEnterValidName;
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
                          labelText:
                              AppLocalizations.of(context)!.fullNameRequired,
                          labelStyle: GoogleFonts.notoSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .pleaseEnterPhone;
                          }
                          if (value.length != 10 || value.length >= 11) {
                            return AppLocalizations.of(context)!
                                .pleaseEnterValidPhone;
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly
                        ],
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
                          labelText:
                              AppLocalizations.of(context)!.phoneNumberRequired,
                          labelStyle: GoogleFonts.notoSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _pincodeController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .pleaseEnterPincode; // Custom message if empty
                          }
                          if (value.length != 6) {
                            return AppLocalizations.of(context)!
                                .pleaseEnter6DigitPincode; // Custom message if not 6 digits
                          }
                          if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
                            return AppLocalizations.of(context)!
                                .pincodeMustBeNumeric; // Custom message if not numeric
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 6,
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
                          labelText:
                              AppLocalizations.of(context)!.pincodeRequired,
                          labelStyle: GoogleFonts.notoSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          counterText: '',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _stateController,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .pleaseEnterState;
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
                          labelText:
                              AppLocalizations.of(context)!.stateRequired,
                          labelStyle: GoogleFonts.notoSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _cityController,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .pleaseEnterCity;
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
                          labelText: AppLocalizations.of(context)!.cityRequired,
                          labelStyle: GoogleFonts.notoSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _houseController,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .pleaseEnterHouse;
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
                          labelText:
                              AppLocalizations.of(context)!.houseNoRequired,
                          labelStyle: GoogleFonts.notoSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return AppLocalizations.of(context)!.pleaseEnterLandmark;
                        //   }
                        //   return null;
                        // },
                        controller: _landmarkController,
                        textCapitalization: TextCapitalization.sentences,
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        cursorColor: Colors.black,
                        cursorOpacityAnimates: true,
                        cursorWidth: 1,
                        onTapOutside: (PointerDownEvent event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          labelText:
                              AppLocalizations.of(context)!.landmarkRequired,
                          labelStyle: GoogleFonts.notoSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 360,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            overlayColor: Colors.white,
                            backgroundColor: Colors.grey.shade600,
                          ),
                          onPressed: _addAddress,
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            AppLocalizations.of(context)!.saveAddress,
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
