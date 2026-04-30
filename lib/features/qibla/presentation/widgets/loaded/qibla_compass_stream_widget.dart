import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:sana/features/qibla/presentation/cubit/qibla_cubit.dart';

class QiblaCompassStreamWidget extends StatelessWidget {
  const QiblaCompassStreamWidget({
    required this.qiblaDirection,
    required this.builder,
    super.key,
  });
  final double qiblaDirection;
  final Widget Function(QiblaCompassDataEntity? data) builder;

  @override
  Widget build(BuildContext context) {
    final stream = context.read<QiblaCubit>().getQiblaStream(qiblaDirection);

    if (stream == null) {
      return builder(null);
    }

    return StreamBuilder<QiblaCompassDataEntity>(
      stream: stream,
      builder: (context, snapshot) {
        return builder(snapshot.data);
      },
    );
  }
}
