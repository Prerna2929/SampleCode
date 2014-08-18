//
//  CacheData.h
//  WillSend
//
//  Created by c32 on 20/03/14.
//  Copyright (c) 2014 c32. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^cacheDataGetCompletion)(BOOL, NSMutableArray*);

@interface CacheData : NSObject

+ (void)setCacheToUserDefaults:(NSMutableArray *)resPonseArrayList ForKey:(NSString *)strKey ;
+ (void) getcachedataArrayFor_:(NSString *)strKey myMethod:(cacheDataGetCompletion) compblock ;
+ (void)removeCacheForKey:(NSString *)objectKey ;


#pragma mark - Object
+ (void)setObjectCacheToUserDefaults:(id)resPonseObject ForKey:(NSString *)strKey ;
+ (id) getObjectCachedataFor_:(NSString *)strKey ;
@end
