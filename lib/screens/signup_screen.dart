// import 'package:escrow_app/screens/contract_screen.dart';
// import 'package:escrow_app/screens/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/auth_service.dart';

// class SignUpScreen extends StatelessWidget {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _middleNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _bankAccountController = TextEditingController();
//   final TextEditingController _industryController = TextEditingController();
//   final TextEditingController _profilePictureController =
//       TextEditingController();

//   SignUpScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign Up')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               TextField(
//                 controller: _firstNameController,
//                 decoration: const InputDecoration(labelText: 'First Name'),
//                 keyboardType: TextInputType.name,
//               ),
//               TextField(
//                 controller: _middleNameController,
//                 decoration:
//                     const InputDecoration(labelText: 'Middle Name (Optional)'),
//                 keyboardType: TextInputType.name,
//               ),
//               TextField(
//                 controller: _lastNameController,
//                 decoration: const InputDecoration(labelText: 'Last Name'),
//                 keyboardType: TextInputType.name,
//               ),
//               TextField(
//                 controller: _bankAccountController,
//                 decoration:
//                     const InputDecoration(labelText: 'Bank Account Number'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: _industryController,
//                 decoration: const InputDecoration(labelText: 'Industry'),
//                 keyboardType: TextInputType.text,
//               ),
//               TextField(
//                 controller: _profilePictureController,
//                 decoration: const InputDecoration(
//                     labelText: 'Profile Picture URL (Optional)'),
//                 keyboardType: TextInputType.url,
//               ),
//               TextField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//               ),
//               TextField(
//                 controller: _confirmPasswordController,
//                 decoration:
//                     const InputDecoration(labelText: 'Confirm Password'),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   final email = _emailController.text.trim();
//                   final firstName = _firstNameController.text.trim();
//                   final middleName = _middleNameController.text.trim();
//                   final lastName = _lastNameController.text.trim();
//                   final bankAccount = _bankAccountController.text.trim();
//                   final industry = _industryController.text.trim();
//                   final profilePicture = _profilePictureController.text.trim();
//                   final password = _passwordController.text.trim();
//                   final confirmPassword =
//                       _confirmPasswordController.text.trim();

//                   if (password != confirmPassword) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Passwords do not match!')),
//                     );
//                     return;
//                   }

//                   try {
//                     await authService.signUp(
//                       email: email,
//                       password: password,
//                       firstName: firstName,
//                       middleName: middleName,
//                       lastName: lastName,
//                       bankAccount: bankAccount,
//                       industry: industry,
//                       profilePicture: profilePicture,
//                     );

//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const ContractScreen(),
//                       ),
//                     );
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Sign up failed: $e')),
//                     );
//                   }
//                 },
//                 child: const Text('Sign Up'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => LoginScreen(),
//                     ),
//                   );
//                 },
//                 child: const Text('Already have an account? Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'registerstep1.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RegisterStep1();
  }
}
