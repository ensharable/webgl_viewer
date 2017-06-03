part of WebGLUtils;

class Material {
  String _id;
  String name;
  double shininessOfMateria;
  List<double> ambient;
  List<double> diffuse;
  List<double> specular;
  double transparent;
  int illuminationMode;
  String textureMap;
  /*
  0. Color on and Ambient off
  1. Color on and Ambient on
  2. Highlight on
  3. Reflection on and Ray trace on
  4. Transparency: Glass on, Reflection: Ray trace on
  5. Reflection: Fresnel on and Ray trace on
  6. Transparency: Refraction on, Reflection: Fresnel off and Ray trace on
  7. Transparency: Refraction on, Reflection: Fresnel on and Ray trace on
  8. Reflection on and Ray trace off
  9. Transparency: Glass on, Reflection: Ray trace off
  10. Casts shadows onto invisible surfaces
  */
}