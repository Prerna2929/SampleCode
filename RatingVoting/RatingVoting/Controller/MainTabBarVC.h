//
//  MainTabBarVC.h
//  RatingVoting
//
//  Created by c85 on 21/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"
#import "UserProfileVC.h"

@interface MainTabBarVC : UITabBarController <UITabBarControllerDelegate,UITabBarDelegate, PassValueDelegate>

@property(nonatomic,strong)UIButton *profile, *upload, *search, *notification;
@property(nonatomic,strong)UserProfileVC *profileVC;

@property (nonatomic, retain) IBOutlet UIView* notificationView;

@property (nonatomic, retain) IBOutlet UILabel* notoficationCountLabel;;

@property (nonatomic, retain) IBOutlet UILabel* commentCountLabel;
@property (nonatomic, retain) IBOutlet UILabel* likeCountLabel;
@property (nonatomic, retain) IBOutlet UILabel* followerCountLabel;

+ (void) hideNotificationView : (BOOL) setBadheToZero ;
-(IBAction)selectTab:(UIButton *)button;
-(void)resetTabBarTHEME;
+(void)showTabBar;
+(void)hideTabbar;
+(BOOL)isTabbarHidden;
@end
