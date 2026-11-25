import 'package:material_ui/material_ui.dart';
import 'package:my_project/ui/theme/app_spacing.dart';

/// Уніфіковане текстове поле. Для паролів показує кнопку
/// «показати / приховати», тому віджет Stateful.
class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    required this.icon,
    this.controller,
    this.hint,
    this.keyboardType,
    this.validator,
    this.onSubmitted,
    this.isPassword = false,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    super.key,
  });

  final String label;
  final IconData icon;
  final TextEditingController? controller;
  final String? hint;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;
  final bool isPassword;
  final bool enabled;
  final TextInputAction textInputAction;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.isPassword;

  void _toggleVisibility() {
    setState(() => _obscured = !_obscured);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: TextFormField(
        controller: widget.controller,
        enabled: widget.enabled,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        validator: widget.validator,
        onFieldSubmitted: widget.onSubmitted,
        obscureText: _obscured,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          errorMaxLines: 2,
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.isPassword
              ? IconButton(
                  tooltip: _obscured ? 'Показати пароль' : 'Приховати пароль',
                  onPressed: _toggleVisibility,
                  icon: Icon(
                    _obscured ? Icons.visibility : Icons.visibility_off,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
