//
//  WebServiceParser+FavouritePost.h
//  RatingVoting
//
//  Created by c85 on 27/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "WebServiceParser.h"

typedef enum
{
    WSGetFavouritePost
}WSFavouritePostType;

@interface WebServiceParser (FavouritePost)

- (void)getFavouritePostRequest:(WSFavouritePostType)servicetype
               parameters:(NSString*)parameters
            customeobject:(id)object
                    block:(ResponseBlock)block;
@end
