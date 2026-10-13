import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:booking_app/core/di/di.dart';
import 'package:booking_app/features/booking/domain/entities/booking_cost.dart';
import 'package:booking_app/features/booking/domain/entities/time_slot.dart';
import 'package:booking_app/features/booking/domain/usecases/create_booking_usecase.dart';
import 'package:booking_app/features/booking/domain/validators/booking_validators.dart';
import 'package:booking_app/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:booking_app/features/booking/presentation/booking_confirmation_page.dart';
import 'package:booking_app/features/booking/presentation/widgets/cost_breakdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key, required this.provider});

  final ProviderEntity provider;

  static Route<void> route(ProviderEntity provider) =>
      MaterialPageRoute(builder: (_) => BookingPage(provider: provider));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookingBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Book a service')),
        body: _BookingForm(provider: provider),
      ),
    );
  }
}

class _BookingForm extends StatefulWidget {
  const _BookingForm({required this.provider});

  final ProviderEntity provider;

  @override
  State<_BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<_BookingForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _description = TextEditingController();

  DateTime? _date;
  TimeSlot? _slot;
  int _hours = BookingValidators.minHours;

  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickDate(FormFieldState<DateTime> field) async {
    final now = DateTime.now();
    final first = BookingValidators.firstBookableDate(now);
    var initial = _date ?? first;
    while (!BookingValidators.isBookableDay(initial)) {
      initial = DateTime(initial.year, initial.month, initial.day + 1);
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: BookingValidators.lastBookableDate(now),
      selectableDayPredicate: BookingValidators.isBookableDay,
      helpText: 'Select booking date',
    );
    if (picked == null || !mounted) return;

    setState(() => _date = picked);
    field.didChange(picked);
    context.read<BookingBloc>().add(
      BookedSlotsRequested(widget.provider.id, picked),
    );
  }

  void _submit() {
    setState(() => _autovalidate = AutovalidateMode.always);
    if (!_formKey.currentState!.validate()) return;

    context.read<BookingBloc>().add(
      BookingSubmitted(
        CreateBookingParams(
          providerId: widget.provider.id,
          customerName: _name.text.trim(),
          phone: BookingValidators.normalizePhone(_phone.text),
          address: _address.text.trim(),
          date: _date!,
          timeSlot: _slot!,
          estimatedHours: _hours,
          description: _description.text.trim(),
        ),
      ),
    );
  }

