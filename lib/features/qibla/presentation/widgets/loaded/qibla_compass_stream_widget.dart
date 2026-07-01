import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:sana/features/qibla/presentation/cubit/qibla_cubit.dart';

class QiblaCompassStreamWidget extends StatefulWidget {
  const QiblaCompassStreamWidget({
    required this.qiblaDirection,
    required this.builder,
    super.key,
  });
  final double qiblaDirection;
  final Widget Function(QiblaCompassDataEntity? data) builder;

  @override
  State<QiblaCompassStreamWidget> createState() =>
      _QiblaCompassStreamWidgetState();
}

class _QiblaCompassStreamWidgetState extends State<QiblaCompassStreamWidget> {
  Stream<QiblaCompassDataEntity>? _stream;

  @override
  void initState() {
    super.initState();
    _stream = context.read<QiblaCubit>().getQiblaStream(widget.qiblaDirection);
  }

  @override
  Widget build(BuildContext context) {
    if (_stream == null) {
      return widget.builder(null);
    }

    return StreamBuilder<QiblaCompassDataEntity>(
      stream: _stream,
      builder: (context, snapshot) {
        return widget.builder(snapshot.data);
      },
    );
  }
}
