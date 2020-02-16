import 'package:flutter/material.dart';

enum CollageType {
  VSplit,
  HSplit,
  FourSquare,
  NineSquare,
  ThreeVertical,
  LeftBig,
  RightBig,
  ThreeHorizontal,
  FourLeftBig,
  VMiddleTwo,
  CenterBig
}

getCellCount(
    {@required int index, bool isForCrossAxis, @required CollageType type}) {
  /// total cell count :- 2
  /// Column and Row :- 2*1 = 2 (Cross axis count)

  if (type == CollageType.VSplit) {
    if (isForCrossAxis)

      /// Cross axis cell count
      return 1;
    else

      /// Main axis cell count
      return 2;
  }

  /// total cell count :- 2
  /// Column and Row :- 1*2 = 2 (Cross axis count)

  else if (type == CollageType.HSplit) {
    if (isForCrossAxis)

      /// Cross axis cell count
      return 2;
    else

      /// Main axis cell count
      return 1;
  }

  /// total cell count :- 4
  /// Column and Row :- 2*2 (Cross axis count)

  else if (type == CollageType.FourSquare) {
    /// cross axis and main axis cell count
    return 2;
  }

  /// total cell count :- 9
  /// Column and Row :- 3*3 (Cross axis count)
  else if (type == CollageType.NineSquare) {
    return 3;
  }

  /// total cell count :- 3
  /// Column and Row :- 2 * 2
  /// First index taking 2 cell count in main axis and also in cross axis.
  else if (type == CollageType.ThreeVertical) {
    if (isForCrossAxis) {
      return 1;
    } else
      return (index == 0) ? 2 : 1;
  } else if (type == CollageType.ThreeHorizontal) {
    if (isForCrossAxis) {
      return (index == 0) ? 2 : 1;
    } else
      return 1;
  }

  /// total cell count :- 6
  /// Column and Row :- 3 * 3
  /// First index taking 2 cell in main axis and also in cross axis.
  /// Cross axis count = 3

  else if (type == CollageType.LeftBig) {
    if (isForCrossAxis) {
      return (index == 0) ? 2 : 1;
    } else
      return (index == 0) ? 2 : 1;
  } else if (type == CollageType.RightBig) {
    if (isForCrossAxis) {
      return (index == 1) ? 2 : 1;
    } else
      return (index == 1) ? 2 : 1;
  } else if (type == CollageType.FourLeftBig) {
    if (isForCrossAxis) {
      return (index == 0) ? 2 : 1;
    } else
      return (index == 0) ? 3 : 1;

    /// total tile count (image count)--> 7
    /// Column: Row (2:3)
    /// First column :- 3 tile
    /// Second column :- 4 tile
    /// First column 3 tile taking second column's 4 tile space. So total tile count is 4*3=12(cross axis count).
    /// First column each cross axis tile count = cross axis count/ total tile count(In cross axis)  {12/3 = 4]
    /// Second column cross axis cell count :- 12/4 = 3
    /// Main axis count : Cross axis count / column count {12/2 = 6}
  } else if (type == CollageType.VMiddleTwo) {
    if (isForCrossAxis) {
      return 6;
    } else
      return (index == 0 || index == 3 || index == 5) ? 4 : 3;
  }

  /// total tile count (image count)--> 7
  /// left, right and center  - 3/3/1
  /// total column:- 3
  /// total row :- 4 (total row is 3 but column 2 taking 2 row space so left + center + right = 1+2+1 {4}).
  /// cross axis count = total column * total row {3*4 = 12}.
  /// First/Third column each cross axis tile count = cross axis count / total tile count(In cross axis) = 12 / 3 = 4
  /// First/Third column each main axis tile count = cross axis count / total tile count(In main axis) = 12 / 4 = 3
  /// Second each cross axis tile count = cross axis count / total tile count(In cross axis) = 12/1 = 12
  /// Second each main axis tile count = cross axis count / total tile count(In main axis) = 12/2 = 6

  else if (type == CollageType.CenterBig) {
    if (isForCrossAxis) {
      return (index == 1) ? 6 : 3;
    } else
      return (index == 1) ? 12 : 4;
  }
}

getCrossAxisCount(CollageType type) {
  if (type == CollageType.HSplit ||
      type == CollageType.VSplit ||
      type == CollageType.ThreeHorizontal ||
      type == CollageType.ThreeVertical)
    return 2;
  else if (type == CollageType.FourSquare)
    return 4;
  else if (type == CollageType.NineSquare)
    return 9;
  else if (type == CollageType.LeftBig || type == CollageType.RightBig)
    return 3;
  else if (type == CollageType.FourLeftBig)
    return 3;
  else if (type == CollageType.VMiddleTwo || type == CollageType.CenterBig)
    return 12;
}
