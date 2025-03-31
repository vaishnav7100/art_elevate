import 'dart:async';

import 'package:art_elevate/pages/mainpage/username.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class otpForm extends StatefulWidget {
  final String phone;
  const otpForm({super.key, required this.phone});

  @override
  State<otpForm> createState() => _otpFormState();
}

class _otpFormState extends State<otpForm> {
  int secondsRemaining = 30;
  bool enableResend = false;
  late Timer timer;
  @override
  initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  'Verification',
                  style: GoogleFonts.anekBangla(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Enter the code sent to the number',
                  style: GoogleFonts.anekBangla(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.phone,
                  style: GoogleFonts.anekBangla(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Pinput(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onTapOutside: (PointerDownEvent event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    errorBuilder: (errorText, pin) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Text(
                            errorText ?? "",
                            style: GoogleFonts.anekBangla(
                                color: Colors.red[600], fontSize: 16),
                          ),
                        ),
                      );
                    },
                    closeKeyboardWhenCompleted: true,
                    validator: (value) {
                      if (value?.length == 4) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Username(),
                          ),
                        );
                      }
                      return 'Pin is incorrect';
                    },
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     if (_formKey.currentState!.validate() == true) {
                  //       Navigator.pushReplacement(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => Username(phone: widget.phone),
                  //         ),
                  //       );
                  //     }
                  //   },
                  // )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: TextButton(
                  style: const ButtonStyle(),
                  onPressed: enableResend ? _resendCode : null,
                  child: Text(
                    'Resend Code after $secondsRemaining seconds',
                    style: GoogleFonts.anekBangla(
                        fontSize: 18, color: Colors.black),
                  )),
            ),
            // Text(
            //   textAlign: TextAlign.center,
            //   "after $secondsRemaining seconds",
            //   style: GoogleFonts.anekBangla(
            //     fontSize: 19,
            //     fontWeight: FontWeight.w400,
            //     color: Colors.black
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _resendCode() {
    setState(() {
      secondsRemaining = 30;
      enableResend = false;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
