//
//  ImgFilterVC.h
//  RatingVoting
//
//  Created by c85 on 11/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "BaseVC.h"

@interface ImgFilterVC : BaseVC
{
    IBOutlet UICollectionView *colFilters;
    IBOutlet UIActivityIndicatorView *activity;
}
@property (strong, nonatomic) UIImage *photo;
@property (strong, nonatomic) IBOutlet UIImageView *imgNewPost;

@end