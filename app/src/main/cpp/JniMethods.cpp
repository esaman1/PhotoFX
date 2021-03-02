//
// Created by Shiva Shankar patel psy on 3/1/21.
//
///////for implementing jni method(java meths in c)
#include <jni.h>
#include "android/log.h"
#include "JniMethods.h"
#include "Commons.h"
#include "Graphics.h"
///////This file is included in main.cpp in the end for correct linking purposes ignoore syncNow;dont add to cmakelists.
extern "C"
JNIEXPORT jint JNICALL
Java_com_kalasoft_photofx_ChooserRenderer_createGlProgram(JNIEnv *env, jobject thiz,jstring vertex_shader_path,jstring fragment_shader_path)
{
    Loge("JNIMETH","CRESTING PROGRAM");
  //  int program=0;av
    return Shader::createShaderProgram(AppContext::getApp(),"JavaShaders/vertexShader.glsl","JavaShaders/fragmentShader.glsl");;
    // TODO: implement createGlProgram()
}
