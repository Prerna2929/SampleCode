//
//  WebServiceParser+Followers.h
//  RatingVoting
//
//  Created by c32 on 07/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "WebServiceParser.h"

@interface WebServiceParser (Followers)

typedef enum
{
    WSGetAllFollowers
} WSServiceType;

- (void)FollowersRequest:(WSServiceType)servicetype
              parameters:(NSString*)parameters
           customeobject:(id)object
                   block:(ResponseBlock)block;


@end