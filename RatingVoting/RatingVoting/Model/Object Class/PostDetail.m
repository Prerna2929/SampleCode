//
//  PostDetail.m
//  RatingVoting
//
//  Created by c85 on 26/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "PostDetail.h"
#import "LikeDetail.h"
//#import "FromPostImageDownloader.h"
//#import "ToPostImageDownloader.h"

#define NO_COMMENTS_TEXT @"No comments found."

NSString *const kPostDetailId = @"id";
NSString *const kPostDetailPostVideo = @"post_video";
NSString *const kPostDetailTotalViews = @"total_views";
NSString *const kPostDetailAnonymous = @"anonymous";
NSString *const kPostDetailModifiedOn = @"modified_on";
NSString *const kPostDetailTotalDownVotes = @"total_down_votes";
NSString *const kPostDetailPostText = @"post_text";
NSString *const kPostDetailPostImage = @"post_image";
NSString *const kPostDetailInappropriate = @"inappropriate";
NSString *const kPostDetailVideoFrame = @"video_frame";
NSString *const kPostDetailTotalUpVotes = @"total_up_votes";
NSString *const kPostDetailCreatedOn = @"created_on";
NSString *const kPostDetailPostedBy = @"posted_by";
NSString *const kPostDetailDuplicatePostId = @"duplicate_post_id";
NSString *const kPostDetailHashtags = @"hashtags";
NSString *const kPostDetailStatus = @"status";
NSString *const kCommentDetail = @"comments";
NSString *const kUserProfilePic = @"profile_picture";
NSString *const kTotalLikes = @"comment_like_details";
NSString *const kLikeUserId = @"user_id";
NSString *const kLikeUserName = @"username";
NSString *const kLikeEmail = @"email";
NSString *const kLikeNickName = @"nickname";
NSString *const kIsFavourite = @"is_favourite";
NSString *const kPostByUsername = @"username";
NSString *const kPostType = @"post_type";
NSString *const kBattleID = @"BattleID";
NSString *const kToUserPost = @"to_user_post";


//static NSString * OperationsFromPostDownloadContext = @"OperationsFromPostDownloadContext";
//
//static NSString * OperationsToPostDownloadContext = @"OperationsToPostDownloadContext";


@interface PostDetail ()
//{
//    NSOperationQueue *fromPostDownloader ;
//    NSOperationQueue *toPostDownloader ;
//}
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PostDetail

@synthesize postId = _postId;
@synthesize postVideo = _postVideo;
@synthesize totalViews = _totalViews;
@synthesize anonymous = _anonymous;
@synthesize modifiedOn = _modifiedOn;
@synthesize totalDownVotes = _totalDownVotes;
@synthesize postText = _postText;
@synthesize postImage = _postImage;
@synthesize inappropriate = _inappropriate;
@synthesize videoFrame = _videoFrame;
@synthesize totalUpVotes = _totalUpVotes;
@synthesize createdOn = _createdOn;
@synthesize postedBy = _postedBy;
@synthesize duplicatePostId = _duplicatePostId;
@synthesize hashtags = _hashtags;
@synthesize status = _status;
@synthesize profilePic = _profilePic;
@synthesize comments = _comments;
@synthesize commentsCount = _commentsCount;
@synthesize commentDetailArray = _commentDetailArray;
@synthesize commentTextArray = _commentTextArray;
@synthesize postType = _postType;
@synthesize commentLikeDetailArray = _commentLikeDetailArray;
@synthesize postByUserName = _postByUserName;
@synthesize battleID = _battleID;
@synthesize to_userPost = _to_userPost;
@synthesize fromPostImage = _fromPostImage;
@synthesize toPostImage = _toPostImage;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.postId = [self objectOrNilForKey:kPostDetailId fromDictionary:dict];
        self.postVideo = [self objectOrNilForKey:kPostDetailPostVideo fromDictionary:dict];
        self.totalViews = [self objectOrNilForKey:kPostDetailTotalViews fromDictionary:dict];
        self.anonymous = [self objectOrNilForKey:kPostDetailAnonymous fromDictionary:dict];
        self.modifiedOn = [self objectOrNilForKey:kPostDetailModifiedOn fromDictionary:dict];
        self.totalDownVotes = [self objectOrNilForKey:kPostDetailTotalDownVotes fromDictionary:dict];
        self.postText = [self objectOrNilForKey:kPostDetailPostText fromDictionary:dict];
        self.postImage = [self objectOrNilForKey:kPostDetailPostImage fromDictionary:dict];
        self.inappropriate = [self objectOrNilForKey:kPostDetailInappropriate fromDictionary:dict];
        self.profilePic = [self objectOrNilForKey:kUserProfilePic fromDictionary:dict];
        self.videoFrame = [self objectOrNilForKey:kPostDetailVideoFrame fromDictionary:dict];
        self.totalUpVotes = [self objectOrNilForKey:kPostDetailTotalUpVotes fromDictionary:dict];
        self.createdOn = [self objectOrNilForKey:kPostDetailCreatedOn fromDictionary:dict];
        self.postedBy = [self objectOrNilForKey:kPostDetailPostedBy fromDictionary:dict];
        self.duplicatePostId = [self objectOrNilForKey:kPostDetailDuplicatePostId fromDictionary:dict];
        self.hashtags = [self objectOrNilForKey:kPostDetailHashtags fromDictionary:dict];
        self.status = [self objectOrNilForKey:kPostDetailStatus fromDictionary:dict];
        self.isFavourite = [[self objectOrNilForKey:kIsFavourite fromDictionary:dict] boolValue];
        self.postByUserName = [self objectOrNilForKey:kPostByUsername fromDictionary:dict];
        self.postType = [self objectOrNilForKey:kPostType fromDictionary:dict];
        self.battleID = [self objectOrNilForKey:kBattleID fromDictionary:dict];
