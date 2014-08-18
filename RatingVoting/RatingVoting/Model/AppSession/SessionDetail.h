//
//  SessionDetail.h
//  RatingVoting
//
//  Created by c85 on 07/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDetail.h"

@interface SessionDetail : NSObject

@property (nonatomic, strong) UserDetail *userDetail;
@property (nonatomic, assign) BOOL isLogin;

+ (SessionDetail *) currentSession;
void runOnMainQueueWithoutDeadlocking(void (^block)(void));
@end
