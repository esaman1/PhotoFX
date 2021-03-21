#version 310 es
vec3 rgbToHsi(vec3 rgb);
vec3 hsiToRgb(vec3 hsi);
float logTranform(float intensity,float c);//check can be done on other as well ;
float powerTransform(float intensity, float c);
float contrastStretch(float intensity,float r1,float s1,float r2,float s2);
layout(std430) buffer;
layout (rgba8ui,binding=0) uniform readonly highp uimage2D image;//image
layout (std430, binding=1) buffer binsDat//histogramBuffer
{
    int bins[256];
};
layout(local_size_x = 1,local_size_y=1,local_size_z=1) in;
const float PI=3.14159265358979311599796346854;
const float RADIAN=PI/180.0;
layout(location=0) uniform int filterType;
layout(location=5) uniform float params[4];
void main()
{
    int finalPixel;
    ivec2 pos=ivec2(gl_GlobalInvocationID.xy);
    uint lid=gl_LocalInvocationIndex;
    uvec4 outp= imageLoad(image,pos);//////.rgba cool fx
    // pixel = removeGreen(pixel);
    // finalPixel=RgbaToInt(pixel);
    vec3 rgb=vec3(outp.xyz);
    vec3 hsi=rgbToHsi(rgb);
    switch(filterType)
    {
       case 0://histogram for I;
        {

        }
        case 5://Histogram
        {
            bins[uint(hsi.b)]+=1;
        }break;
    }
    rgb=hsiToRgb(hsi);
    uvec4 outpu=uvec4(rgb,outp.a);
    imageStore(imageout,pos,uvec4(outpu));
}
vec3 rgbToHsi(vec3 rgb)//use seperate r,g,b than a vector;no extram memory and conversion needed
{
    //intesity 0-255,saturation 0-1.0,hue=0-360
    float r=rgb.r,g=rgb.g,b=rgb.b,hue,saturation,minRGB,intensity;
    intensity=(r+g+b)/3.0;
    if(r<=g&&r<=b)////////////min of RGB
    {
        minRGB=r;
    }
    else if(g<=b)
    {
        minRGB=g;
    }
    else minRGB=b;
    saturation=1.0-(minRGB)/(intensity);
    if(r==b&&r==g)
    {
        hue=0.0;
        saturation=0.0;
    }
    else
    {
        float rootover=(r-g)*(r-g)+(r-b)*(g-b);
        hue=sqrt(rootover);
        hue=((r-g)+(r-b))/(2.0*hue);
        hue=acos(hue);
        hue=hue*180.0/PI;//hue in degrees
        //  if(rootover<0.0)
        // hue=0.0;

    }
    if(isnan(hue)||isinf(hue))
    {
        // hue=0.0;
    }
    if(b>g)
    {
        hue=360.0-hue;
    }
    return vec3(hue,saturation,intensity);

}
vec3 hsiToRgb(vec3 hsi)
{
    float hue=hsi.r,saturation=hsi.g,intensity=hsi.b,r,g,b;///differe in fragment shader *255.0
    if(hue>360.0)
    hue-=360.0;
    if(hue>=120.0&&hue<240.0)//////////new RGB values after hue conversion
    {

        hue-=120.0;
        r=intensity*(1.0-saturation);///////new rgb
        g=intensity*(1.0+( saturation*cos(hue*RADIAN)/cos((60.0-hue)*RADIAN)));
        b=3.0*intensity-(g+r);

    }
    else if (hue>=240.0&&hue<360.0)
    {
        hue-=240.0;
        g=intensity*(1.0-saturation);
        b=intensity*(1.0+( saturation*cos(hue*RADIAN)/cos((60.0-hue)*RADIAN)));
        r=3.0*intensity-(g+b);

    }
    else if(hue<=120.0)
    {

        r=intensity*(1.0+( saturation*cos(hue*RADIAN)/cos((60.0-hue)*RADIAN)));
        b=intensity*(1.0-saturation);
        g=3.0*intensity-(b+r);

    }
    else
    {
        //this else only for checking error remove after everythhing is set
        //means the hue is nan or infinity check why this happen try prevent or make color as gray equal to intensity;
        r=intensity;
        g=r;
        b=r;
    }
    /*  if(r>255.0)
      r=255.0;
      else if (r<0.0)
      r=0.0;
      if(g>255.0)
      g=255.0;
      else if(g<0.0)
      g=0.0;
      if(b>255.0)
      b=255.0;
      else if(b<0.0)
      b=0.0;*/
    // r=r/255.0;//////////required in fragmentShader;
    //  g=g/255.0;
    // b=b/255.0;
    return vec3(r,g,b);
}
