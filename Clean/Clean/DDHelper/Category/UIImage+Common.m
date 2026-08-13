#import "UIImage+Common.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation UIImage (Common)

/**
 *  裁剪图片
 *
 *  @param image  图片
 *  @param bounds 大小
 *
 */
+ (UIImage *)croppedImage:(UIImage *)image bounds:(CGRect)bounds
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

+ (UIImage *)clipImage:(UIImage *)image ScaleWithsize:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        else{
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClipToRect(context, CGRectMake(0, 0, asize.width, asize.height));
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

+ (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size {
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                           
                           [NSNumber numberWithBool:YES],kCVPixelBufferCGImageCompatibilityKey,
                           
                           [NSNumber numberWithBool:YES],kCVPixelBufferCGBitmapContextCompatibilityKey,nil];
    
    CVPixelBufferRef pxbuffer = NULL;
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,size.width,size.height,kCVPixelFormatType_32ARGB,(__bridge CFDictionaryRef) options,&pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer,0);
    
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    NSParameterAssert(pxdata !=NULL);
    
    CGColorSpaceRef rgbColorSpace=CGColorSpaceCreateDeviceRGB();
    
    //    当你调用这个函数的时候，Quartz创建一个位图绘制环境，也就是位图上下文。当你向上下文中绘制信息时，Quartz把你要绘制的信息作为位图数据绘制到指定的内存块。一个新的位图上下文的像素格式由三个参数决定：每个组件的位数，颜色空间，alpha选项
    
    CGContextRef context = CGBitmapContextCreate(pxdata,size.width,size.height,8,4*size.width,rgbColorSpace,kCGImageAlphaPremultipliedFirst);
    
    NSParameterAssert(context);
    
    //使用CGContextDrawImage绘制图片  这里设置不正确的话 会导致视频颠倒
    
    //    当通过CGContextDrawImage绘制图片到一个context中时，如果传入的是UIImage的CGImageRef，因为UIKit和CG坐标系y轴相反，所以图片绘制将会上下颠倒
    
    CGContextDrawImage(context,CGRectMake(0,0,CGImageGetWidth(image),CGImageGetHeight(image)), image);
    
    // 释放色彩空间
    
    CGColorSpaceRelease(rgbColorSpace);
    
    // 释放context
    
    CGContextRelease(context);
    
    // 解锁pixel buffer
    
    CVPixelBufferUnlockBaseAddress(pxbuffer,0);
    
    return pxbuffer;
}


+ (UIImage*)getGrayscale:(UIImage*)sourceImage
{
    
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace =  CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,width,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    
    return grayImage;
}

double getImgBlurDegree(unsigned char* ImgdataGray, int nWidth, int nHeight)
{
    if(ImgdataGray == NULL || nWidth <= 4 || nHeight <= 4)
    {
        return 0.0;
    }
    int row= nHeight;
    int col= nWidth;
    int widthstep=nWidth;
    double S=0;
    unsigned char* data  = ImgdataGray;
    for(int x = 1;x<row-1;x+=2)
    {
        unsigned char *pre_row=data +(x-1)*widthstep;
        unsigned char *cur_row=data +x*widthstep;
        unsigned char *nex_row=data +(x+1)*widthstep;
        int Sx,Sy;
        for(int y = 1;y<col-1;y+=2)
        {
            Sx=(int)pre_row[y+1]+2*(int)cur_row[y+1]+(int)nex_row[y+1]//一定要转为uchar
            -(int)pre_row[y-1]-2*(int)cur_row[y-1]-(int)nex_row[y-1];
            Sy=(int)nex_row[y-1]+2*(int)nex_row[y]+(int)nex_row[y+1]
            -(int)pre_row[y-1]-2*(int)pre_row[y]-(int)pre_row[y+1];
            S+=Sx*Sx+Sy*Sy;
        }
    }
    return S/(row/2-2)/(col/2-2);
}

+ (double)getImageDimValue:(UIImage *)sourceImage {
    if (!sourceImage) {
        return 0;
    }
    
    UIImage *grayscale = [self getGrayscale:sourceImage];
    
    CGImageRef imageRef = [grayscale CGImage];
    CGFloat width = CGImageGetWidth(imageRef);
    CGFloat height = CGImageGetHeight(imageRef);
    
    CGDataProviderRef provider =  CGImageGetDataProvider(imageRef);
    NSData* data = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
    uint8_t *grayscaleData = (uint8_t *)[data bytes];
    
    return getImgBlurDegree(grayscaleData, width, height);
}


@end
