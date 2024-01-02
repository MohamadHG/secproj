import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(),
              _inputField(context),
              _forgotPassword(context),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        Image.asset('assets/ivqvug_2.png', width: 250, height: 250,),
        Text(
          "Welcome Back",
          style: GoogleFonts.poppins(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Enter your credentials to login",
          style: GoogleFonts.poppins(fontSize: 18),
        ),
      ],
    );
  }


  Widget _inputField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Colors.black),
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: Container(
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
          ),
          cursorColor: Colors.black,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Colors.black),
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: Container(
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.lock,
                color: Colors.black,
              ),
            ),
            suffixIcon: InkWell(
              onTap: _togglePasswordView,
              child: Icon(
                _isObscure ? Icons.visibility : Icons.visibility_off,
                color: Colors.black,
              ),
            ),
          ),
          obscureText: _isObscure,
          cursorColor: Colors.black,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _login(context, emailController.text, passwordController.text);
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.black,
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void _login(BuildContext context, String email, String password) {
    Uri url = Uri.parse('https://presentable-recruit.000webhostapp.com/login.php');
    var data = {
      'email': email,
      'password': password,
    };

    http.post(url, body: data).then((response) {
      if (response.statusCode == 200) {
        if (response.body == 'Login successful') {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
      }
    }).catchError((error) {
      print(error);
    });
  }

  Widget _forgotPassword(BuildContext context) {
    return TextButton(
      onPressed: () {
      },
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/signup');
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(const LoginPage());
}