//        if (self.battleID != nil)
//        {
//            if ([self.to_userPost isEqualToString:@"0"]) {
//                fromPostDownloader = [[NSOperationQueue alloc] init];
//                
//                [fromPostDownloader addObserver:self
//                                     forKeyPath:@"operations"
//                                        options:0
//                                        context:&OperationsFromPostDownloadContext];
//                
//                FromPostImageDownloader * fromOperation = [FromPostImageDownloader urlRequestWithUrlString:self.postImage battleid:self.battleID];
//                [fromPostDownloader addOperation:fromOperation];
//            }
//            else {
//                toPostDownloader = [[NSOperationQueue alloc] init];
//                
//                [toPostDownloader addObserver:self
//                                   forKeyPath:@"operations"
//                                      options:0
//                                      context:&OperationsToPostDownloadContext];
//                
//                ToPostImageDownloader * toOperation = [ToPostImageDownloader urlRequestWithUrlString:self.postImage battleid:self.battleID];
//                [toPostDownloader addOperation:toOperation];
//            }
//            
//        }
        self.to_userPost = [self objectOrNilForKey:kToUserPost fromDictionary:dict];
        
        
        if ([[dict objectForKey:@"comments"]  isKindOfClass:[NSArray class]])
        {
            self.commentDetailArray = [NSMutableArray new];
            self.commentTextArray = [NSMutableArray new];
            NSArray *CommentArray=[dict objectForKey:@"comments"];
            self.commentsCount= [[dict objectForKey:@"total_comments"] integerValue];
            for (NSDictionary *Dic in CommentArray)
            {
                CommentDetail *commentobj=[[CommentDetail alloc] initWithDictionary:Dic];
                
                [self.commentTextArray addObject:[Dic objectForKey:@"comment_text"]];
                
                [self.commentDetailArray addObject:commentobj];
            }
            
            if ([[dict objectForKey:@"comment_like_details"]  isKindOfClass:[NSArray class]])
            {
                self.commentLikeDetailArray = [NSMutableArray new];
                NSArray *likeArray = [dict  objectForKey:@"comment_like_details"];
                for (NSDictionary *Dic in likeArray)
                {
                    LikeDetail *likeDetail  = [LikeDetail new];
                    
                    likeDetail.likeEmail = [self objectOrNilForKey:kLikeEmail fromDictionary:Dic];
                    likeDetail.likeNickName = [self objectOrNilForKey:kLikeNickName fromDictionary:Dic];
                    likeDetail.likeUerId = [self objectOrNilForKey:kLikeUserId fromDictionary:Dic];
                    likeDetail.likeUsername = [self objectOrNilForKey:kLikeUserName fromDictionary:Dic];
                    
                    [self.commentLikeDetailArray addObject:likeDetail];
                }
            }
        }
        else if ([[dict objectForKey:@"comments"]  isKindOfClass:[NSString class]])
        {
            self.commentsCount = 0;
        }
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.postId forKey:kPostDetailId];
    [mutableDict setValue:self.postVideo forKey:kPostDetailPostVideo];
    [mutableDict setValue:self.totalViews forKey:kPostDetailTotalViews];
    [mutableDict setValue:self.anonymous forKey:kPostDetailAnonymous];
    [mutableDict setValue:self.modifiedOn forKey:kPostDetailModifiedOn];
    [mutableDict setValue:self.totalDownVotes forKey:kPostDetailTotalDownVotes];
    [mutableDict setValue:self.postText forKey:kPostDetailPostText];
    [mutableDict setValue:self.postImage forKey:kPostDetailPostImage];
    [mutableDict setValue:self.inappropriate forKey:kPostDetailInappropriate];
    [mutableDict setValue:self.videoFrame forKey:kPostDetailVideoFrame];
    [mutableDict setValue:self.totalUpVotes forKey:kPostDetailTotalUpVotes];
    [mutableDict setValue:self.createdOn forKey:kPostDetailCreatedOn];
    [mutableDict setValue:self.postedBy forKey:kPostDetailPostedBy];
    [mutableDict setValue:self.duplicatePostId forKey:kPostDetailDuplicatePostId];
    [mutableDict setValue:self.hashtags forKey:kPostDetailHashtags];
    [mutableDict setValue:self.status forKey:kPostDetailStatus];
    
    [mutableDict setValue:self.profilePic forKey:kUserProfilePic];
    
    [mutableDict setValue:self.postByUserName forKey:kUserName];
    
    [mutableDict setValue:self.postType forKey:kPostType];
    
    [mutableDict setValue:self.battleID forKey:kBattleID];
    
    [mutableDict setValue:self.to_userPost forKey:kToUserPost];
    
