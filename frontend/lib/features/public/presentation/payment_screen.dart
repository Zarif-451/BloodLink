import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend/data/models/payment.dart';
import 'package:frontend/data/models/public_request_submission.dart';
import 'package:frontend/data/repositories/payment_repository.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.paymentId});

  final int paymentId;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Payment? _payment;
  bool _loading = true;
  bool _confirming = false;
  PaymentMethod _method = PaymentMethod.cashAtBranch;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final payment =
        await context.read<PaymentRepository>().getPayment(widget.paymentId);
    if (!mounted) return;
    setState(() {
      _payment = payment;
      _loading = false;
    });
  }

  Future<void> _confirm() async {
    if (_payment == null) return;
    setState(() => _confirming = true);
    await context.read<PaymentRepository>().confirmPayment(_payment!.id);
    if (!mounted) return;
    setState(() => _confirming = false);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment recorded'),
        content: const Text(
          'Your payment has been marked as received (mock). Staff will confirm at the branch.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    final requestId = _payment!.requestId;
    if (requestId != null) {
      context.go('/public/track/$requestId');
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_payment == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: const Center(child: Text('Payment not found')),
      );
    }

    final payment = _payment!;
    final requestLabel = payment.requestId != null
        ? PublicRequestId.format(payment.requestId!)
        : '—';

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            '৳${payment.amount.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(payment.reason ?? 'Blood request fee'),
          const SizedBox(height: 16),
          Text('Request $requestLabel'),
          const Divider(height: 32),
          Text(
            'Payment method (demo)',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          RadioGroup<PaymentMethod>(
            groupValue: _method,
            onChanged: (v) {
              if (v != null) setState(() => _method = v);
            },
            child: Column(
              children: [
                RadioListTile<PaymentMethod>(
                  title: const Text('Cash at branch'),
                  value: PaymentMethod.cashAtBranch,
                ),
                const RadioListTile<PaymentMethod>(
                  title: Text('Mobile banking (coming soon)'),
                  subtitle: Text('bKash / Nagad integration planned'),
                  value: PaymentMethod.mobileBanking,
                  enabled: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _confirming || _method != PaymentMethod.cashAtBranch
                ? null
                : _confirm,
            child: _confirming
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Confirm payment'),
          ),
          const SizedBox(height: 8),
          Text(
            'You can also pay in person at the blood bank branch.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

enum PaymentMethod { cashAtBranch, mobileBanking }
