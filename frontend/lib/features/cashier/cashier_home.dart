import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/providers.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/money_field.dart';
import '../../core/widgets/page_container.dart';
import '../../core/widgets/patient_header.dart';

class CashierHome extends ConsumerStatefulWidget {
  const CashierHome({super.key});

  @override
  ConsumerState<CashierHome> createState() => _CashierHomeState();
}

class _CashierHomeState extends ConsumerState<CashierHome> {
  static const _methods = ['Cash', 'Mobile money', 'Card', 'Insurance'];

  Invoice? _selected;
  String _method = 'Cash';
  final _received = TextEditingController();
  int _receivedAmount = 0;
  bool _busy = false;

  @override
  void dispose() {
    _received.dispose();
    super.dispose();
  }

  void _select(Invoice invoice) {
    setState(() {
      _selected = invoice;
      _method = 'Cash';
      _received.clear();
      _receivedAmount = 0;
    });
  }

  bool get _canConfirm {
    final invoice = _selected;
    if (invoice == null || _busy) return false;
    return _method != 'Cash' || _receivedAmount >= invoice.total;
  }

  Future<void> _confirm() async {
    final invoice = _selected!;
    final messenger = ScaffoldMessenger.of(context);
    final repository = ref.read(clinicRepositoryProvider);

    final ok = await showConfirmDialog(
      context,
      title: 'Confirm payment',
      message: '${formatUgx(invoice.total)} by $_method for '
          '${invoice.patient.name}?',
      confirmLabel: 'Confirm payment',
    );
    if (!ok || !mounted) return;

    setState(() => _busy = true);
    // TODO: for mobile money and card, create the payment request here and
    // wait for the provider webhook before marking the invoice paid.
    await repository.recordPayment(invoiceId: invoice.id, method: _method);
    ref.invalidate(invoicesProvider);

    if (!mounted) return;
    setState(() {
      _selected = null;
      _busy = false;
      _received.clear();
      _receivedAmount = 0;
    });
    messenger.showSnackBar(
      const SnackBar(content: Text('Payment received, receipt printing')),
    );
  }

  String _methodHint() => switch (_method) {
        'Mobile money' => "A payment request will be sent to the patient's phone.",
        'Card' => 'The patient pays on the secure card checkout.',
        'Insurance' => 'The claim is recorded and tracked under the insurer.',
        _ => '',
      };

  Widget _paymentPanel(Invoice invoice) {
    final change = _receivedAmount - invoice.total;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PatientHeader(invoice.patient),
          const SizedBox(height: 16),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final line in invoice.lines)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(child: Text(line.description)),
                        Text(formatUgx(line.amount)),
                      ],
                    ),
                  ),
                const Divider(height: 24),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      formatUgx(invoice.total),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: [
              for (final method in _methods)
                ButtonSegment(value: method, label: Text(method)),
            ],
            selected: {_method},
            onSelectionChanged: (s) => setState(() => _method = s.first),
          ),
          const SizedBox(height: 16),
          if (_method == 'Cash') ...[
            SizedBox(
              width: 320,
              child: MoneyField(
                controller: _received,
                label: 'Amount received',
                onChanged: (value) => setState(() => _receivedAmount = value),
              ),
            ),
            if (_receivedAmount >= invoice.total)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Change to give: ${formatUgx(change)}',
                  style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ] else
            Text(
              _methodHint(),
              style: const TextStyle(color: AppColors.textMuted),
            ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: _canConfirm ? _confirm : null,
              child: const Text('Confirm payment'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _invoiceList(List<Invoice> invoices) {
    if (invoices.isEmpty) return const EmptyState('No unpaid invoices.');

    return ListView.separated(
      itemCount: invoices.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        final selected = _selected?.id == invoice.id;

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _select(invoice),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selected ? AppColors.infoBg : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? AppColors.brand : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invoice.patient.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        invoice.id,
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Text(
                  formatUgx(invoice.total),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final invoices = ref.watch(invoicesProvider);

    return PageContainer(
      title: 'Payments',
      subtitle: 'Unpaid invoices',
      child: invoices.when(
        data: (list) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 380, child: _invoiceList(list)),
            const SizedBox(width: 24),
            Expanded(
              child: _selected == null
                  ? const EmptyState('Select an invoice to take payment.')
                  : _paymentPanel(_selected!),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const ErrorState(),
      ),
    );
  }
}
