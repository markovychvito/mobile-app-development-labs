import 'package:material_ui/material_ui.dart';
import 'package:my_project/app/app_routes.dart';
import 'package:my_project/domain/exceptions/app_exception.dart';
import 'package:my_project/domain/models/device.dart';
import 'package:my_project/domain/models/device_list.dart';
import 'package:my_project/domain/models/user.dart';
import 'package:my_project/domain/repositories/auth_repository.dart';
import 'package:my_project/domain/repositories/device_repository.dart';
import 'package:my_project/ui/screens/dashboard/dashboard_app_bar.dart';
import 'package:my_project/ui/screens/dashboard/dashboard_body.dart';
import 'package:my_project/ui/screens/dashboard/device_form_result.dart';
import 'package:my_project/ui/screens/dashboard/device_form_sheet.dart';
import 'package:my_project/ui/widgets/confirm_dialog.dart';
import 'package:my_project/ui/widgets/loading_view.dart';
import 'package:my_project/ui/widgets/snackbar_extension.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    required this.authRepository,
    required this.deviceRepository,
    super.key,
  });

  final IAuthRepository authRepository;
  final IDeviceRepository deviceRepository;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  User? _user;
  List<Device> _devices = const [];
  bool _isLoading = true;
  bool _isBusy = false;

  IDeviceRepository get _repository => widget.deviceRepository;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Read: завантажує користувача сесії та його пристрої.
  Future<void> _load() async {
    final user = await widget.authRepository.currentUser();
    if (!mounted) return;
    if (user == null) {
      await Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }
    final devices = await _repository.fetchAll(user.email);
    if (!mounted) return;
    setState(() {
      _user = user;
      _devices = devices;
      _isLoading = false;
    });
  }

  /// Спільна обгортка для Create/Update/Delete: вмикає індикатор,
  /// виконує запит і застосовує результат до стану через setState.
  Future<void> _mutate<T>(
    Future<T> Function(String ownerId) request,
    List<Device> Function(T result) apply,
  ) async {
    final user = _user;
    if (user == null || _isBusy) return;
    setState(() => _isBusy = true);
    try {
      final result = await request(user.email);
      if (mounted) setState(() => _devices = apply(result));
    } on AppException catch (e) {
      if (mounted) context.showMessage(e.message);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _addDevice() async {
    final result = await showDeviceFormSheet(context);
    if (result is! DeviceFormSaved) return;
    await _mutate(
      (owner) => _repository.add(
        owner,
        name: result.name,
        location: result.location,
        type: result.type,
      ),
      (device) => [..._devices, device],
    );
  }

  Future<void> _saveDevice(Device updated) {
    return _mutate(
      (owner) => _repository.update(owner, updated),
      (saved) => _devices.replacing(saved),
    );
  }

  Future<void> _openDevice(Device device) async {
    final result = await showDeviceFormSheet(context, initial: device);
    if (!mounted) return;
    switch (result) {
      case DeviceFormSaved(:final name, :final location, :final type):
        await _saveDevice(
          device.copyWith(name: name, location: location, type: type),
        );
      case DeviceFormDeleted():
        await _deleteDevice(device);
      case null:
        return;
    }
  }

  Future<void> _deleteDevice(Device device) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Видалити пристрій?',
      message: '«${device.name}» буде видалено без можливості відновлення.',
      confirmLabel: 'Видалити',
    );
    if (!confirmed) return;
    await _mutate(
      (owner) => _repository.delete(owner, device.id),
      (_) => _devices.without(device.id),
    );
  }

  Future<void> _openProfile() async {
    await Navigator.pushNamed(context, AppRoutes.profile);
    // Ім'я могло змінитися на екрані профілю — перечитуємо дані.
    if (mounted) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    return Scaffold(
      appBar: DashboardAppBar(
        isBusy: _isBusy,
        onProfile: user == null ? null : _openProfile,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading || _isBusy ? null : _addDevice,
        icon: const Icon(Icons.add),
        label: const Text('Додати пристрій'),
      ),
      body: _isLoading || user == null
          ? const LoadingView()
          : DashboardBody(
              user: user,
              devices: _devices,
              onOpen: _openDevice,
              onToggle: (device, isOn) =>
                  _saveDevice(device.copyWith(isOn: isOn)),
            ),
    );
  }
}
