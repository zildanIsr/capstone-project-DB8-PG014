import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef ProviderListener<T> = void Function(BuildContext context, T value);

class ProviderListenerWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget child;
  final ProviderListener<T> listener;

  const ProviderListenerWidget({
    super.key,
    required this.child,
    required this.listener,
  });

  @override
  State<ProviderListenerWidget<T>> createState() =>
      _ProviderListenerWidgetState<T>();
}

class _ProviderListenerWidgetState<T extends ChangeNotifier>
    extends State<ProviderListenerWidget<T>> {
  late T _provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = context.read<T>();
    _provider.addListener(_onChange);
  }

  void _onChange() {
    if (mounted) {
      widget.listener(context, _provider);
    }
  }

  @override
  void dispose() {
    _provider.removeListener(_onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
