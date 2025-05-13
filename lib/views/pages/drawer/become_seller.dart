import 'dart:developer';

import 'package:art_elevate/views/constant.dart';
import 'package:art_elevate/views/mainpage/bottom_nav.dart';
import 'package:art_elevate/views/pages/drawer/policies/terms.dart';
import 'package:art_elevate/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import 'dart:async';

class BecomeSellerPage extends StatefulWidget {
  const BecomeSellerPage({super.key});

  @override
  State<BecomeSellerPage> createState() => _BecomeSellerPageState();
}

class _BecomeSellerPageState extends State<BecomeSellerPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _upiController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    checkPayment();

    _nameController.text = user?.displayName ?? '';
    _emailController.text = user?.email ?? '';
  }

  bool checked = false;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  String _selectedUnit = 'cm';
  final List<String> _units = ['cm', 'inches', 'mm'];
  String itemSize = '';

  void clearImage() {
    setState(() {
      selectedImage = null;
    });
  }

  Future<void> _onSubmit(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BottomNavBar()));
        });
        return AlertDialog(
          titlePadding: const EdgeInsets.all(30),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            AppLocalizations.of(context)!.artwork_verification_message,
            style: GoogleFonts.poppins(
              wordSpacing: 2.5,
              letterSpacing: 1,
              fontSize: 18,
            ),
          ),
        );
      },
    );
  }

  List<String> categoryItem = [
    'Graphite Pencil Portrait',
    'Colour Pencil Portrait',
    'Charcoal Pencil Portrait',
    'Vector art',
    'Watercolor',
    'Stencil art',
    'Pen Portrait',
  ];
  bool isUploading = false;
  String? value; // Track upload state

  Future<void> _alert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });
        return checked == true
            ? AlertDialog(
                titlePadding: const EdgeInsets.all(30),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text(
                  AppLocalizations.of(context)!.fill_upload_image_message,
                  style: GoogleFonts.poppins(
                    letterSpacing: 1,
                    fontSize: 18,
                  ),
                ),
              )
            : AlertDialog(
                titlePadding: const EdgeInsets.all(30),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text(
                  AppLocalizations.of(context)!.accept_terms_message,
                  style: GoogleFonts.poppins(
                    letterSpacing: 1,
                    fontSize: 18,
                  ),
                ),
              );
      },
    );
  }

  List<String> art = [
    'Graphite Pencil Portrait',
    'Colour Pencil Portrait',
    'Charcoal Pencil Portrait',
    'Vector art',
    'Watercolor',
    'Stencil art',
    'Pen Portrait',
  ];

  uploadItem() async {
    if (selectedImage != null && _priceController.text != "") {
      try {
        String addId =
            randomAlphaNumeric(10); // Generate a unique ID for the artwork
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child("artWork").child(addId);

        // Uploading image to Firebase Storage
        final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

        // Wait for the task to complete and get the download URL
        final snapshot = await task;
        if (snapshot.state == TaskState.success) {
          var downloadUrl = await snapshot.ref.getDownloadURL();
          itemSize =
              "${_heightController.text}x${_widthController.text} $_selectedUnit";
          // Prepare data to save to Firestore
          Map<String, dynamic> addProduct = {
            "username": _emailController.text,
            "title": value,
            "image": downloadUrl,
            "price": _priceController.text,
            "itemSize": itemSize,
            "itemDescription": _descriptionController.text,
            "itemRating": 0,
            "approved": false,
            "createdAt": FieldValue.serverTimestamp(),
          };
          User? user = FirebaseAuth.instance.currentUser;
          // Save data to Firestore
          await DatabaseMethods()
              .addProduct(addProduct, value!, user!.uid)
              .then((artworkId) async {
            addProduct["artworkId"] = artworkId;

            // Clear inputs and provide feedback
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({'role': 'seller'});
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('payment')
                .add({
              "upiId": _upiController.text,
              "phoneNumber": _phoneController.text,
            });
            setState(() {
              selectedImage = null;
              _priceController.text = "";
              _descriptionController.text = "";
              _widthController.text = "";
              _heightController.text = "";
              _phoneController.text = "";
              _upiController.text = "";
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(AppLocalizations.of(context)!.artworkAddedSuccess),
                behavior: SnackBarBehavior.floating,
              ),
            );
          });
        } else {
          throw Exception('Failed to upload image');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.artwork_upload_error)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)!.image_select_and_price_message)),
      );
    }
  }

  bool hasPayment = false;

  checkPayment() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('payment')
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          hasPayment = true;
        });
      } else {
        setState(() {
          hasPayment = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: kprimaryColor,
        title: const Text(
          'Sell your Artwork',
        ),
        titleTextStyle: GoogleFonts.poppins(
            color: Colors.black, fontSize: 21, fontWeight: FontWeight.w500),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        AppLocalizations.of(context)!.welcome_message,
                        style: const TextStyle(
                            fontSize: 22.0, wordSpacing: 1, letterSpacing: 1),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Text(
                      AppLocalizations.of(context)!.artwork_submission,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 5.0, top: 6, bottom: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white70, // White text
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(
                              color: Colors.black.withOpacity(0.5), width: 1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ).copyWith(
                          shadowColor: WidgetStateProperty.all(
                              Colors.black.withOpacity(0.3)),
                        ),
                        onPressed: getImage,
                        child: Text(
                          AppLocalizations.of(context)!.upload_artwork,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    selectedImage != null
                        ? Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black54),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: clearImage,
                                icon: const Icon(Icons.close),
                              )
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            child: Text(
                              AppLocalizations.of(context)!.no_image_selected,
                              style: GoogleFonts.poppins(color: Colors.black),
                            ),
                          ),
                    const SizedBox(height: 15.0),
                    Text(
                      AppLocalizations.of(context)!.title_for_artwork,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelText:
                                AppLocalizations.of(context)!.select_title,
                            labelStyle: GoogleFonts.notoSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w300)),
                        dropdownColor: Colors.white,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.selectTitle;
                          }
                          return null;
                        },
                        value: value, // The current selected item from the list
                        onChanged: (value) {
                          setState(() {
                            this.value = value;
                          });
                        },

                        items: categoryItem
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    Text(
                      AppLocalizations.of(context)!.price_of_artwork,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLength: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.enterPrice;
                          }
                          return null;
                        },
                        controller: _priceController,
                        cursorColor: Colors.black,
                        cursorWidth: 1,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.black),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: AppLocalizations.of(context)!.price,
                        ),
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Size of your artwork',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            maxLength: _selectedUnit == 'mm' ? 4 : 3,
                            controller: _heightController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            cursorColor: Colors.black,
                            cursorWidth: 1,
                            buildCounter: (context,
                                    {required currentLength,
                                    required isFocused,
                                    required maxLength}) =>
                                null,
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(color: Colors.black),
                              labelText: 'Height',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the height';
                              }
                              return null;
                            },
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            maxLength: _selectedUnit == 'mm' ? 4 : 3,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            buildCounter: (context,
                                    {required currentLength,
                                    required isFocused,
                                    required maxLength}) =>
                                null,
                            controller: _widthController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            cursorColor: Colors.black,
                            cursorWidth: 1,
                            decoration: InputDecoration(
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                labelText: 'Width',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                )),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the width';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: DropdownButtonFormField<String>(
                            dropdownColor: Colors.white,
                            value: _selectedUnit,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedUnit = newValue!;
                              });
                            },
                            items: _units
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                labelText: 'Unit',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    Text(
                      'Short description of your artwork',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        maxLength: 150,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter short description';
                          }
                          if (value.length <= 15) {
                            return 'Description should be more than 15 characters';
                          }
                          return null;
                        },
                        controller: _descriptionController,
                        cursorColor: Colors.black,
                        cursorWidth: 1,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Description',
                        ),
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    if (!hasPayment)
                      Text(
                        'Payment',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (!hasPayment)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
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
                    if (!hasPayment)
                      const SizedBox(
                        height: 10,
                      ),
                    if (!hasPayment)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textInputAction: TextInputAction.next,
                          maxLength: 10,
                          keyboardType: TextInputType
                              .phone, // For phone number input type
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            // Adjust this length check to fit the valid phone number length for your region
                            if (value.length < 10 || value.length > 15) {
                              return 'Phone number should be between 10 and 15 digits';
                            }
                            // Regex pattern for validating phone numbers (works for several formats)
                            final RegExp regex = RegExp(r'^\+?[1-9]\d{1,14}$');
                            if (!regex.hasMatch(value)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                          controller:
                              _phoneController, // Make sure this is the correct controller for the phone number
                          cursorColor: Colors.black,
                          cursorWidth: 1,
                          decoration: const InputDecoration(
                            counterText: '',
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'Phone Number', // Label text updated
                          ),
                          scrollPadding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        ),
                      ),

                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Note: You will get the payment only after you deliver the artwork to the customer.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Text(
                      AppLocalizations.of(context)!.seller_agreement,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    // Agreement checkbox
                    CheckboxListTile(
                      activeColor: Colors.black87,
                      title: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: AppLocalizations.of(context)!.agreeToTerms,
                          style: GoogleFonts.notoSans(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!
                                  .termsAndConditions,
                              style: GoogleFonts.notoSans(
                                  color: Colors.blue[900],
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TermsAndConditions(),
                                    ),
                                  );
                                },
                            )
                          ],
                        ),
                      ),
                      value: checked,
                      onChanged: (bool? value) {
                        setState(() {
                          checked = !checked;
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: SizedBox(
                        height: 50,
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            overlayColor: Colors.white,
                            backgroundColor: Colors.white, // White text
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(
                                color: Colors.black54, width: 1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ).copyWith(
                            shadowColor: WidgetStateProperty.all(
                                Colors.black.withOpacity(0.3)),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (checked == true) {
                                setState(() {
                                  isUploading = true;
                                });
                                await uploadItem();
                                setState(() {
                                  isUploading = false;
                                });
                              } else {
                                _alert(context);
                              }
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.submit_application,
                            style: GoogleFonts.roboto(
                              letterSpacing: .9,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              .animate(delay: const Duration(milliseconds: 10))
              .fade(begin: 0, end: 1),
          if (isUploading)
            const Center(
              // Centers it horizontally
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.black), // Progress color
                backgroundColor: Colors.white, // Background color of the circle
                strokeWidth: 4.0,
              ),
            ),
        ],
      ),
    );
  }
}
