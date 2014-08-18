//
//  AppDelegate.m
//  RatingVoting
//
//  Created by c85 on 07/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "LoginVC.h"
#import "TrendsVC.h"
#import "BattleVC.h"
#import "MainTabBarVC.h"
#import "NSUserDefaults+SaveCustomObject.h"

@implementation AppDelegate
@synthesize drawerController, userNames, needToCallCenterWillApper, deviceUDID, forBattleProcess, globBattleID, globNotificationID;

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge ];
    
    needToCallCenterWillApper = YES;
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [IQKeyboardManager sharedManager].canAdjustTextView =NO;
    [IQKeyboardManager sharedManager].shouldAdoptDefaultKeyboardAnimation=YES;
    
    UIBackgroundTaskIdentifier bgTask = 0;
    UIApplication *appDel=[UIApplication sharedApplication];
    bgTask=[appDel beginBackgroundTaskWithExpirationHandler:^{
        [appDel endBackgroundTask:bgTask];
    }];
    
    NSString *userName = [DefaultsValues getStringValueFromUserDefaults_ForKey:kUserName];
    NSString *password = [DefaultsValues getStringValueFromUserDefaults_ForKey:kUserPassword];
    
    LoginVC *loginController = getVC(@"Login", @"idLoginVC");
    _mainNavController = [[UINavigationController alloc] initWithRootViewController:loginController];
    _mainNavController.navigationBarHidden=YES;

    if (userName.length != 0 && password.length != 0) {
        
        [SessionDetail currentSession];
        
        [SessionDetail currentSession].userDetail = (UserDetail *) [CacheData getObjectCachedataFor_:keyCurrentUserObj];
        
        TrendsVC *trendsVC = getVC(@"Center", @"idTrendsVC");
        _centralNavController = [[UINavigationController alloc]initWithRootViewController:trendsVC];
        trendsVC.isDefaultMode = YES;
        trendsVC.selectedPost = nil;
        
        
        MainTabBarVC *profile = getVC(@"MainTabBar", @"idMainTabBarVC");
        _leftNavController = [[UINavigationController alloc]initWithRootViewController:profile];
        
        BattleVC *battleVC = getVC(@"Battle", @"idBattleVC");
        _rightNavController = [[UINavigationController alloc]initWithRootViewController:battleVC];
        
        [_centralNavController.navigationBar setOpaque:YES];
        [_centralNavController.navigationBar setTranslucent:NO];
        
        app.drawerController = [[MMDrawerController alloc]initWithCenterViewController:_centralNavController leftDrawerViewController:_leftNavController rightDrawerViewController:_rightNavController];
        
        [app.drawerController setMaximumLeftDrawerWidth:CGRectGetWidth([[UIScreen mainScreen] bounds])];
        [app.drawerController setMaximumRightDrawerWidth:CGRectGetWidth([[UIScreen mainScreen] bounds])];
        
        [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
        [self.drawerController setShouldStretchDrawer:NO];
        
        [_mainNavController pushViewController:self.drawerController animated:NO];
    }

    if (![[NSFileManager defaultManager] fileExistsAtPath:[DefaultsValues getStringValueFromUserDefaults_ForKey:VideoPath]])
    {
        [self videoPath];
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:_mainNavController];

    return YES;
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0)
    {
        [DefaultsValues setIntegerValueToUserDefaults:[UIApplication sharedApplication].applicationIconBadgeNumber  ForKey:@"badgeValue"];
//        [MainTabBarVC showTabBar];
    }
    
    [self clearBadge];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - create video path

- (void) videoPath {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/AppVideos"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    [DefaultsValues setStringValueToUserDefaults:dataPath ForKey:VideoPath];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    //	NSLog(@"####################### My token is: %@", deviceToken);
    const unsigned *tokenBytes = [deviceToken bytes];
    deviceUDID = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                  ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                  ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                  ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"####################### My token is: %@", deviceUDID);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	TRC_NRM(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
 
    [self incrementOneBadge];
    
    NSLog(@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber);
    
//    [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey: @"badgecount"] intValue];
    
    NSLog(@"%@", userInfo);
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
   
    [self incrementOneBadge];
    
    //[UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey: @"badgecount"] intValue];
}

-(void) incrementOneBadge{
    NSInteger numberOfBadges = [UIApplication sharedApplication].applicationIconBadgeNumber;
    numberOfBadges +=1;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:numberOfBadges];
}

-(void) decrementOneBdge{
    NSInteger numberOfBadges = [UIApplication sharedApplication].applicationIconBadgeNumber;
    numberOfBadges -=1;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:numberOfBadges];
}

-(void) clearBadge{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

@end