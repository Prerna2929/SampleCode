//
//  FollowersVC.h
//  RatingVoting
//
//  Created by c85 on 09/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "BaseVC.h"
#import "PassValueDelegate.h"


@protocol PassValueDelegate;

@interface FollowersVC : BaseVC
{
    IBOutlet UITableView *tblAllFollowers;
    IBOutlet UIImageView *defaultFollowers;
}
@property (nonatomic, strong) NSMutableArray *followersList;
@property (assign) id <PassValueDelegate> _delegate;
-(void) getAllFollowersForUserID : (NSString *) userID;

@end