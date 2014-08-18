//
//  TrendHeaderCell.h
//  RatingVoting
//
//  Created by c85 on 11/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol getCommentTextDelegate
@required
- (void) CommentText : (NSString *) comment withID : (NSString *) uID;
@optional
- (void)setDDListHidden:(BOOL)hidden
           forTextView : (UITextView *) textVW
     withFilteredArray : (NSMutableArray *) filteredList ;
@end

typedef enum {
    TableHeaderType,
    TableFooterType
}viewType;

@interface TrendHeaderCell : UIView <UITextViewDelegate>
{
    NSArray *_oldArray, *_currentNames;
    NSString *_currentName;
    NSMutableArray *_words;
}
@property (strong, nonatomic) IBOutlet UILabel *lblUserName, *lblComments, *lblPostDescription;
@property (strong, nonatomic) IBOutlet UIButton *btnVote;
@property (strong, nonatomic) IBOutlet UIButton *btnAddToFav;
@property (strong, nonatomic) IBOutlet UIButton *btnUserImg;
@property (strong, nonatomic) IBOutlet UIButton *btnSend, *btnLoadMoreComments, *btnSharePost;
@property (strong, nonatomic) IBOutlet UITextView *txtComment;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfilePic, *imgAddToFavorite;

@property (assign) id <getCommentTextDelegate> delegateGetCommentText;

- (id)initWithFrame:(CGRect)frame withType:(viewType)type;
@end
