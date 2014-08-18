//
//  UIImage+ZigZag.m
//  RatingVoting
//
//  Created by c32 on 28/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "UIImage+ZigZag.h"

@implementation UIImage (ZigZag)

/*
 Create image with "zigzag" separator line from 2 source images
 Steps to acheive the desired output:
 1: Create first image with zigzag edge on the right - change value of "width" variable as necessary to extend/reduce the visible area other than zigzag edge.
 2: Draw "second image" in the context (canvas) as it is, but overlayed by first image with zigzag edge generated in the step 1 above. Draw zigzag line in desired color on the image from step2 above using the same curve path.
 */
+(UIImage *)zigZagImageFrom:(UIImage *)firstImage secondImage:(UIImage *)secondimage
{
    CGFloat width = firstImage.size.width/2; //how much of the first image you would want to keep visible other than the zigzag edges.
    CGFloat height = firstImage.size.height;
    
    int totalZigzagCurves = 20;  // total no of waypoints in the zigzag path.
    CGFloat zigzagCurveWidth = width/30; // width of a single zigzag curve line.
    CGFloat zigzagCurveHeight = height/totalZigzagCurves; //height of a single zigzag curve line.
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    UIGraphicsBeginImageContextWithOptions(firstImage.size, NO, scale);
    
    // -- STEP 1 --
    
    //We will make a clipping path in zigzag style
    UIBezierPath *zigzagPath = [[UIBezierPath alloc] init];
    
    //Begining point of the zigzag path
    [zigzagPath moveToPoint:CGPointMake(0, 0)];
    
    //draw zigzag path starting from somewhere middle on the top to bottom. - must be same for zigzag line in step 3.
    
    int a=-1;
    for (int i=0; i<totalZigzagCurves+2; i++) {
        [zigzagPath addLineToPoint:CGPointMake(width+(zigzagCurveWidth*a), zigzagCurveHeight*i + [self randomCurvePoint:i])];
        a= a*-1;
    }
    
    [zigzagPath addLineToPoint:CGPointMake(0, height)];
    
    //remove the remaining (right side) of image using zigzag path.
    [zigzagPath addClip];
    
    [firstImage drawAtPoint:CGPointMake(0, 0)];
    
    //Output first image with zigzag edge.
    UIImage *firstHalfOfImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    //We have the first image with zigzag edge. Now draw it over the second source image followed by zigzag line
    UIGraphicsBeginImageContextWithOptions(firstImage.size, YES, scale);
    
    // -- STEP 2 --
    
    //draw first & second image so that we can draw the zigzag line on it.
    [secondimage drawAtPoint:CGPointMake(0, 0)];
    [firstHalfOfImage drawAtPoint:CGPointMake(0, 0)];
    
    // -- STEP 3 --
    
    //Draw zigzag line over image using same curves.
    zigzagPath = [[UIBezierPath alloc] init];
    
    //Begining point of the zigzag line
    [zigzagPath moveToPoint:CGPointMake(width, -5)];
    
    //draw zigzag line path starting from somewhere middle on the top to bottom.
    a=-1;
    for (int i=0; i<totalZigzagCurves+2; i++) {
        [zigzagPath addLineToPoint:CGPointMake(width+(zigzagCurveWidth*a), zigzagCurveHeight*i + [self randomCurvePoint:i])];
        a= a*-1;
    }
    
    
    //Set color for zigzag line.
    [[UIColor whiteColor] setStroke];
    
    //Set width for zigzag line.
    [zigzagPath setLineWidth:6.0];
    
    //Finally, draw zigzag line over the image.
    [zigzagPath stroke];
    
    //Output final image with zigzag.
    UIImage *zigzagImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Desired output
    return zigzagImage;
}

//To make some of the zigzag curves/waypoints with variable height
+(int)randomCurvePoint:(int)value{
    if (value == 0 ||  value == 2 ) return -8;
    else if (value == 4  ||   value == 5 || value == 17 || value == 18) return 28;
    else if (value == 16 ||  value == 8  || value == 9  || value == 19) return 2;
    else if (value == 12 ||  value == 13 || value == 14 || value == 15) return -29;
    else return 1;
}

@end