//
//  UserProfileVC.h
//  RatingVoting
//
//  Created by c85 on 09/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "BaseVC.h"
#import "FollowersVC.h"

@interface UserProfileVC : BaseVC <UIScrollViewDelegate, PassValueDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIImageView *imgUserProfile;
    IBOutlet UIButton *btnFollow;
    IBOutlet UILabel *lblTotalBattles;
    IBOutlet UILabel *lblTotalPosts;
    IBOutlet UILabel *lblTotalFollowers;
    IBOutlet UILabel *lblTotalStars;
    IBOutlet UILabel *lblUsername;
    IBOutlet UICollectionView *colMyPost;
    IBOutlet UIButton *btnAll;
    IBOutlet UIButton *btnFollowingUsers;
    IBOutlet UIButton *btnFavourite;
    IBOutlet UIButton *btnAchivements;
    IBOutlet UIScrollView *mainScrollView;
    IBOutlet UIImageView *defaultImageIndecator;
}

- (void) visitUser:(NSString *)userId visitedUserobj : (UserDetail *) userobj;

@end
