import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_collaboration_app/routing/routes.dart';
import 'package:project_collaboration_app/ui/auth/register/view_models/register_view_model.dart';
import 'package:project_collaboration_app/utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.viewModel});

  final RegisterViewModel viewModel;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Create an account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Name
                const Text('Username'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'john_edward1',
                  ),
                  validator:
                      (v) =>
                          Validators.validateGenericStringField(v, 'Username'),
                ),
                const SizedBox(height: 16),

                // Email
                const Text('Email'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'myemail@example.com',
                  ),
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 16),

                // Password
                const Text('Password'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter password',
                  ),
                  validator:
                      (v) =>
                          Validators.validateGenericStringField(v, 'Password'),
                ),
                const SizedBox(height: 16),

                // Confirm Password
                const Text('Confirm password'),
                const SizedBox(height: 8),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Re-enter password',
                  ),
                  validator:
                      (v) => Validators.validateConfirmPassword(
                        v,
                        _passwordController.text,
                      ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    FocusScope.of(context).unfocus();
                    widget.viewModel.register(
                      _emailController.text,
                      _passwordController.text,
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Text('Register'),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        context.go(Routes.login);
                      },
                      child: const Text('Log in'),
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