//    [mutableDict setValue:self.isFavourite forKey:kIsFavourite];
    
//    [mutableDict setValue:self.to_userPost forKey:kPostType];
//    
//    [mutableDict setValue:self.from_userPost forKey:k];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.postId = [aDecoder decodeObjectForKey:kPostDetailId];
    self.postVideo = [aDecoder decodeObjectForKey:kPostDetailPostVideo];
    self.totalViews = [aDecoder decodeObjectForKey:kPostDetailTotalViews];
    self.anonymous = [aDecoder decodeObjectForKey:kPostDetailAnonymous];
    self.modifiedOn = [aDecoder decodeObjectForKey:kPostDetailModifiedOn];
    self.totalDownVotes = [aDecoder decodeObjectForKey:kPostDetailTotalDownVotes];
    self.postText = [aDecoder decodeObjectForKey:kPostDetailPostText];
    self.postImage = [aDecoder decodeObjectForKey:kPostDetailPostImage];
    self.inappropriate = [aDecoder decodeObjectForKey:kPostDetailInappropriate];
    self.videoFrame = [aDecoder decodeObjectForKey:kPostDetailVideoFrame];
    self.totalUpVotes = [aDecoder decodeObjectForKey:kPostDetailTotalUpVotes];
    self.createdOn = [aDecoder decodeObjectForKey:kPostDetailCreatedOn];
    self.postedBy = [aDecoder decodeObjectForKey:kPostDetailPostedBy];
    self.duplicatePostId = [aDecoder decodeObjectForKey:kPostDetailDuplicatePostId];
    self.hashtags = [aDecoder decodeObjectForKey:kPostDetailHashtags];
    self.status = [aDecoder decodeObjectForKey:kPostDetailStatus];
    
    self.profilePic = [aDecoder decodeObjectForKey:kUserProfilePic];
    
    self.postByUserName = [aDecoder decodeObjectForKey:kUserName];
    
    self.postType = [aDecoder decodeObjectForKey:kPostType];
    
    self.battleID = [aDecoder decodeObjectForKey:kBattleID];
    
    self.to_userPost = [aDecoder decodeObjectForKey:kToUserPost];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_postId forKey:kPostDetailId];
    [aCoder encodeObject:_postVideo forKey:kPostDetailPostVideo];
    [aCoder encodeObject:_totalViews forKey:kPostDetailTotalViews];
    [aCoder encodeObject:_anonymous forKey:kPostDetailAnonymous];
    [aCoder encodeObject:_modifiedOn forKey:kPostDetailModifiedOn];
    [aCoder encodeObject:_totalDownVotes forKey:kPostDetailTotalDownVotes];
    [aCoder encodeObject:_postText forKey:kPostDetailPostText];
    [aCoder encodeObject:_postImage forKey:kPostDetailPostImage];
    [aCoder encodeObject:_inappropriate forKey:kPostDetailInappropriate];
    [aCoder encodeObject:_videoFrame forKey:kPostDetailVideoFrame];
    [aCoder encodeObject:_totalUpVotes forKey:kPostDetailTotalUpVotes];
    [aCoder encodeObject:_createdOn forKey:kPostDetailCreatedOn];
    [aCoder encodeObject:_postedBy forKey:kPostDetailPostedBy];
    [aCoder encodeObject:_duplicatePostId forKey:kPostDetailDuplicatePostId];
    [aCoder encodeObject:_hashtags forKey:kPostDetailHashtags];
    [aCoder encodeObject:_status forKey:kPostDetailStatus];
    
    [aCoder encodeObject:_profilePic forKey:kUserProfilePic];
    
    [aCoder encodeObject:_postByUserName forKey:kUserName];
    
    [aCoder encodeObject:_postType forKey:kPostType];
    
    [aCoder encodeObject:_battleID forKey:kBattleID];
    [aCoder encodeObject:_to_userPost forKey:kToUserPost];
}

