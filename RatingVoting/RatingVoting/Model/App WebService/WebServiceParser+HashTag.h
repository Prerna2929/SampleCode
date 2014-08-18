//
//  WebServiceParser+HashTag.h
//  RatingVoting
//
//  Created by c32 on 03/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "WebServiceParser.h"

@interface WebServiceParser (HashTag)

typedef enum
{
    WSGetAllhashTag
} WSServiceType;

- (void)HastTagRequest:(WSServiceType)servicetype
         parameters:(NSString*)parameters
      customeobject:(id)object
              block:(ResponseBlock)block;

@end
