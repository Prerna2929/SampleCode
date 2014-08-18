//
//  WebServiceParser+VotePost.h
//  RatingVoting
//
//  Created by c32 on 08/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "WebServiceParser.h"

typedef enum
{
    DirectionUP = 1,
    DirectionDOWN = 2
} DirectionType;

@interface WebServiceParser (VotePost)

- (void)VotePostRequest:(DirectionType)direction
              parameters:(NSString*)parameters
           customeobject:(id)object
                   block:(ResponseBlock)block;

@end