//
//  ThemeManger.m
//  Bringaz
//
//  Created by Parth Patel on 08/05/14.
//  Copyright (c) 2014 AlexWard. All rights reserved.
//

#import "ThemeManger.h"

static NSString *const kFontAwesomeFamilyName = @"FontAwesome";
static NSString *const kFontOpenSansFamilyName = @"Open Sans";
static NSString *const kFontOpenSansBoldName = @"Open Sans Bold";
static NSString *const kFontOpenSansLightName = @"Open Sans Light";

@implementation ThemeManger

#pragma mark - Color Ref

#define CUSTOM_COLOR(r,g,b,a)           [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0    alpha:a]

#define THEME_BLUE_COLOR                [UIColor colorWithRed:0.0 green:0.70 blue:0.92 alpha:1.0]

#define THEME_GRAY_COLOR                [UIColor colorWithRed:0.28 green:0.28 blue:0.28                  alpha:1.0]

#define THEME_WHITE_COLOR                [UIColor colorWithRed:247.0/255.0 green:249.0/255.0 blue:250.0/255.0 alpha:1.0]


+(UIColor *)getmediumGreen
{
    return  [UIColor greenColor];
}

+(UIColor *)getdarkGreen
{
    return  [UIColor greenColor];
}

+(UIColor *)getSlideBarBgcolor
{
    return THEME_GRAY_COLOR;
}

+(UIColor *)getNavigationBarColor
{
    return [UIColor colorWithRed:0.0 green:0.73 blue:0.84 alpha:1.0];
}

+(UIColor *)getThemeRedColor
{
    return [UIColor redColor];
}

+(UIColor *)getThemeGreenColor
{
    return [UIColor colorWithRed:.15 green:.68 blue:.38 alpha:1];
}

+(UIColor *)getThemeColorForApp;
{
    return [UIColor colorWithRed:0.0 green:0.73 blue:0.84 alpha:1.0];
}

+(UIColor *)getThemeBackgroundColor
{
    return [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1.0];
}

+(UIColor *)getNavigationTintColor
{
    return THEME_WHITE_COLOR;
}

+(UIFont *)getSymbolicFontSize:(int)Size
{
    return [UIFont fontWithName:kFontAwesomeFamilyName size:Size];
}

+ (UIFont *)getThemeFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:kFontOpenSansFamilyName size:size];
}

+ (UIFont *)getThemeFontBoldWithSize:(CGFloat)size {
    return [UIFont fontWithName:kFontOpenSansBoldName size:size];
}

+ (UIFont *)getThemeFontLightWithSize:(CGFloat)size {
    return [UIFont fontWithName:kFontOpenSansLightName size:size];
}
@end
