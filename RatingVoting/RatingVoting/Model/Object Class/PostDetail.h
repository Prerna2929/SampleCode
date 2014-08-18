//
//  PostDetail.h
//  RatingVoting
//
//  Created by c85 on 26/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommentDetail.h"

@interface PostDetail : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSString *postVideo;
@property (nonatomic, strong) NSString *totalViews;
@property (nonatomic, strong) NSString *anonymous;
@property (nonatomic, strong) NSString *modifiedOn;
@property (nonatomic, strong) NSString *totalDownVotes;
@property (nonatomic, strong) NSString *postText;
@property (nonatomic, strong) NSString *postImage;
@property (nonatomic, strong) NSString *inappropriate;
@property (nonatomic, strong) NSString *videoFrame;
@property (nonatomic, strong) NSString *totalUpVotes;
@property (nonatomic, strong) NSString *createdOn;
@property (nonatomic, strong) NSString *postedBy;
@property (nonatomic, strong) NSString *duplicatePostId;
@property (nonatomic, strong) NSString *hashtags;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *profilePic;
@property (nonatomic, strong) NSString *postByUserName;
@property (nonatomic, strong) NSString *postType;
@property (nonatomic, assign) BOOL isFavourite;

@property (nonatomic, strong) NSString *battleID;
@property (nonatomic, strong) NSString *to_userPost;

@property (nonatomic,  strong) UIImage *fromPostImage;
@property (nonatomic,  strong) UIImage *toPostImage;


@property (nonatomic, assign) int commentsCount;
@property (nonatomic, strong) CommentDetail *comments;
@property (nonatomic, strong) NSMutableArray *commentDetailArray, *commentTextArray;
@property (nonatomic, strong) NSMutableArray *commentLikeDetailArray;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end

