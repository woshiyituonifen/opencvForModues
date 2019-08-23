//
//  opencvManger.m
//  opencvSource
//
//  Created by linkface on 2019/8/23.
//  Copyright © 2019 linkface. All rights reserved.
//

#import "opencvManger.h"
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/core/mat.hpp>
@implementation opencvManger
- (UIImage*)getWarpOpencv:(UIImage *)image{
    cv::Mat srcImnage ,dis,gray;
    srcImnage = [self cvMatFromUIImage:image];
    if (srcImnage.empty()){
        NSLog(@"图片不能为空");
    }
    cv::Point2f srcTri[]={
        cv::Point2f(0,0),
        cv::Point2f(srcImnage.cols-1,0),
        cv::Point2f(0,srcImnage.rows - 1)
    };
    
    cv::Point2f dstTri[] ={
        cv::Point2f(srcImnage.cols*0.f,srcImnage.rows * 0.33f),
        cv::Point2f(srcImnage.cols * 0.8f,srcImnage.rows * 0.25f),
        cv::Point2f(srcImnage.cols * 0.15f,srcImnage.rows * 0.7f)
    };
    
    cv::Mat wrap_mat = cv::getAffineTransform(srcTri, dstTri);
    cv::Mat dst ,dst2;
    cv::warpAffine(srcImnage, dst, wrap_mat, srcImnage.size());
    
//    for (int i =0 ; i < 3; i++) {
//        cv::circle(dst, dstTri[i], 5);
//    }

    UIImage *imageDst  = [self UIImageFromCVMat:dst];
    return imageDst;
}
- (UIImage *)getImageOpencv:(UIImage * )image{
    cv::Mat srcImnage ,dis,gray;
    srcImnage = [self cvMatFromUIImage:image];
    cv::cvtColor(srcImnage, gray, CV_BGR2GRAY);
    
    if (srcImnage.empty()){
        NSLog(@"kong de");
    }
    //    cv::getPerspectiveTransform(<#const Point2f *src#>, <#const Point2f *dst#>)
    //    cv::warpPerspective(<#InputArray src#>, <#OutputArray dst#>, <#InputArray M#>, <#Size dsize#>)
    
    cv::Canny(gray, dis, 10,100, 3,true);
    
    //    cv::Mat kerner = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(5,5),cv::Point(-1,-1));
    //    cv::erode(srcImnage, dis, kerner);
    UIImage *images = [self UIImageFromCVMat:dis];
    return images;
}
- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}
-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}
@end
