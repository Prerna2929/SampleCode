//
//  BaseVC.h
//  RatingVoting
//
//  Created by c85 on 07/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+RateVote.h"

@interface BaseVC : UIViewController

-(void)setDrawerController;
-(void)openLeftView;
-(void)openRightView;
-(void)closeDrawer;
-(void)setTitleView:(NSString*)title;
#pragma mark - For Universal use
-(void)getAllUserName;
@end
