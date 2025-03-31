import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class EditArtworkPopup extends StatefulWidget {
  final String documentId;
  final String currentCategory;
  final String currentTitle;
  final String currentPrice;
  final String currentSize;
  final String currentDescription;

  const EditArtworkPopup({
    super.key,
    required this.documentId,
    required this.currentCategory,
    required this.currentTitle,
    required this.currentPrice,
    required this.currentSize,
    required this.currentDescription,
  });

  @override
  _EditArtworkPopupState createState() => _EditArtworkPopupState();
}

class _EditArtworkPopupState extends State<EditArtworkPopup> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _sizeController;
  late TextEditingController _descriptionController;
  late TextEditingController _heightController;
  late TextEditingController _widthController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.currentTitle);
    _priceController = TextEditingController(text: widget.currentPrice);
    _descriptionController =
        TextEditingController(text: widget.currentDescription);
    _selectedUnit = 'cm';
    List<String> sizeParts = widget.currentSize.split('x');

    if (sizeParts.length == 2) {
      // Initialize height and width controllers
      _heightController = TextEditingController(text: sizeParts[0].trim());
      _widthController = TextEditingController(
          text: sizeParts[1]
              .replaceAll(RegExp(r'\D'), '')
              .trim()); // Remove non-numeric characters

      // Initialize _sizeController with formatted size
      _sizeController = TextEditingController(
          text:
              "${_heightController.text}x${_widthController.text} $_selectedUnit");
      if (widget.currentSize.contains('cm')) {
        _selectedUnit = 'cm';
      } else if (widget.currentSize.contains('inches')) {
        _selectedUnit = 'inches';
      } else if (widget.currentSize.contains('mm')) {
        _selectedUnit = 'mm';
      } else {
        _selectedUnit = 'cm'; // Default unit if none found
      }
    } else {
      // Handle case where size isn't in the expected format
      _heightController =
          TextEditingController(text: ''); // Default value or empty string
      _widthController =
          TextEditingController(text: ''); // Default value or empty string
      _sizeController = TextEditingController(text: '');
      _selectedUnit = 'cm'; // Default value or empty string
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _sizeController.dispose();
    _descriptionController.dispose();
    _heightController.dispose();
    _widthController.dispose();
    super.dispose();
  }

  late String _selectedUnit;
  final List<String> _units = ['cm', 'inches', 'mm'];

  Future<void> updateArtwork() async {
    String itemSize =
        "${_heightController.text}x${_widthController.text} $_selectedUnit";
    try {
      await FirebaseFirestore.instance
          .collection(widget.currentCategory)
          .doc(widget.documentId)
          .update({
        'title': _titleController.text,
        'price': _priceController.text,
        'itemSize': itemSize,
        'itemDescription': _descriptionController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Artwork updated successfully"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Close the dialog after update
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
        "Edit Artwork details",
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
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                " ${widget.currentTitle}",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  return null;
                },
                controller: _priceController,
                cursorColor: Colors.black,
                cursorWidth: 1,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: 'Price',
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
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.black),
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
                SizedBox(
                  width: 95,
                  child: DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: _selectedUnit,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedUnit = newValue!;
                      });
                    },
                    items: _units.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.black),
                        labelText: 'Unit',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
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
            const SizedBox(height: 20),
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
              updateArtwork();
            }
          },
          child: const Text(
              style: TextStyle(color: Colors.black, fontSize: 17), "Save"),
        ),
      ],
    );
  }
}
