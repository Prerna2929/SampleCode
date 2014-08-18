//
//  OwnPostCell.h
//  RatingVoting
//
//  Created by c32 on 30/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OwnPostCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UIButton *btnPostImage;
@property (nonatomic, strong) IBOutlet UIButton *btnTotalVotes;
@property (nonatomic, strong) IBOutlet UIImageView *imgIndicator;
@end
