// dart packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/utils/global.dart';
// ui libraries
import 'package:rando/utils/theme/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _codeSent = false;
  bool isLoading = false;
  String? _verificationId;

  Future<void> _sendCode() async {
    setState(() {
      isLoading = true;
    });

    verificationCompleted(AuthCredential credential) async {
      await _auth.signInWithCredential(credential);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Phone number automatically verified and user signed in: ${_auth.currentUser?.uid}",
            ),
          ),
        );
      }
    }

    verificationFailed(FirebaseAuthException exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Phone number verification failed. Code: ${exception.code}. Message: ${exception.message}",
          ),
        ),
      );
      setState(() {
        isLoading = false;
      });
    }

    codeSent(String verificationId, [int? forceResendingToken]) async {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please check your phone for the verification code."),
        ),
      );
      setState(() {
        _verificationId = verificationId;
        _codeSent = true;
        isLoading = false;
      });
    }

    codeAutoRetrievalTimeout(String verificationId) {
      _verificationId = verificationId;
      setState(() {
        isLoading = false;
      });
    }

    await AuthService().verifyPhone(
      phoneNumber: _phoneController.text.trim(),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<void> _signInWithPhoneNumber() async {
    final code = _codeController.text.trim();
    try {
      await AuthService().signInWithOTP(code, _verificationId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to sign in $e"),
          ),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            // center on screen
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Center(
                child: Text(
                  "Locals Only",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 128,
                  width: 128,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    image: DecorationImage(
                      image: AssetImage(Theme.of(context).defaultImagePath),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  !_codeSent
                      ? TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: "Phone Number",
                          ),
                        )
                      : TextField(
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Verification Code",
                          ),
                        ),
                  const SizedBox(height: 16.0),
                  LoginButton(
                    inverted: true,
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      if (!_codeSent) {
                        await _sendCode();
                      } else {
                        await _signInWithPhoneNumber();
                      }
                      // !_codeSent ? _sendCode : _signInWithPhoneNumber;
                    },
                    text: isLoading
                        ? "Loading"
                        : !_codeSent
                            ? "Send Code"
                            : "Sign In",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final IconData? icon;
  final bool inverted;
  final String? text;
  final double? vertical;
  final double? horizontal;
  final Future<void> Function()? onTap;
  const LoginButton({
    super.key,
    this.icon,
    this.text,
    this.vertical,
    this.horizontal,
    required this.inverted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal == null ? 15 : horizontal!,
          vertical: vertical == null ? 10 : vertical!,
        ),
        elevation: 10,
        shadowColor: Colors.black,
        backgroundColor: inverted
            ? Theme.of(context).accentColor
            : Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          icon != null
              ? Icon(
                  icon,
                  color: inverted
                      ? Theme.of(context).inverseTextColor
                      : Theme.of(context).textColor,
                  size: 18,
                )
              : const SizedBox.shrink(),
          text != null && icon != null
              ? const SizedBox(width: 10)
              : const SizedBox.shrink(),
          text != null
              ? Text(
                  text!,
                  style: TextStyle(
                    color: inverted
                        ? Theme.of(context).inverseTextColor
                        : Theme.of(context).textColor,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
