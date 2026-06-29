import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:frontend/core/constants/strings.dart';
import 'package:frontend/core/providers/auth_controller.dart';
import 'package:frontend/core/providers/theme_controller.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/data/repositories/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'staff@cuet.edu.bd');
  final _passwordController = TextEditingController(text: 'password');
  bool _loading = false;
  bool _obscurePassword = true;
  String? _bannerError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _bannerError = null;
    });

    final auth = context.read<AuthController>();
    final ok = await auth.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      context.go(auth.homeRouteForRole(auth.user!.role));
      return;
    }

    final message = switch (auth.lastLoginFailure) {
      LoginFailure.accountSuspended =>
        'Account suspended. Contact your branch administrator.',
      _ => 'Invalid email or password.',
    };
    setState(() => _bannerError = message);
  }

  Future<void> _callBloodBank() async {
    final uri = Uri.parse('tel:${AppRoutes.staffBranchHotline}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: () => context.read<ThemeController>().toggle(),
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.bloodtype_rounded, size: 48, color: scheme.primary),
              const SizedBox(height: 12),
              Text(
                'Sign in to ${AppStrings.appName}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),
              if (_bannerError != null) ...[
                MaterialBanner(
                  content: Text(_bannerError!),
                  backgroundColor: scheme.errorContainer,
                  actions: [
                    TextButton(
                      onPressed: () => setState(() => _bannerError = null),
                      child: const Text('Dismiss'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!v.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        onFieldSubmitted: (_) => _signIn(),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Password is required';
                          }
                          if (v.length < 6) {
                            return 'Minimum 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () =>
                              context.push(AppRoutes.forgotPassword),
                          child: const Text(AppStrings.forgotPassword),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: _loading ? null : _signIn,
                        child: _loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text(AppStrings.signIn),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => context.push(AppRoutes.publicRequest),
                child: const Text('Need blood? Request Blood'),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.publicTrack),
                child: const Text('Track an existing request'),
              ),
              TextButton(
                onPressed: _callBloodBank,
                child: Text('Contact blood bank (${AppRoutes.staffBranchHotline})'),
              ),
              Text(
                AppStrings.loginSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.45),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
