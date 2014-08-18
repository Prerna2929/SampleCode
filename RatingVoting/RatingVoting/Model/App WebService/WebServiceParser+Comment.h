//
//  WebServiceParser+Comment.h
//  RatingVoting
//
//  Created by c32 on 09/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "WebServiceParser.h"

@interface WebServiceParser (Comment)
typedef enum
{
    WSGetAllComment,
    WSAddCommentToPost,
    WSLikeComment,
    WSRemoveLike,
    WSRemoveDisLike
} CommentServiceType;

- (void)CommentService:(CommentServiceType)comment
         parameters:(NSString*)parameters
      customeobject:(id)object
              block:(ResponseBlock)block;

@end