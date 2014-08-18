//
//  AchievementVC.h
//  RatingVoting
//
//  Created by c85 on 28/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "BaseVC.h"

@interface AchievementVC : BaseVC
{
    IBOutlet UITableView *tblAchivements;
    IBOutlet UIImageView *defaultAchievement;
}
@property (nonatomic, strong) NSMutableArray *achievemntList;
-(void)getAllAchivementsForUserID : (NSString *) userID;

@end
