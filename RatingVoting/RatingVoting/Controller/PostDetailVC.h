//
//  PostDetailVC.h
//  RatingVoting
//
//  Created by c85 on 11/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "BaseVC.h"
#import "SCFilterSwitcherView.h"
#import "SCVideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "PassValueDelegate.h"
#import "AutoCompleteTableView.h"
#import "TITokenField.h"
#import "UIPlaceHolderTextView.h"

typedef enum
{
    VideoType,
    ImageType
}postMediaType;

@interface PostDetailVC : BaseVC <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, PassValueDelegate, SCPlayerDelegate, TITokenFieldDelegate>
{
//    IBOutlet UITableView *tblDetail;
    IBOutlet UIButton *btnPost;
}

@property (nonatomic, strong) IBOutlet AutoCompleteTableView *suggestionView;

@property (weak, nonatomic) IBOutlet SCFilterSwitcherView *filterSwitcherView;


@property (strong, nonatomic) UIImage *photo;
@property (strong, nonatomic) AVAsset *asset;
@property (strong, nonatomic) NSString *videoName;

@end
