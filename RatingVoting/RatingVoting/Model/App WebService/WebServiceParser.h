//
//  WebServiceParser
//
//  Created by Parth on 8/20/12.
//  Copyright (c) NarolaInfotech. All rights reserved.
//

/*
 * Queued server to manage concurrency and priority of NSURLRequests.
 */

#import <Foundation/Foundation.h>
#import "WebService-Prefix.h"
#import "ObjMapper.h"
#import "objc/runtime.h"
#import "NSUserDefaults+SaveCustomObject.h"
#import "Reachability.h"
#import "DefaultsValues.h"
#import "SVProgressHUD.h"

typedef void (^ResponseBlock)     (NSError *error, id objects, NSString *responseString,NSString *nextUrl);

enum RESPONCESTATUTS
{
  NORESPONCE=0,
  VALID = 1,
  INVALID = 2
};

#define Success @"success"
#define Failure @"failed"

@interface WebServiceParser : NSObject
{
    Reachability *reachability;
}

@property (strong) NSOperationQueue *WSoperationQueue;

+ (id)sharedMediaServer;

-(void)postRequestparameters:(NSData *)data customeobject:(id)object block:(ResponseBlock)block;
-(NSData *)dictionaryWithPropertiesOfObject:(id)obj;
-(NSData *)dictionaryWithmembersOfObject:(id)obj formembers:(NSArray *)members;
-(NSData *)dictionaryToJSONData:(NSDictionary *)dict;
@end
