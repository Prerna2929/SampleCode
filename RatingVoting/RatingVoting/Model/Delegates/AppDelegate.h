//
//  AppDelegate.h
//  RatingVoting
//
//  Created by c85 on 07/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MMDrawerController *drawerController;

@property (nonatomic, strong) NSString *deviceUDID, *globBattleID, *globNotificationID;

@property (nonatomic, strong) NSMutableArray *userNames;

@property (nonatomic, assign) BOOL needToCallCenterWillApper, forBattleProcess;

@property (strong, nonatomic) UINavigationController *mainNavController, *leftNavController, *rightNavController, *centralNavController;

@end
