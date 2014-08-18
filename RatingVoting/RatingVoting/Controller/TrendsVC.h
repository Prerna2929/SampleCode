//
//  TrendsVC.h
//  RatingVoting
//
//  Created by c85 on 07/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostDetail.h"
#import "TrendHeaderCell.h"
#import "AutoCompleteTableView.h"
#import "PassValueDelegate.h"
#import "CommentCell.h"


@interface TrendsVC : BaseVC <getCommentTextDelegate, UIScrollViewDelegate, PassValueDelegate, LikeDisLikeCountChange>
{
    IBOutlet UITableView *tblTrends;
}
@property (nonatomic, strong) IBOutlet UISegmentedControl *trendSegment;
@property (nonatomic, strong) IBOutlet AutoCompleteTableView *suggestionView;

@property (nonatomic, assign) IBOutlet UICollectionView *colTrends;
@property (nonatomic, assign) BOOL isDefaultMode;
@property (nonatomic, strong) PostDetail *selectedPost;

@end
