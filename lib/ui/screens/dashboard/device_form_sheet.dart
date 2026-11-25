import 'package:material_ui/material_ui.dart';
import 'package:my_project/domain/models/device.dart';
import 'package:my_project/domain/validation/validators.dart';
import 'package:my_project/ui/screens/dashboard/device_form_result.dart';
import 'package:my_project/ui/theme/app_colors.dart';
import 'package:my_project/ui/theme/app_spacing.dart';
import 'package:my_project/ui/widgets/app_text_field.dart';
import 'package:my_project/ui/widgets/device_type_ui.dart';
import 'package:my_project/ui/widgets/primary_button.dart';

/// Відкриває форму додавання ([initial] == null) або редагування.
Future<DeviceFormResult?> showDeviceFormSheet(
  BuildContext context, {
  Device? initial,
}) {
  return showModalBottomSheet<DeviceFormResult>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _DeviceForm(initial: initial),
  );
}

class _DeviceForm extends StatefulWidget {
  const _DeviceForm({this.initial});

  final Device? initial;

  @override
  State<_DeviceForm> createState() => _DeviceFormState();
}

class _DeviceFormState extends State<_DeviceForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController(
    text: widget.initial?.name,
  );
  late final TextEditingController _location = TextEditingController(
    text: widget.initial?.location,
  );
  late DeviceType _type = widget.initial?.type ?? DeviceType.raspberryPi;

  bool get _isEditing => widget.initial != null;

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.pop(
      context,
      DeviceFormSaved(name: _name.text, location: _location.text, type: _type),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // viewInsets.bottom = висота клавіатури: форма піднімається над нею.
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.l,
        0,
        AppSpacing.l,
        AppSpacing.l + keyboard,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isEditing ? 'Редагувати пристрій' : 'Новий пристрій',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.m),
            AppTextField(
              controller: _name,
              label: 'Назва',
              hint: 'Напр. pi-node-01',
              icon: Icons.dns_outlined,
              validator: Validators.deviceName,
            ),
            AppTextField(
              controller: _location,
              label: 'Розташування',
              hint: 'Напр. Стійка, полиця 2',
              icon: Icons.place_outlined,
              validator: Validators.location,
            ),
            DropdownButtonFormField<DeviceType>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Тип пристрою'),
              items: [
                for (final type in DeviceType.values)
                  DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        Icon(type.icon),
                        const SizedBox(width: AppSpacing.s),
                        Text(type.label),
                      ],
                    ),
                  ),
              ],
              onChanged: (type) => setState(() => _type = type ?? _type),
            ),
            const SizedBox(height: AppSpacing.l),
            PrimaryButton(
              label: 'Зберегти',
              icon: Icons.check,
              onPressed: _save,
            ),
            if (_isEditing) ...[
              const SizedBox(height: AppSpacing.s),
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                onPressed: () =>
                    Navigator.pop(context, const DeviceFormDeleted()),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Видалити пристрій'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
