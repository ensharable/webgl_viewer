part of WebGLUtils;


/**
 * Implementation of point light
 */
class PointLight extends Light {

  WebGL.UniformLocation aLightPos;
  WebGL.UniformLocation aLightColor;
  WebGL.UniformLocation aLightSpecColor;

  PointLight(String id, Vector3 lightPosition, Vector3 lightColor, Vector3 lightSpecColor) : super(id, lightPosition, lightColor, lightSpecColor) {
  }

  /**
   * Implementation for the prerender method
   */
  void prerender(WebGL.RenderingContext gl, WebGL.Program p) {
    //set light
    aLightPos = gl.getUniformLocation(p, 'lightPos');
    gl.uniform3f(aLightPos, lightPosition.x, lightPosition.y, lightPosition.z);
    aLightColor = gl.getUniformLocation(p, 'lightColor');
    gl.uniform3f(aLightColor, lightColor.r, lightColor.g, lightColor.b);
    aLightSpecColor = gl.getUniformLocation(p, 'lightSpecColor');
    gl.uniform3f(aLightSpecColor, lightSpecColor.r, lightSpecColor.g, lightSpecColor.b);
  }
}
