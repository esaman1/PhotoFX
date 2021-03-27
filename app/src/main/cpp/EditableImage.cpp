//
// Created by Shiva Shankar patel psy on 2/20/21.
//

#include <cstring>
#include "EditableImage.h"
#include "Main.h"
EditableImage::EditableImage(float startX, float startY, float Width, float height, Bitmap *image):ImageView(startX,startY,width,height,image)
{/////set buffer to 0 or noise is draw or draw input to ouput firsttime.
    outputBuffer.setDims(image->width, image->height);
    outputBuffer.configureColorBuffer();
    //outputBuffer.configureDepthBuffer();////optional remove if not needed
    outputBuffer.configure();
    outputTexId=outputBuffer.getTexId();
    inputTexId=texId;//two lines so that by default super draw method draw ouput;based on need we can change them to draw ouptu input or both.
    texId=outputTexId;//since these texId all beolong to single object exchnaging them is no problem (also input output are same size;
   // createHistogramTextures();//////should not be in consrtucted only create and delelte when rquired;
   inputHistogram.setOwnerTexture(inputTexId);
   outputHistogram.setOwnerTexture(outputTexId);
   inputHistogram.setOwnerImage(this);
   outputHistogram.setOwnerImage(this);
   activeHistogram=4;//>3just so that histogram are invisible by defalut;
   toggleHistogramView();//initially histograms are invisible
   inputHistogram.setBackgroundColor(1.0,0.0,0.0,1.0);
   outputHistogram.setBackgroundColor(0.0f,0.0f,1.0f,1.0);
}
void EditableImage::equalize(int histogramFor)
{
    eHistogramType=(EHistogramType)histogramFor;
    if(!inputHistogram.isCalculated())
        inputHistogram.compute(histogramFor);
    Histogram::equalize(this);
    if(bEqualized)
    {
        outputHistogram.updateBuffer(equalizedValues);//now outputHistogra contains eq values so before drawing call compute histogram on outputHistogram;anyways the bCalculated is false
    }
    else
    {
        Loge("Equalize","Failed");
    }
}
void EditableImage::toggleHistogramView()
{
    activeHistogram++;
    if(activeHistogram>3)
    {
        activeHistogram=0;
    }
    if(activeHistogram==0)
    {
        inputHistogram.setVisibility(false);
        outputHistogram.setVisibility(false);
    }
    else if(activeHistogram==1)
    {
        inputHistogram.setVisibility(true);
        outputHistogram.setVisibility(false);
    }
    else if(activeHistogram==2)
    {
        inputHistogram.setVisibility(false);
        outputHistogram.setVisibility(true);
    }
    else if(activeHistogram==3)
    {
        inputHistogram.setVisibility(true);
        outputHistogram.setVisibility(true);
    }

}
void EditableImage::onSaveEdit()
{
    //clear input histogram and output histog if histogram is active;
}
void EditableImage::draw()
{
    ImageView::draw();//draw active image either input or output by default output
   // inputHistogram.draw();
   if(inputHistogram.getVisibility())
   {
       inputHistogram.draw();
   }
   if(outputHistogram.getVisibility())
   {
       if(!outputHistogram.isCalculated())
       {
           outputHistogram.reset();
           outputHistogram.compute(eHistogramType);
       }
       outputHistogram.draw();
   }
}