//
//  SessionDetail.m
//  RatingVoting
//
//  Created by c85 on 07/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "SessionDetail.h"

@implementation SessionDetail

static SessionDetail *currentSession = nil;

+ (SessionDetail *) currentSession
{
    @synchronized(self)
	{
        if (currentSession == nil)
		{
            currentSession = [[super allocWithZone:NULL] init];
            currentSession.userDetail = [[UserDetail alloc]init];
            
            currentSession.userDetail.username = [DefaultsValues
                                  getStringValueFromUserDefaults_ForKey:kUserName];
            currentSession.userDetail.email =[DefaultsValues
                                   getStringValueFromUserDefaults_ForKey:kUserEmailId];
            currentSession.userDetail.userId =[DefaultsValues
                                    getStringValueFromUserDefaults_ForKey:kUserId];
            currentSession.userDetail.password =[DefaultsValues
                                      getStringValueFromUserDefaults_ForKey:kUserPassword];
            if (currentSession.userDetail.userId!=0)
            {
                currentSession.isLogin=YES;
            }
            
//            currentSession.oprationQueue=[[NSOperationQueue alloc]init];
//            currentSession.oprationQueue.maxConcurrentOperationCount=2;
            
        }
    }
    return currentSession;
}


void runOnMainQueueWithoutDeadlocking(void (^block)(void))
{
    if ([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

//- (id)init;
//{
//    if ( ( self = [super init] ) )
//    {
//        // The maxConcurrentOperationCount should reflect the number of open
//        // connections the server can handle. Right now, limit it to two for
//        // the sake of this example.
//        //_operationQueue = [[NSOperationQueue alloc] init];
//        //_operationQueue.maxConcurrentOperationCount = 10;
//    }
//    return self;
//}

@end
