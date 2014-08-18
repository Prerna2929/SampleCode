//
//  CommentCell.m
//  SecretTestApp
//
//  Created by Aaron Pang on 3/29/14.
//  Copyright (c) 2014 Aaron Pang. All rights reserved.
//

#import "CommentCell.h"
#import "WebServiceParser+Comment.h"

@implementation CommentCell

const CGFloat kCommentPaddingFromTop = 13.0f;
const CGFloat kCommentPaddingFromLeft = 10.0f;
const CGFloat kCommentPaddingFromRight = 8.0f;

@synthesize countChangeDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
        self.bgImg.image = [UIImage imageNamed:@"commentbackground"];
        self.bgImg.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.bgImg];
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.iconView.backgroundColor = [UIColor lightGrayColor];
        self.iconView.layer.cornerRadius = CGRectGetWidth(self.iconView.frame) / 2.0f;
        self.iconView.layer.masksToBounds = YES;
        [self addSubview:self.iconView];
        
        
        self.usernameLabel = [[UILabel alloc] init];
        self.usernameLabel.textColor = [ThemeManger getThemeColorForApp];
        self.usernameLabel.textAlignment = NSTextAlignmentLeft;
        self.usernameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f];
        self.usernameLabel.numberOfLines = 0;
        self.usernameLabel.frame = CGRectMake(61, 5, 270, 21);
        self.usernameLabel.text = @"name";
        [self addSubview:self.usernameLabel];
        
        self.commentLabel = [[UILabel alloc] init];
        self.commentLabel.textColor = [UIColor whiteColor];
        self.commentLabel.textAlignment = NSTextAlignmentLeft;
        self.commentLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.frame = (CGRect){.origin = {CGRectGetMinX(self.iconView.frame) + CGRectGetWidth(self.iconView.frame) + kCommentPaddingFromLeft, CGRectGetMinY(self.iconView.frame) + kCommentPaddingFromTop}};
        [self addSubview:self.commentLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f];
        self.timeLabel.numberOfLines = 1;
        [self addSubview:self.timeLabel];
        
        
        self.disLikeButton = [[UIButton alloc] init];
        self.disLikeButton.frame = (CGRect) {.origin = {250,CGRectGetMinY(self.commentLabel.frame)+15}, .size = {18,18}};
        [self.disLikeButton addTarget:self action:@selector(disLikeButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.disLikeButton];
        
        self.totalDisLikes = [[UILabel alloc] init];
        self.totalDisLikes.frame = (CGRect) {.origin = {275,CGRectGetMinY(self.commentLabel.frame)+12}, .size = {40,20}};
        self.totalDisLikes.textColor = [UIColor whiteColor];
        self.totalDisLikes.textAlignment = NSTextAlignmentLeft;
        self.totalDisLikes.font = [UIFont systemFontOfSize:12.f];
        self.totalDisLikes.numberOfLines = 1;
        self.totalDisLikes.text = @"Dislike";
        [self addSubview:self.totalDisLikes];
        
        
        
        
        self.likeButton = [[UIButton alloc] init];
        self.likeButton.frame = (CGRect) {.origin = {250,CGRectGetMinY(self.timeLabel.frame)+10}, .size = {18,18}};
        [self.likeButton addTarget:self action:@selector(likeButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.likeButton];
        
        self.totalLikes = [[UILabel alloc] init];
        self.totalLikes.frame = (CGRect) {.origin = {275,CGRectGetMinY(self.timeLabel.frame)+9}, .size = {40,20}};
        self.totalLikes.textColor = [UIColor whiteColor];
        self.totalLikes.textAlignment = NSTextAlignmentLeft;
        self.totalLikes.font = [UIFont systemFontOfSize:12.f];
        self.totalLikes.numberOfLines = 1;
        self.totalLikes.text = @"Like";
        [self addSubview:self.totalLikes];
        
        self.sepratorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 1)];
        self.sepratorView.backgroundColor = [UIColor clearColor];
        self.sepratorView.image = [UIImage imageNamed:@"divider"];
        [self addSubview:self.sepratorView];

    }
    return self;
}

