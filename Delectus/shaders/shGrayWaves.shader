//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.	
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}

//######################_==_YOYO_SHADER_MARKER_==_######################@~//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float time;
uniform float intensity;

#define S smoothstep

void main()
{

    vec2 p = v_vTexcoord;                         
    p*=6.;
    p.x-=0.5;
    vec2 i = p;
    float c = 0.0;
    float r = length(p+vec2(sin(time),sin(time*.300+5.))*0.5);
    float d = length(p);
    float rot = d+time+p.x*.700; 
    for (float n = 0.0; n < 4.0; n++) {
      p *= mat2(cos(rot-sin(time/5.0)), sin(rot), -sin(cos(rot)-time), cos(rot))*-0.2;
      float t = r-time/(n+3.0);
        i -= p + vec2(cos(t - i.x-r) + sin(t + i.y),sin(t - i.y) + cos(t + i.x)+r);
        c += 1.2/length(vec2((sin(i.x+t)/.15), (cos(i.y+t)/.15)));
    }
    c /= 6.0;
    gl_FragColor = vec4(vec3(c)*vec3(1.5, 1.5, 1.5)-0.2, intensity);
    
    //gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
}

