import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supa_chat/src/controllers/auth_controller.dart';
import 'package:supa_chat/utils/extension.dart';
import 'package:supa_chat/utils/widgets/state_button.dart';
import 'package:supa_chat/views/chat_home_view.dart';
import 'package:supa_chat/views/register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const LoginView(),
    );
  }

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            children: [
              const Center(
                child: Text('SupaChat',
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
              const SizedBox(height: 30),
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
              const SizedBox(height: 50),
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
                    text: 'LogIn', 
                    isLoading: logIn.isLoading,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await ref.read(authNotifierProvider.notifier).logIn(_emailController.text, _passwordController.text);
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.push(context, RegisterView.route()),
                child: const Text('Register Here'),
              )
            ],
          ),
        ),
      ),
    );
  }
}