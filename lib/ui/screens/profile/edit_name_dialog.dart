import 'package:material_ui/material_ui.dart';
import 'package:my_project/domain/validation/validators.dart';
import 'package:my_project/ui/widgets/app_text_field.dart';

/// Діалог зміни імені. Повертає нове ім'я або null, якщо скасовано.
Future<String?> showEditNameDialog(
  BuildContext context, {
  required String initialName,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _EditNameDialog(initialName: initialName),
  );
}

class _EditNameDialog extends StatefulWidget {
  const _EditNameDialog({required this.initialName});

  final String initialName;

  @override
  State<_EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<_EditNameDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController(
    text: widget.initialName,
  );

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.pop(context, _name.text.trim());
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Змінити ім'я"),
      content: Form(
        key: _formKey,
        child: AppTextField(
          controller: _name,
          label: "Ім'я",
          icon: Icons.person_outline,
          textInputAction: TextInputAction.done,
          validator: Validators.name,
          onSubmitted: (_) => _save(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Скасувати'),
        ),
        FilledButton(onPressed: _save, child: const Text('Зберегти')),
      ],
    );
  }
}
