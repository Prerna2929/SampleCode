//
//  PostsCell.h
//  RatingVoting
//
//  Created by c32 on 08/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostsCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgPost, *imgBlurPost;
@property (nonatomic, strong) IBOutlet UILabel *lblCommentCount;
@property (nonatomic, strong) IBOutlet UIButton *btnPlayVideo;
@end
