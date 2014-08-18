//
//  CommentDetail.m
//  RatingVoting
//
//  Created by c32 on 08/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "CommentDetail.h"

NSString *const kCommentId = @"id";
NSString *const kCommentText = @"comment_text";
NSString *const kCommentBy = @"user_id";
NSString *const kCommentCreatedOn = @"created_on";
NSString *const kInappropriate = @"inappropriate";
NSString *const kCommentModifiedOn = @"modified_on";
NSString *const kParentPostID = @"post_id";
NSString *const kTotalLkesForComment = @"total_likes";
NSString *const kCommentedProfilePicture = @"profile_picture";
NSString *const kTotalDisLikes = @"total_dislikes";
NSString *const kOwnLikeStatus = @"logged_in_user_like_status";
NSString *const kCommentedUserName = @"username";

@implementation CommentDetail

@synthesize commentBy = _commentBy;
@synthesize commentId = _commentId;
@synthesize commentText = _commentText;
@synthesize commentCreatedOn = _commentCreatedOn;
@synthesize commentModification = _commentModification;
@synthesize commentParentPostID = _commentParentPostID;
@synthesize commentInappropriate = _commentInappropriate;
@synthesize commentDisLike = _commentDisLike;
@synthesize totalLike = _totalLike;
//@synthesize ownLikeStatus = _ownLikeStatus;
//@synthesize ownDisLikeStatus = _ownDisLikeStatus;
@synthesize commentedProfilePicture = _commentedProfilePicture;
@synthesize commentByUserName = _commentByUserName;
@synthesize ownLikeDisLikeStatus = _ownLikeDisLikeStatus;

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.commentBy = [self objectOrNilForKey:kCommentBy fromDictionary:dict];
        self.commentId = [self objectOrNilForKey:kCommentId fromDictionary:dict];
        self.commentText = [self objectOrNilForKey:kCommentText fromDictionary:dict];
        self.commentCreatedOn = [self objectOrNilForKey:kCommentCreatedOn fromDictionary:dict];
        self.commentModification = [self objectOrNilForKey:kCommentModifiedOn fromDictionary:dict];
        self.commentParentPostID = [self objectOrNilForKey:kParentPostID fromDictionary:dict];
        self.commentInappropriate = [self objectOrNilForKey:kInappropriate fromDictionary:dict];
        self.commentDisLike = [self objectOrNilForKey:kTotalDisLikes fromDictionary:dict];
        self.totalLike = [self objectOrNilForKey:kTotalLkesForComment fromDictionary:dict];
        self.commentedProfilePicture = [self objectOrNilForKey:kCommentedProfilePicture fromDictionary:dict];
        
        self.commentByUserName = [self objectOrNilForKey:kCommentedUserName fromDictionary:dict];
        
        self.ownLikeDisLikeStatus = [self objectOrNilForKey:kOwnLikeStatus fromDictionary:dict];
//        self.ownLikeStatus = [[self objectOrNilForKey:kOwnLikeStatus fromDictionary:dict] boolValue];
//        
//        self.ownDisLikeStatus = [[self objectOrNilForKey:kOwnLikeStatus fromDictionary:dict] boolValue];
//        [self objectOrNilForKey:kOwnLikeStatus fromDictionary:dict];
//        self.totalLike = [self objectOrNilForKey:kTotalLikes fromDictionary:dict];
        
    }
    return self;
}
#pragma mark - Helper Method

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
//    if ([self.commentId isEqualToString:@"107"] ||[self.commentId isEqualToString:@"108"]) {
//        NSLog(@"dasd");
//    }
//    if ([aKey isEqualToString:kOwnLikeStatus]) {
//        if ([object isEqual:[NSNull null]]) {
//            self.ownLikeStatus = NO;
//            self.ownDisLikeStatus = NO;
//        }
//        else {
//            if ([object isEqualToString:@"0"]) {
//                self.ownLikeStatus = NO;
//                self.ownDisLikeStatus = YES;
//            }
//            else if ([object isEqualToString:@"1"]) {
//                self.ownLikeStatus = YES;
//                self.ownDisLikeStatus = NO;
//            }
//        }
//    }
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end