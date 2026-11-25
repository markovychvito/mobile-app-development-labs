import 'package:material_ui/material_ui.dart';
import 'package:my_project/app/app_routes.dart';
import 'package:my_project/domain/exceptions/app_exception.dart';
import 'package:my_project/domain/models/user.dart';
import 'package:my_project/domain/repositories/auth_repository.dart';
import 'package:my_project/domain/repositories/device_repository.dart';
import 'package:my_project/ui/screens/profile/edit_name_dialog.dart';
import 'package:my_project/ui/screens/profile/profile_body.dart';
import 'package:my_project/ui/widgets/confirm_dialog.dart';
import 'package:my_project/ui/widgets/loading_view.dart';
import 'package:my_project/ui/widgets/snackbar_extension.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    required this.authRepository,
    required this.deviceRepository,
    super.key,
  });

  final IAuthRepository authRepository;
  final IDeviceRepository deviceRepository;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  int _deviceCount = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = await widget.authRepository.currentUser();
    if (user == null) {
      if (mounted) await _goToLogin();
      return;
    }
    final devices = await widget.deviceRepository.fetchAll(user.email);
    if (!mounted) return;
    setState(() {
      _user = user;
      _deviceCount = devices.length;
    });
  }

  Future<void> _editName() async {
    final user = _user;
    if (user == null) return;
    final name = await showEditNameDialog(context, initialName: user.name);
    if (name == null) return;
    try {
      final updated = await widget.authRepository.updateName(name);
      if (mounted) setState(() => _user = updated);
    } on AppException catch (e) {
      if (mounted) context.showMessage(e.message);
    }
  }

  Future<void> _logout() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Вийти з акаунта?',
      message: 'Щоб повернутися, потрібно буде знову ввести пароль.',
      confirmLabel: 'Вийти',
    );
    if (!confirmed) return;
    await widget.authRepository.logout();
    if (mounted) await _goToLogin();
  }

  Future<void> _goToLogin() {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: user == null
          ? const LoadingView()
          : ProfileBody(
              user: user,
              deviceCount: _deviceCount,
              onEditName: _editName,
              onLogout: _logout,
            ),
    );
  }
}
