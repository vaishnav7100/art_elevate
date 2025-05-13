import 'package:art_elevate/views/pages/otpform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneForm extends StatefulWidget {
  const PhoneForm({super.key});

  @override
  State<PhoneForm> createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> {
  final TextEditingController _PhoneNumberController = TextEditingController();
  String enteredPhoneNumber = '';

  @override
  void dispose() {
    _PhoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        title: Text(
          'Register',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          // Text(
          //   'Register',
          //   textAlign: TextAlign.end,
          //   style: GoogleFonts.robotoMono(
          //       fontSize: 30, fontWeight: FontWeight.w700),
          // ),
          const SizedBox(
            height: 20,
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              'Enter your phone number and \n  request otp to get verified',
              style: GoogleFonts.notoSans(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Image.asset(
            'assets/smartphone.png',
            height: 155,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Container(
              height: 95,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0xffd9d9d9),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: IntlPhoneField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                  ),
                  showDropdownIcon: false,
                  initialCountryCode: 'IN',
                  onChanged: (phone) {
                    setState(() {
                      enteredPhoneNumber = phone.number;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 55,
            width: 170,
            child: ElevatedButton(
              onPressed: enteredPhoneNumber.length == 10
                  ? () {
                      String phone = enteredPhoneNumber;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => otpForm(phone: phone),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shadowColor: const Color(0xffd9d9d9),
              ),
              child: Container(
                child: Text(
                  'VERIFY',
                  style: GoogleFonts.poppins(
                      letterSpacing: 1,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
