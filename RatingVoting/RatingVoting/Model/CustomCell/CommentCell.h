//
//  CommentCell.h
//  SecretTestApp
//
//  Created by Aaron Pang on 3/29/14.
//  Copyright (c) 2014 Aaron Pang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LikeDisLikeCountChange <NSObject>
@required
- (void) changeCountForLikeComment : (BOOL) forLike
                        forComment : (NSString *) commentID
                        parentPost : (NSString *) postID
                       objectIndex : (int) index
                   forRemoveStatus : (BOOL) removeStatus ;
@end

typedef enum
{
    likeComment,
    disLikeComment,
    removeLike,
    removeDisLike
} LikeDisLikeServiceType;

@interface CommentCell : UITableViewCell
{
    __weak id <LikeDisLikeCountChange> countChangeDelegate;
}

extern const CGFloat kCommentPaddingFromLeft;
extern const CGFloat kCommentPaddingFromRight;

@property (nonatomic, weak) id <LikeDisLikeCountChange> countChangeDelegate;

@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *totalDisLikes;
@property (nonatomic, strong) UILabel *totalLikes;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *disLikeButton;
@property (nonatomic, strong) UIImageView *sepratorView;
@end
