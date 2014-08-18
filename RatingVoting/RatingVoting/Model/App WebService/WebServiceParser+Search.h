//
//  WebServiceParser+Search.h
//  RatingVoting
//
//  Created by c85 on 26/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "WebServiceParser.h"
typedef enum
{
    WSSearchUser,
    WSSearchHasTag
} WSSearchType;

@interface WebServiceParser (Search)

- (void)searchRequest:(WSSearchType)servicetype
          parameters:(NSString*)parameters
       customeobject:(id)object
               block:(ResponseBlock)block;
@end
