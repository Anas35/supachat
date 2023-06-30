import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supa_chat/src/controllers/auth_controller.dart';
import 'package:supa_chat/utils/extension.dart';
import 'package:supa_chat/utils/widgets/state_button.dart';
import 'package:supa_chat/views/chat_home_view.dart';

class RegisterView extends StatefulWidget {

  const RegisterView({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const RegisterView(),
    );
  }

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            children: [
              const Center(
                child: Text('Create New Account',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 75),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  label: Text('Email'),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text('Password'),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Required';
                  }
                  if (val.length < 6) {
                    return '6 characters minimum';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  label: Text('Username'),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Required';
                  }
                  final isValid = RegExp(r'^[A-Za-z0-9_]{3,24}$').hasMatch(val);
                  if (!isValid) {
                    return '3-24 long with alphanumeric or underscore';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 60),
              Consumer(
                builder: (context, ref, child) {
                  ref.listen(authNotifierProvider, (previous, next) {
                    next.handleListen(
                      data: () => Navigator.pushAndRemoveUntil(context, ChatHomeView.route(), (route) => false), 
                      error: (error) => context.snackBar(error),
                    );           
                  });
                  final logIn = ref.watch(authNotifierProvider);
                  return StateButton(
                    text: 'Register', 
                    isLoading: logIn.isLoading,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await ref.read(authNotifierProvider.notifier).signIn(
                          _emailController.text, 
                          _passwordController.text,
                          _usernameController.text,  
                        );
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('I already have an account'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
