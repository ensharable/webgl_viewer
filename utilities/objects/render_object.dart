part of WebGLUtils;

class RenderObject extends RenderableObject{
   
  RenderObject(WebGL.RenderingContext gl, WebGL.Program p, ModelObject obj) : super(gl, p, obj){
  }
  
  void setupBuffers(){
    //conver the arry to Float32List
    var vertexArray = new Float32List.fromList(_obj.vertics);
    //Create Buffer in GPU to store vertices data.
    vertexBuffer = _gl.createBuffer();
    //tell opengl we are going to configrate buff vertexBuffer
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    //fill the buff using the data in Float32List
    _gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER,
                  vertexArray,
                  WebGL.RenderingContext.STATIC_DRAW);
    
    //conver the arry to Float32List
    var indexArray = new Uint16List.fromList(_obj.facesIndices);
    //create buffer in GPU
    indexBuffer = _gl.createBuffer();
    _gl.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
    _gl.bufferDataTyped(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER,
                  indexArray,
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
    
    aVertexColor = _gl.getAttribLocation(_p, 'aVertexColor');
    _gl.disableVertexAttribArray(aVertexColor);
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
    
    //bind the index buffer to shader
    _gl.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
    
    _gl.vertexAttrib4f(aVertexColor, m.diffuse[0], m.diffuse[1], m.diffuse[2], 1.0);
  }

  void render() {
    //draw the cube according to the index buffer
    _gl.drawElements(WebGL.RenderingContext.TRIANGLES, _obj.facesIndices.length,
                    WebGL.RenderingContext.UNSIGNED_SHORT, 0);
  }
  
}