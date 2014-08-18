//
//  ThemeManger.h
//  Bringaz
//
//  Created by Parth Patel on 08/05/14.
//  Copyright (c) 2014 AlexWard. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ThemeManger : NSObject

+(UIColor *)getSlideBarBgcolor;
+(UIColor *)getNavigationBarColor;
+(UIColor *)getNavigationTintColor;
+(UIColor *)getThemeRedColor;
+(UIColor *)getmediumGreen;
+(UIColor *)getdarkGreen;
+(UIColor *)getThemeColorForApp;
+(UIColor *)getThemeBackgroundColor;

+(UIFont *)getSymbolicFontSize:(int)Size;
+(UIFont *)getThemeFontWithSize:(CGFloat)size;
+(UIFont *)getThemeFontBoldWithSize:(CGFloat)size;
+(UIFont *)getThemeFontLightWithSize:(CGFloat)size;

@end
