part of WebGLUtils;

class BoxWithTexture extends Shapes {
  WebGL.Buffer indexBuffer;
  WebGL.Buffer vertexBuffer;
  WebGL.Buffer verticesTextureCoordBuffer;
  WebGL.Buffer verticesNormalBuffer;
  WebGL.Texture texture;
  int _vertexCount=36;  //this is becuse of the box data
  int _vertexStride=0; //this is becuse of the box data
  int _positionAttributeIndex;
  int _textureCoordAttribute;
  int _vertexNormalAttribute;
  var baseUrl;
  
  BoxWithTexture(WebGL.RenderingContext gl, WebGL.Program p) : super(gl, p){
    baseUrl= getBaseUrl();
    baseUrl = '${baseUrl}textures/';
    //baseUrl = '${baseUrl}static/ensharable/images/lab/';
  }

  void setupBuffers() {
    assert(_gl != null);

    var vertices = [
      // Front face
      -1.0, -1.0,  1.0,
      1.0, -1.0,  1.0,
      1.0,  1.0,  1.0,
      -1.0,  1.0,  1.0,
      
      // Back face
      -1.0, -1.0, -1.0,
      -1.0,  1.0, -1.0,
      1.0,  1.0, -1.0,
      1.0, -1.0, -1.0,
      
      // Top face
      -1.0,  1.0, -1.0,
      -1.0,  1.0,  1.0,
      1.0,  1.0,  1.0,
      1.0,  1.0, -1.0,
      
      // Bottom face
      -1.0, -1.0, -1.0,
      1.0, -1.0, -1.0,
      1.0, -1.0,  1.0,
      -1.0, -1.0,  1.0,
      
      // Right face
      1.0, -1.0, -1.0,
      1.0,  1.0, -1.0,
      1.0,  1.0,  1.0,
      1.0, -1.0,  1.0,
      
      // Left face
      -1.0, -1.0, -1.0,
      -1.0, -1.0,  1.0,
      -1.0,  1.0,  1.0,
      -1.0,  1.0, -1.0
      ];
    
    //Create WebGL Buffer to store vertices data.
    vertexBuffer = _gl.createBuffer();
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    //cover the arry to Float32List
    Float32List vertexArray = new Float32List.fromList(vertices);
    //fill the buff using the data in Float32List
    _gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER,
                  vertexArray,
                  WebGL.RenderingContext.STATIC_DRAW);
    
    
    // Index for the cube
    var vertexIndices = [
           0,  1,  2,      0,  2,  3,    // front
           4,  5,  6,      4,  6,  7,    // back
           8,  9,  10,     8,  10, 11,   // top
           12, 13, 14,     12, 14, 15,   // bottom
           16, 17, 18,     16, 18, 19,   // right
           20, 21, 22,     20, 22, 23    // left
           ];
    Uint16List indexArray = new Uint16List.fromList(vertexIndices);
    indexBuffer = _gl.createBuffer();
    _gl.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
    _gl.bufferDataTyped(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER,
                  indexArray,
                  WebGL.RenderingContext.STATIC_DRAW);
    
    
   // Map the texture onto the cube's faces.
    var textureCoordinates = [
                              // Front
                              0.0,  0.0,
                              1.0,  0.0,
                              1.0,  1.0,
                              0.0,  1.0,
                              // Back
                              0.0,  0.0,
                              1.0,  0.0,
                              1.0,  1.0,
                              0.0,  1.0,
                              // Top
                              0.0,  0.0,
                              1.0,  0.0,
                              1.0,  1.0,
                              0.0,  1.0,
                              // Bottom
                              0.0,  0.0,
                              1.0,  0.0,
                              1.0,  1.0,
                              0.0,  1.0,
                              // Right
                              0.0,  0.0,
                              1.0,  0.0,
                              1.0,  1.0,
                              0.0,  1.0,
                              // Left
                              0.0,  0.0,
                              1.0,  0.0,
                              1.0,  1.0,
                              0.0,  1.0
                              ];
    verticesTextureCoordBuffer = _gl.createBuffer();
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, verticesTextureCoordBuffer);
    //cover the arry to Float32List
    Float32List vertexTextureArray = new Float32List.fromList(textureCoordinates);
    //fill the buff using the data in Float32List
    _gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER,
        vertexTextureArray,
                  WebGL.RenderingContext.STATIC_DRAW);
    
    //normal
    var vertexNormals = [
                         // Front
                         0.0,  0.0,  1.0,
                         0.0,  0.0,  1.0,
                         0.0,  0.0,  1.0,
                         0.0,  0.0,  1.0,
                         
                         // Back
                         0.0,  0.0, -1.0,
                         0.0,  0.0, -1.0,
                         0.0,  0.0, -1.0,
                         0.0,  0.0, -1.0,
                         
                         // Top
                         0.0,  1.0,  0.0,
                         0.0,  1.0,  0.0,
                         0.0,  1.0,  0.0,
                         0.0,  1.0,  0.0,
                         
                         // Bottom
                         0.0, -1.0,  0.0,
                         0.0, -1.0,  0.0,
                         0.0, -1.0,  0.0,
                         0.0, -1.0,  0.0,
                         
                         // Right
                         1.0,  0.0,  0.0,
                         1.0,  0.0,  0.0,
                         1.0,  0.0,  0.0,
                         1.0,  0.0,  0.0,
                         
                         // Left
                         -1.0,  0.0,  0.0,
                         -1.0,  0.0,  0.0,
                         -1.0,  0.0,  0.0,
                         -1.0,  0.0,  0.0
                         ];
    verticesNormalBuffer = _gl.createBuffer();
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, verticesNormalBuffer);
    //cover the arry to Float32List
    Float32List vertexNormalsArray = new Float32List.fromList(vertexNormals);
    //fill the buff using the data in Float32List
    _gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER,
        vertexNormalsArray,
                  WebGL.RenderingContext.STATIC_DRAW);
  }
  
  void setupTexture(){
    loadImage();  
  }
  
  void loadImage() {
    var name = "Dart_Logo.png";
    texture = _gl.createTexture();
    ImageElement img = new ImageElement();
    Completer c = new Completer();
    img.onLoad.listen((_) {
      _gl.bindTexture(WebGL.RenderingContext.TEXTURE_2D, texture);
      _gl.texImage2D(WebGL.RenderingContext.TEXTURE_2D,
                    0,
                    WebGL.RenderingContext.RGBA,
                    WebGL.RenderingContext.RGBA,
                    WebGL.RenderingContext.UNSIGNED_BYTE,
                    img);
      _gl.texParameteri(WebGL.TEXTURE_2D,
          WebGL.RenderingContext.TEXTURE_MIN_FILTER,
          WebGL.RenderingContext.LINEAR);
      _gl.texParameteri(WebGL.TEXTURE_2D,
                       WebGL.RenderingContext.TEXTURE_MAG_FILTER,
                       WebGL.RenderingContext.LINEAR);
      _gl.generateMipmap(WebGL.TEXTURE_2D);
      c.complete(img.src);
    });
    img.src = '${baseUrl}${name}';
    print('${baseUrl}');
    print(img.src);
  }
  
  void modifyShaderAttributes() {
    _positionAttributeIndex = _gl.getAttribLocation(_program, 'aVertexPosition');
    _gl.enableVertexAttribArray(_positionAttributeIndex);
    
    _textureCoordAttribute = _gl.getAttribLocation(_program, "aTextureCoord");
    _gl.enableVertexAttribArray(_textureCoordAttribute);
    
    _vertexNormalAttribute = _gl.getAttribLocation(_program, "aVertexNormal");
    _gl.enableVertexAttribArray(_vertexNormalAttribute);
  }

  void prerender() {
    
    //bind the vertex buff to shader  
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    _gl.vertexAttribPointer(_positionAttributeIndex,
                           3, WebGL.RenderingContext.FLOAT, // 3 floats
                           false, 0,
                           0); // 0 offset
    
    //bind the index buffer to shader
    _gl.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
    
    //bind texture buffer to shader
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, verticesTextureCoordBuffer);
    _gl.vertexAttribPointer(_textureCoordAttribute, 2, WebGL.RenderingContext.FLOAT, false, 0, 0);

    // Specify the texture to map onto the faces
    _gl.activeTexture(WebGL.RenderingContext.TEXTURE0);
    _gl.bindTexture(WebGL.RenderingContext.TEXTURE_2D, texture);
    _gl.uniform1i(_gl.getUniformLocation(_program, 'uSampler'), 0);
    
    //bind the normal
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, verticesNormalBuffer);
    _gl.vertexAttribPointer(_vertexNormalAttribute, 3, WebGL.RenderingContext.FLOAT, false, 0, 0);
  }
  

  void render() {
    //draw the cube according to the index buffer
    _gl.drawElements(WebGL.RenderingContext.TRIANGLES, 36,
                    WebGL.RenderingContext.UNSIGNED_SHORT, 0);
  }
}