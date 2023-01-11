const _epochTicks = 621355968000000000;

extension TicksOnDateTime on DateTime {
  int get ticks => microsecondsSinceEpoch * 10 + _epochTicks;
}
