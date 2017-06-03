part of WebGLUtils;

class MyRenderObject extends RenderableObject{
  WebGL.UniformLocation materialDiffuseColor;
  WebGL.UniformLocation materialAmbientColor;
  WebGL.Buffer verticesNormalBuffer;
   
  MyRenderObject(WebGL.RenderingContext gl, WebGL.Program p, ModelObject obj) : super(gl, p, obj){
  }
  
  void setupBuffers(){
    //conver the arry to Float32List
    var vertexArray = new Float32List.fromList(_obj.fixedVertics);
    //Create Buffer in GPU to store vertices data.
    vertexBuffer = _gl.createBuffer();
    //tell opengl we are going to configrate buff vertexBuffer
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    //fill the buff using the data in Float32List
    _gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER,
                  vertexArray,
                  WebGL.RenderingContext.STATIC_DRAW);
    
    //conver the arry to Float32List
    var vertexNormalsArray = new Float32List.fromList(_obj.fixedNormals);
    verticesNormalBuffer = _gl.createBuffer();
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, verticesNormalBuffer);
    //fill the buff using the data in Float32List
    _gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER,
        vertexNormalsArray,
                  WebGL.RenderingContext.STATIC_DRAW);
  }
  
  void setupMaterial(){
    var key = _obj.useMaterial;
    m = mm.getMaterial(key);
  }
  
  void modifyShaderAttributes() {
    //find the attribute position (it is a integer, which can be think as a name with number)
    aVertexPosition = _gl.getAttribLocation(_p, 'aVertexPosition');
    //now enable: If enabled, the values in the generic vertex attribute array will 
    //be accessed and used for rendering when calls are made to vertex array commands such as glDrawArrays or glDrawElements.
    _gl.enableVertexAttribArray(aVertexPosition);
    
    aVertexNormal = _gl.getAttribLocation(_p, 'aVertexNormal');
    _gl.enableVertexAttribArray(aVertexNormal);
    
    //aVertexColor = _gl.getAttribLocation(_p, 'aVertexColor');
    //_gl.disableVertexAttribArray(aVertexColor);
  }

  void prerender() {
    //tell opengl we are going to configrate buff vertexBuffer
    //glBindBuffer lets you create or use a named buffer object. 
    //Calling glBindBuffer with target set to GL_ARRAY_BUFFER or 
    //GL_ELEMENT_ARRAY_BUFFER and buffer set to the name of the 
    //new buffer object binds the buffer object name to the target. 
    //When a buffer object is bound to a target, the previous binding for that target is automatically broken.
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    //tell opengl what is the data format in the buffer
    _gl.vertexAttribPointer(aVertexPosition,
                           3, WebGL.RenderingContext.FLOAT, // 3 floats
                           false, 0,
                           0); // 0 offset
    
    //the normal
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, verticesNormalBuffer);
    _gl.vertexAttribPointer(aVertexNormal, 3, WebGL.RenderingContext.FLOAT, false, 0, 0);
    
    //set the diffuse color
    materialDiffuseColor = _gl.getUniformLocation(_p, 'materialDiffuseColor');
    _gl.uniform3f(materialDiffuseColor, m.diffuse[0], m.diffuse[1], m.diffuse[2]);
    //set ambient color
    materialAmbientColor = _gl.getUniformLocation(_p, 'materialAmbientColor');
    _gl.uniform3f(materialAmbientColor, m.ambient[0], m.ambient[1], m.ambient[2]);
    
  }

  void render() {
    _gl.drawArrays(WebGL.RenderingContext.TRIANGLES, 0, _obj.facesIndices.length);
  }
  
}