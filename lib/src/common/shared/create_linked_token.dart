import 'package:extensions/primitives.dart';

CancellationToken createLinkedToken(
  CancellationToken token1,
  CancellationToken token2,
) {
  if (!token1.canBeCanceled) {
    return token2;
  } else if (!token2.canBeCanceled) {
    return token1;
  } else {
    final cts =
        CancellationTokenSource.createLinkedTokenSource([token1, token2]);
    return cts.token;
  }
}
