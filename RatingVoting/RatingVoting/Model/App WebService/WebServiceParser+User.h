//
//  WebServiceParser+User.h
//  RatingVoting
//
//  Created by c32 on 08/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "WebServiceParser.h"

@interface WebServiceParser (User)

typedef enum
{
    WSGetUserInfo,
    WSGetAllNames,
    WSFollowUnFollowUser,
    WSGetAllNotifications,
    WSUpdateUserProfile
} ServiceUserType;

- (void)GetUserInfo:(ServiceUserType)serviceName
             parameters:(NSString*)parameters
          customeobject:(id)object
                  block:(ResponseBlock)block;

@end