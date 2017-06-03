part of WebGLUtils;


final bool VERBOSE = false;

void printLog(String log) {
  if (VERBOSE && log != null && !log.isEmpty) {
    print(log);
  }
}

String getBaseUrl() {
  var location = window.location.href;
  return "${location.substring(0, location.length - "webgl_viewer.html".length)}";
  //old
  //return "${location.substring(0, location.length - "webgltest.html".length - 4)}";
}