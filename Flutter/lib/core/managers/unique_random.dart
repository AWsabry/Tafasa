import 'dart:math';

class UniqueRandom {
  final int minInclusive;
  final int maxInclusive;
  final Random _rnd;
  late List<int> _pool;
  int _index = 0;

  UniqueRandom({
    required this.minInclusive,
    required this.maxInclusive,
    Random? random,
  }) : _rnd = random ?? Random() {
    if (minInclusive > maxInclusive) throw ArgumentError('min > max');
    _resetPool();
  }

  void _resetPool() {
    _pool = List<int>.generate(
      maxInclusive - minInclusive + 1,
      (i) => minInclusive + i,
    );
    // Fisher-Yates shuffle
    for (int i = _pool.length - 1; i > 0; i--) {
      int j = _rnd.nextInt(i + 1);
      int tmp = _pool[i];
      _pool[i] = _pool[j];
      _pool[j] = tmp;
    }
    _index = 0;
  }

  /// يرجع الرقم التالي. لما تخلص العناصر - يعيد shuffle و يكمل.
  int next() {
    if (_index >= _pool.length) {
      _resetPool();
    }
    return _pool[_index++];
  }

  /// اختياري: يعيد حالة الكائن كأنك مسحت كل حاجة
  void reset() => _resetPool();
}
