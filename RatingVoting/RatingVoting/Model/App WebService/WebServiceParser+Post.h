//
//  WebServiceParser+Post.h
//  RatingVoting
//
//  Created by c85 on 27/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "WebServiceParser.h"

typedef enum
{
    WSGetMyPost,
    WSCreateHashtag,
    WSCreatePost,
    WSGetAllPosts,
    WSMarkAsFavorite,
    WSGetNewPost,
    WSGetFollowingPosts,
    WSSHarePost
}WSPostType;

@interface WebServiceParser (Post)

- (void)PostRequest:(WSPostType)servicetype
                     parameters:(NSString*)parameters
                  customeobject:(id)object
                          block:(ResponseBlock)block;

@end
