import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'registerstep3.dart';

class RegisterStep2 extends StatefulWidget {
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String password;

  RegisterStep2({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  @override
  _RegisterStep2State createState() => _RegisterStep2State();
}

class _RegisterStep2State extends State<RegisterStep2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController bankAccountController = TextEditingController();
  final TextEditingController industryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Center(
                  child: SvgPicture.asset(
                    'assets/undraw_mobile_payments_re_7udl.svg',
                    height: 200,
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: bankAccountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Bank Account Number',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bank account number is required';
                    } else if (value.length < 10) {
                      return 'Enter a valid bank account number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: industryController,
                  decoration: InputDecoration(
                    hintText: 'Industry',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Industry is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterStep3(
                              firstName: widget.firstName,
                              middleName: widget.middleName,
                              lastName: widget.lastName,
                              email: widget.email,
                              password: widget.password,
                              bankAccount: bankAccountController.text,
                              industry: industryController.text,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
