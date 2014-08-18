//
//  CacheData.m
//  My Follower App
//
//  Created by c32 on 20/03/14.
//  Copyright (c) 2014 c32. All rights reserved.
//

#import "CacheData.h"
#import "NSUserDefaults+SaveCustomObject.h"

@implementation CacheData

#pragma mark - array of objects
+ (void)setCacheToUserDefaults:(NSMutableArray *)resPonseArrayList ForKey:(NSString *)strKey
{
    @autoreleasepool
    {
        NSUserDefaults *cacheDataArray = [NSUserDefaults standardUserDefaults];
        [cacheDataArray setCustomObject:resPonseArrayList forKey:strKey];
        resPonseArrayList = nil;
    }
}

+ (void) getcachedataArrayFor_:(NSString *)strKey
                                  myMethod:(cacheDataGetCompletion) compblock
{
    @autoreleasepool
    {
        NSMutableArray *retrivedCacheData = [[NSMutableArray alloc] init];
        NSUserDefaults *cacheDataRetriveArray = [NSUserDefaults standardUserDefaults];
        [retrivedCacheData addObjectsFromArray:[cacheDataRetriveArray customObjectForKey:strKey]];
        
        compblock(YES, retrivedCacheData);
        
//        return retrivedCacheData;
    }
}

#pragma mark - object
+ (void)setObjectCacheToUserDefaults:(id)resPonseObject ForKey:(NSString *)strKey
{
    @autoreleasepool
    {
        NSUserDefaults *cacheDataArray = [NSUserDefaults standardUserDefaults];
        [cacheDataArray setCustomObject:resPonseObject forKey:strKey];
        resPonseObject = nil;
    }
}

+ (id) getObjectCachedataFor_:(NSString *)strKey
{
    @autoreleasepool
    {
        id retrivedObject;
        NSUserDefaults *cacheDataRetriveArray = [NSUserDefaults standardUserDefaults];
        retrivedObject = [cacheDataRetriveArray customObjectForKey:strKey];
        return retrivedObject;
    }
}

+ (void)removeCacheForKey:(NSString *)objectKey
{
    @autoreleasepool
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:objectKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