  void _onStateChanged(BuildContext context, BookingState state) {
    final messenger = ScaffoldMessenger.of(context);

    if (_slot != null &&
        state.bookedSlots.contains(_slot) &&
        state.status != BookingStatus.success) {
      setState(() => _slot = null);
    }

    if (state.errorMessage != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(state.errorMessage!),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }

    if (state.status == BookingStatus.success && state.booking != null) {
      Navigator.of(context).pushReplacement(
        BookingConfirmationPage.route(widget.provider, state.booking!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<BookingBloc, BookingState>(
      listener: _onStateChanged,
      child: Form(
        key: _formKey,
        autovalidateMode: _autovalidate,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ProviderSummary(provider: widget.provider),
            const SizedBox(height: 24),
            Text('Your details', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Customer name',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: BookingValidators.name,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phone,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                hintText: '07XXXXXXXX or +947XXXXXXXX',
                prefixIcon: Icon(Icons.phone_outlined),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s-]')),
              ],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: BookingValidators.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _address,
              decoration: const InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.home_outlined),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              minLines: 2,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: BookingValidators.address,
            ),
            const SizedBox(height: 24),
            Text('Schedule', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            _buildDateField(),
            const SizedBox(height: 16),
            _buildTimeSlotField(),
            const SizedBox(height: 16),
            _buildHoursField(),
            const SizedBox(height: 24),
            Text('Job', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: 'Job description',
                hintText: 'Describe the work you need done',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              minLines: 3,
              maxLines: 6,
              maxLength: BookingValidators.maxDescriptionLength,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: BookingValidators.description,
            ),
            const SizedBox(height: 16),
            CostBreakdown(
              hourlyRate: widget.provider.hourlyRate,
              hours: _hours,
              cost: BookingCost.calculate(
                hourlyRate: widget.provider.hourlyRate,
                hours: _hours,
                date: _date,
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<BookingBloc, BookingState>(
              buildWhen: (a, b) => a.status != b.status,
              builder: (context, state) {
                final submitting = state.status == BookingStatus.submitting;
                return FilledButton(
                  onPressed: submitting ? null : _submit,
                  child: submitting
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Confirm booking'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return FormField<DateTime>(
      validator: (_) => BookingValidators.date(_date, now: DateTime.now()),
      builder: (field) {
        final text = _date == null
            ? null
            : MaterialLocalizations.of(context).formatFullDate(_date!);
        return InkWell(
          onTap: () => _pickDate(field),
          borderRadius: BorderRadius.circular(4),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Date',
              hintText: 'Select a date',
              prefixIcon: const Icon(Icons.calendar_today_outlined),
              suffixIcon: const Icon(Icons.arrow_drop_down),
              border: const OutlineInputBorder(),
              helperText: 'Tomorrow up to 30 days ahead, except Sundays',
              errorText: field.errorText,
            ),
            isEmpty: text == null,
            child: text == null ? null : Text(text),
          ),
        );
      },
    );
  }

  Widget _buildTimeSlotField() {
    return FormField<TimeSlot>(
      validator: (_) => BookingValidators.timeSlot(
        _slot,
        context.read<BookingBloc>().state.bookedSlots,
      ),
      builder: (field) {
        final theme = Theme.of(context);
        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Time slot',
            border: const OutlineInputBorder(),
            errorText: field.errorText,
          ),
          child: BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              if (_date == null) {
                return Text(
                  'Select a date to see available slots',
                  style: theme.textTheme.bodyMedium,
                );
              }
              if (state.loadingSlots) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: LinearProgressIndicator(),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final slot in TimeSlot.values)
                        ChoiceChip(
                          label: Text(slot.label),
                          selected: _slot == slot,
                          onSelected: state.bookedSlots.contains(slot)
                              ? null
                              : (_) {
                                  setState(() => _slot = slot);
                                  field.didChange(slot);
                                },
                        ),
                    ],
                  ),
                  if (state.bookedSlots.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Greyed-out slots are already booked.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHoursField() {
    final maxHours = BookingValidators.maxHoursFor(_slot);
    return FormField<int>(
      autovalidateMode: AutovalidateMode.always,
      validator: (_) => BookingValidators.hours(_hours, _slot),
      builder: (field) {
        void update(int hours) {
          setState(() => _hours = hours);
          field.didChange(hours);
        }

        final theme = Theme.of(context);
        final slot = _slot;
        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Estimated hours',
            border: const OutlineInputBorder(),
            helperText: slot == null
                ? 'Between 1 and 8 hours'
                : 'Ends at ${_formatHour(slot.startHour + _hours)}',
            errorText: field.errorText,
          ),
          child: Row(
            children: [
              IconButton.outlined(
                tooltip: 'Decrease',
                icon: const Icon(Icons.remove),
                onPressed: _hours > BookingValidators.minHours
                    ? () => update(_hours - 1)
                    : null,
              ),
              Expanded(
                child: Text(
                  '$_hours ${_hours == 1 ? 'hour' : 'hours'}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              IconButton.outlined(
                tooltip: 'Increase',
                icon: const Icon(Icons.add),
                onPressed: _hours < maxHours ? () => update(_hours + 1) : null,
              ),
            ],
          ),
        );
      },
    );
  }

  static String _formatHour(int hour) {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    return '$h ${hour < 12 ? 'AM' : 'PM'}';
  }
}

class _ProviderSummary extends StatelessWidget {
  const _ProviderSummary({required this.provider});

  final ProviderEntity provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(child: Text(provider.name[0])),
        title: Text(provider.name, style: theme.textTheme.titleMedium),
        subtitle: Text('${provider.location} · LKR ${provider.hourlyRate}/hr'),
      ),
    );
  }
}
