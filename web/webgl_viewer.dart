library objectviewer;

import '../utilities/webgl_utils.dart';
import 'dart:html';
import 'dart:web_gl' as WebGL;

part 'objectviewer.dart';

Objectviewer application = new Objectviewer();

void main() {
  application.startup('#webgl_container');
}

