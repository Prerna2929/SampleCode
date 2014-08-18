//
//  DefaultsValues.m
//  Informer
//
//  Created by c33 on 06/08/13.
//  Copyright (c) 2013 c33. All rights reserved.
//

#import "DefaultsValues.h"

@implementation DefaultsValues

#pragma mark -
#pragma mark - Defaults String Values

+ (void)setStringValueToUserDefaults:(NSString *)strValue ForKey:(NSString *)strKey
{
    if ([NSUserDefaults standardUserDefaults]) {
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@", strValue] forKey:strKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *)getStringValueFromUserDefaults_ForKey:(NSString *)strKey
{
    NSString *s = nil;
    if ([NSUserDefaults standardUserDefaults]) {
        s =[[NSUserDefaults standardUserDefaults] valueForKey:strKey];
    }
    return s;
}

#pragma mark - Defaults Integer Values

+ (void)setIntegerValueToUserDefaults:(int)intValue ForKey:(NSString *)intKey
{
    if ([NSUserDefaults standardUserDefaults]) {
        [[NSUserDefaults standardUserDefaults] setInteger:intValue forKey:intKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (int)getIntegerValueFromUserDefaults_ForKey:(NSString *)intKey
{
    int i = 0;
    if ([NSUserDefaults standardUserDefaults]) {
        i = [[NSUserDefaults standardUserDefaults] integerForKey:intKey];
    }
    return i;
}

#pragma mark - Defaults Boolean Values

+ (void)setBooleanValueToUserDefaults:(bool)booleanValue ForKey:(NSString *)booleanKey
{
    if ([NSUserDefaults standardUserDefaults]) {
        [[NSUserDefaults standardUserDefaults] setBool:booleanValue forKey:booleanKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (bool)getBooleanValueFromUserDefaults_ForKey:(NSString *)booleanKey
{
    bool b = false;
    if ([NSUserDefaults standardUserDefaults]) {
        b = [[NSUserDefaults standardUserDefaults] boolForKey:booleanKey];
    }
    return b;
}

#pragma mark - Remove Defaults Values

+ (void)removeObjectForKey:(NSString *)objectKey
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:objectKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(void)setCustomeObjToUserDefaults:(id)CustomeObj ForKey:(NSString *)CustomeObjKey
{
     [[NSUserDefaults standardUserDefaults] setCustomObject:CustomeObj forKey:CustomeObjKey];
}

+(id)getCustomeObjFromUserDefaults_ForKey:(NSString *)CustomeObjKey
{
   return [[NSUserDefaults standardUserDefaults] customObjectForKey:CustomeObjKey];
}

@end