- (void)likeButtonSelected:(id)sender {
    UIButton *btn = (UIButton *) sender;
    if (btn.imageView.image != [UIImage imageNamed:@"selfLiked"]) {
        [self addRemoveLikesFromComment:likeComment commentID:[(UIButton *) sender accessibilityIdentifier] onButton:btn];
    }
    else {
        [self addRemoveLikesFromComment:removeLike commentID:[(UIButton *) sender accessibilityIdentifier] onButton:btn];
    }
}

- (void)disLikeButtonSelected:(id)sender {
    UIButton *btn = (UIButton *) sender;
    if (btn.imageView.image != [UIImage imageNamed:@"selfDisliked"]) {
        [self addRemoveLikesFromComment:disLikeComment commentID:[(UIButton *) sender accessibilityIdentifier] onButton:btn];
    }
    else {
        [self addRemoveLikesFromComment:removeDisLike commentID:[(UIButton *) sender accessibilityIdentifier] onButton:btn];
    }
}

#pragma mark - add/remove lik from comment
- (void) addRemoveLikesFromComment : (LikeDisLikeServiceType) likeDislike commentID : (NSString *) commentid onButton : (UIButton *) btn
{
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    switch (likeDislike) {
        case likeComment:
        {
            [service CommentService:WSLikeComment parameters:[NSString stringWithFormat:@"comment_id=%@&user_id=%@&status=1", commentid,[SessionDetail currentSession].userDetail.userId] customeobject:nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
                if (error) {
                }
                else {
                    if ([responseString isEqualToString:@"success"])
                    {
                        TRC_DBG(@"Done");
                        [btn setImage:[UIImage imageNamed:@"selfLiked"] forState:UIControlStateNormal];
                        [countChangeDelegate changeCountForLikeComment:YES forComment:commentid parentPost:nil objectIndex:[btn tag] forRemoveStatus:NO];
                    }
                }
            }];
        }
            break;
        case disLikeComment:
        {
            [service CommentService:WSLikeComment parameters:[NSString stringWithFormat:@"comment_id=%@&user_id=%@&status=-1", commentid,[SessionDetail currentSession].userDetail.userId] customeobject:nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
                if (error) {
                }
                else {
                    if ([responseString isEqualToString:@"success"])
                    {
                        TRC_DBG(@"Done");
                        [btn setImage:[UIImage imageNamed:@"selfDisliked"] forState:UIControlStateNormal];
                        [countChangeDelegate changeCountForLikeComment:NO forComment:commentid parentPost:nil objectIndex:[btn tag] forRemoveStatus:NO];
                    }
                }
            }];
        }
            break;
        case removeDisLike:
        {
            [service CommentService:WSRemoveDisLike parameters:[NSString stringWithFormat:@"comment_id=%@&user_id=%@&status=0", commentid,[SessionDetail currentSession].userDetail.userId] customeobject:nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
                if (error) {
                }
                else {
                    if ([responseString isEqualToString:@"success"])
                    {
                        TRC_DBG(@"Done");
                        [btn setImage:[UIImage imageNamed:@"disLike"] forState:UIControlStateNormal];
                        [countChangeDelegate changeCountForLikeComment:NO forComment:commentid parentPost:nil objectIndex:[btn tag] forRemoveStatus:YES];
                    }
                }
            }];
        }
            break;
        case removeLike:
        {
            [service CommentService:WSRemoveLike parameters:[NSString stringWithFormat:@"comment_id=%@&user_id=%@&status=1", commentid,[SessionDetail currentSession].userDetail.userId] customeobject:nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
                if (error) {
                }
                else {
                    if ([responseString isEqualToString:@"success"])
                    {
                        TRC_DBG(@"Done");
                        [btn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                        [countChangeDelegate changeCountForLikeComment:YES forComment:commentid parentPost:nil objectIndex:[btn tag] forRemoveStatus:YES];
                    }
                }
            }];
        }
            break;
        default:
            break;
    }
}

@end
