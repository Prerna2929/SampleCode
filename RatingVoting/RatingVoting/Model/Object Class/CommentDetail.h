//
//  CommentDetail.h
//  RatingVoting
//
//  Created by c32 on 08/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentDetail : NSObject

@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *commentText;
@property (nonatomic, strong) NSString *commentBy;
@property (nonatomic, strong) NSString *commentByUserName;
@property (nonatomic, strong) NSString *commentCreatedOn;
@property (nonatomic, strong) NSString *commentInappropriate;
@property (nonatomic, strong) NSString *commentModification;
@property (nonatomic, strong) NSString *commentParentPostID;
@property (nonatomic, strong) NSString *commentDisLike;
@property (nonatomic, strong) NSString *commentLikes;
@property (nonatomic, strong) NSString *totalLike;
@property (nonatomic, strong) NSString *commentedProfilePicture;
@property (nonatomic, strong) NSString *ownLikeDisLikeStatus;
//@property (nonatomic, assign) BOOL ownLikeStatus;
//@property (nonatomic, assign) BOOL ownDisLikeStatus;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end