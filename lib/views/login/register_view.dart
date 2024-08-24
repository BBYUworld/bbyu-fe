import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _gender = 'male';

  Future<void> _sendVerificationCode() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email first')),
      );
      return;
    }

    // TODO: Implement email verification code sending logic
    print('Sending verification code to ${_emailController.text}');
  }

  Future<void> _register() async {
    final response = await http.post(
      Uri.parse('YOUR_API_ENDPOINT'),
      body: json.encode({
        'email': _emailController.text,
        'verificationCode': _verificationCodeController.text,
        'password': _passwordController.text,
        'name': _nameController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'gender': _gender,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // TODO: Handle successful registration
      print('Registration successful');
    } else {
      // TODO: Handle registration failure
      print('Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _verificationCodeController,
                    decoration: InputDecoration(labelText: 'Verification Code'),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendVerificationCode,
                  child: Text('Send Code'),
                ),
              ],
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 16),
            Text('Gender:'),
            Row(
              children: [
                Radio(
                  value: 'male',
                  groupValue: _gender,
                  onChanged: (value) => setState(() => _gender = value.toString()),
                ),
                Text('Male'),
                Radio(
                  value: 'female',
                  groupValue: _gender,
                  onChanged: (value) => setState(() => _gender = value.toString()),
                ),
                Text('Female'),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}