- (id)copyWithZone:(NSZone *)zone
{
    PostDetail *copy = [[PostDetail alloc] init];
    
    if (copy) {
        
        copy.postId = [self.postId copyWithZone:zone];
        copy.postVideo = [self.postVideo copyWithZone:zone];
        copy.totalViews = [self.totalViews copyWithZone:zone];
        copy.anonymous = [self.anonymous copyWithZone:zone];
        copy.modifiedOn = [self.modifiedOn copyWithZone:zone];
        copy.totalDownVotes = [self.totalDownVotes copyWithZone:zone];
        copy.postText = [self.postText copyWithZone:zone];
        copy.postImage = [self.postImage copyWithZone:zone];
        copy.inappropriate = [self.inappropriate copyWithZone:zone];
        copy.videoFrame = [self.videoFrame copyWithZone:zone];
        copy.totalUpVotes = [self.totalUpVotes copyWithZone:zone];
        copy.createdOn = [self.createdOn copyWithZone:zone];
        copy.postedBy = [self.postedBy copyWithZone:zone];
        copy.duplicatePostId = [self.duplicatePostId copyWithZone:zone];
        copy.hashtags = [self.hashtags copyWithZone:zone];
        copy.status = [self.status copyWithZone:zone];
        
        copy.profilePic = [self.profilePic copyWithZone:zone];
        
        copy.postByUserName = [self.postByUserName copyWithZone:zone];
        
        copy.postType = [self.postType copyWithZone:zone];
        
        copy.battleID = [self.battleID copyWithZone:zone];
        copy.to_userPost = [self.to_userPost copyWithZone:zone];
    }
    
    return copy;
}

//#pragma mark - observer for NSOperation
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary *)change
//                       context:(void *)context
//{
//    if (context == &OperationsFromPostDownloadContext)
//    {
//        NSLog(@"%lu", (unsigned long)[fromPostDownloader operationCount]);
//        
//        PostDetail *post = (PostDetail *) object;
//        
//        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//        [nc postNotificationName:@"BattleImageDownloaded" object:post userInfo:nil];
//        
//        if ([[fromPostDownloader operations] count] == 0)
//        {
//            fromPostDownloader = nil;
//            
//            NSLog(@"From post Operation Completed");
//        }
//    }
//    else if (context == &OperationsToPostDownloadContext)
//    {
//        NSLog(@"%lu", (unsigned long)[toPostDownloader operationCount]);
//        
//        PostDetail *post = (PostDetail *) object;
//        
//        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//        [nc postNotificationName:@"BattleImageDownloaded" object:post userInfo:nil];
//        
//        if ([[toPostDownloader operations] count] == 0)
//        {
//            toPostDownloader = nil;
//            
//            NSLog(@"To post Operation Completed");
//        }
//    }
//    else
//    {
//        [super observeValueForKeyPath:keyPath
//                             ofObject:object
//                               change:change
//                              context:context];
//    }
//}

@end