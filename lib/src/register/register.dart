import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter_clone/src/register/cubit/register_user_cubit.dart';

import '../../core/api/auth.dart';
import '../../core/constants/appcolors.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final authService = AuthService();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailRegex = RegExp(r'\S+@\S+\.\S+');

  // Initially password is obscure
  bool _obscureText = true;
  bool _obscureTextConfirmPassword = true;
  bool isEmailAlreadyRegistered = false;

  String? Function(String?)? get validator => (value) {
        if (value == null || value.isEmpty) {
          return 'Email cannot be empty';
        }
        if (!emailRegex.hasMatch(value)) {
          return 'Email is not valid';
        }
        return null;
      };

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleConfirmPassword() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return BlocConsumer<RegisterUserCubit, RegisterUserState>(
      listener: (context, state) {
        switch (state) {
          case RegisterUserState.success:
            Navigator.pushNamed(context, "/dashboard");
            break;
          case RegisterUserState.user_exists:
            break;
          case RegisterUserState.weak_password:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please use a stronger password'),
              ),
            );
            break;
          case RegisterUserState.failed:
            break;
          case RegisterUserState.initial:
            break;
        }
      },
      builder: (context, state) {
        if (state == RegisterUserState.failed) {
          return const Scaffold(
              body: Center(
                  child: Text('Oops something went wrong!\nTry again later.')));
        }
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Sign Up",
            ),
          ),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: nameController,
                    autocorrect: false,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name cannot be empty';
                      } else if (value.length < 6) {
                        return 'name too short.';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    style: textTheme.titleMedium!.copyWith(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Enter Name',
                      hintStyle: textTheme.titleMedium!.copyWith(fontSize: 16),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          width: 0,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                      ),
                      fillColor: Colors.grey.withAlpha(50),
                      filled: true,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: emailController,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      // if (value == null || value.isEmpty) {
                      //   return 'Please enter email address';
                      // }
                      return validator?.call(value);
                    },
                    onChanged: (value) {
                      // clear submission error of email field
                      setState(() {
                        isEmailAlreadyRegistered = false;
                      });
                    },
                    textInputAction: TextInputAction.next,
                    style: textTheme.titleMedium!.copyWith(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Enter Email',
                      hintStyle: textTheme.titleMedium!.copyWith(fontSize: 16),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          width: 0,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                      ),
                      fillColor: Colors.grey.withAlpha(50),
                      filled: true,
                      errorText: isEmailAlreadyRegistered
                          ? 'Email address is already registered'
                          : null,
                      // you can also define different border styles for different states
                      // e.g. when the field is enabled / focused / has error
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: _obscureText,
                    controller: passwordController,
                    autocorrect: false,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty';
                      } else if (value.length < 8) {
                        return 'Password too short.';
                      }
                      return null;
                    },
                    style: textTheme.titleMedium!.copyWith(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      hintStyle: textTheme.titleMedium!.copyWith(fontSize: 16),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          width: 0,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                      ),
                      fillColor: Colors.grey.withAlpha(50),
                      filled: true,
                      suffixIcon: IconButton(
                        icon: _obscureText
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: _toggle,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: _obscureTextConfirmPassword,
                    controller: confirmPasswordController,
                    autocorrect: false,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty';
                      } else if (value.length < 8) {
                        return 'Password too short.';
                      } else if (value != passwordController.text) {
                        return 'Confirm password not matching';
                      }
                      return null;
                    },
                    style: textTheme.titleMedium!.copyWith(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Enter Confirm Password',
                      hintStyle: textTheme.titleMedium!.copyWith(fontSize: 16),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          width: 0,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                      ),
                      fillColor: Colors.grey.withAlpha(50),
                      filled: true,
                      suffixIcon: IconButton(
                        icon: _obscureTextConfirmPassword
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: _toggleConfirmPassword,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          context.read<RegisterUserCubit>().registerUser(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text);
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.white,
                        elevation: 2,
                        backgroundColor: AppColors.blue,
                      ),
                      child: Text(
                        "Register",
                        style: textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
