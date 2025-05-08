import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tyba_university_app/core/const/const.dart';

/// The `Responsive` class is used to calculate and provide information about the device's
/// screen dimensions and whether it is a tablet or not.
class Responsive {
  Responsive(
    BuildContext context,
  ) {
    final Size size = MediaQuery.of(context).size;
    _width = size.width;
    _height = size.height;
    _diagonal = math.sqrt(math.pow(_width, 2) + math.pow(_height, 2));
    _isTablet = size.shortestSide >= 600;
    _isDesktop = size.width > Const.resolution;
    _designDiagonal = math.sqrt(math.pow(400, 2) + math.pow(853, 2));
    _scaleFactor = _diagonal / _designDiagonal;

    _webDesignDiagonal = math.sqrt(math.pow(1046, 2) + math.pow(1366, 2));
    _webScaleFactor = _diagonal / _webDesignDiagonal;
    _isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
  }
  double _width = 0;
  double _height = 0;
  double _diagonal = 0;
  bool _isTablet = false;
  double _scaleFactor = 0;
  double _designDiagonal = 0;
  double _webDesignDiagonal = 0;
  double _webScaleFactor = 0;
  bool _isDesktop = false;
  bool _isLandscape = false;

  double get width => _width;
  double get height => _height;
  double get diagonal => _diagonal;
  bool get isTablet => _isTablet;
  bool get isDesktop => _isDesktop;
  bool get isLandscape => _isLandscape;

  static Responsive of(BuildContext context) => Responsive(context);

  double wp(double percent) => _width * percent / 100;
  double hp(double percent) => _height * percent / 100;
  double dp(double percent) => _diagonal * percent / 100;

  double fp(int designFontSize) => designFontSize * _scaleFactor;
  double fpw(int designFontSize) => designFontSize * _webScaleFactor;
}
