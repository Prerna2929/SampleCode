//
//  FavouritePost.h
//  RatingVoting
//
//  Created by c85 on 28/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "BaseVC.h"

@interface FavouritePostVC : BaseVC
{
    IBOutlet UICollectionView *colFavourite;
    IBOutlet UIImageView *defaultFavorite;
}
@property (nonatomic, strong) NSMutableArray *favPostList;
-(void)getFavouritePostforuserID : (NSString *) userID;
@end
