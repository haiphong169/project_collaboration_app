import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_collaboration_app/features/auth/presentation/bloc/register_cubit.dart';
import 'package:project_collaboration_app/routing/routes.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';
import 'package:project_collaboration_app/utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.registerCubit});

  final RegisterCubit registerCubit;

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
    return BlocConsumer<RegisterCubit, VoidUiState>(
      bloc: widget.registerCubit,
      listener: (_, __) {},
      builder: (context, state) {
        final isLoading = state is Loading<void>;
        final isError = state is Error<void>;

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
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
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
                          (v) => Validators.validateGenericStringField(
                            v,
                            'Username',
                          ),
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
                          (v) => Validators.validateGenericStringField(
                            v,
                            'Password',
                          ),
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
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                FocusScope.of(context).unfocus();
                                widget.registerCubit.register(
                                  _usernameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child:
                            isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Register'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        widget.registerCubit.signInWithGoogle();
                      },
                      icon: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: Text(
                          'G',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      label: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.0),
                        child: Text('Sign in with Google'),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey.shade300),
                        foregroundColor: Colors.black,
                      ),
                    ),
                    if (isError) ...[
                      const SizedBox(height: 4),
                      Text(
                        state.message,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(color: Colors.red),
                      ),
                    ],
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
      },
    );
  }
}
