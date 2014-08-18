//
//  MainTabBarVC.m
//  RatingVoting
//
//  Created by c85 on 21/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "MainTabBarVC.h"
#import "UserProfileVC.h"
#import "NotificationVC.h"
#import "PostVC.h"
#import "SearchVC.h"

@interface MainTabBarVC ()

@end

@implementation MainTabBarVC

@synthesize notificationView, commentCountLabel, likeCountLabel, followerCountLabel, notoficationCountLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector
     (orientationChanged) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
    [self.tabBar setOpaque:YES];
    [self.tabBar setTranslucent:NO];
    [self.tabBar setShadowImage:[[UIImage alloc] init]];
    [self.tabBar setBarTintColor:[ThemeManger getThemeBackgroundColor]]; // [UIColor colorWithRed:253 green:253 blue:253 alpha:1]];
    
    [self setControllers];
    [self resetlayout];
    [self selectTab:_profile];

}

-(void)setControllers
{
    _profileVC = getVC(@"MainTabBar", @"idUserProfileVC");
    UINavigationController *profileNavVC = [[UINavigationController alloc]initWithRootViewController:_profileVC];
    
    PostVC *postVC = getVC(@"Post", @"idPostVC");
    postVC.hidesBottomBarWhenPushed = YES;
    UINavigationController *postNavVC = [[UINavigationController alloc]initWithRootViewController:postVC];
    
    SearchVC *searchVC = getVC(@"MainTabBar", @"idSearchVC");
    UINavigationController *searchNavVC = [[UINavigationController alloc]initWithRootViewController:searchVC];
    
    NotificationVC *notificationVC = getVC(@"MainTabBar", @"idNotificationVC");
    UINavigationController *notificationNavVC = [[UINavigationController alloc]initWithRootViewController:notificationVC];
    
    self.viewControllers = @[profileNavVC,postNavVC,searchNavVC,notificationNavVC];
}

-(void)resetlayout
{
    [_profile removeFromSuperview] ;
    [_upload removeFromSuperview] ;
    [_search removeFromSuperview] ;
    [_notification removeFromSuperview] ;
    
    //TabBar Settings
    _profile = [self addcustmbuttonontab:_profile index:0 imageset:@[@"profileUnSelIcon",@"profileSelIcon"]];
    _upload = [self addcustmbuttonontab:_upload index:1 imageset:@[@"uploadUnSelIcon",@"uploadSelIcon"]];
    _search = [self addcustmbuttonontab:_search index:2 imageset:@[@"searchUnSelIcon",@"searchSelIcon"]];
    _notification = [self addcustmbuttonontab:_notification index:3 imageset:@[@"notificationUnSelIcon",@"notificationSelIcon"]];
    
    [[self tabBar] addSubview:_profile];
    [[self tabBar] addSubview:_upload];
    [[self tabBar] addSubview:_search];
    [[self tabBar] addSubview:_notification];
    
//    [[[[self tabBar] items]
//      objectAtIndex:3] setBadgeValue:@"3"];
    
    [self resetslectedstate];
}
-(void)resetslectedstate
{
    switch (self.selectedIndex)
    {
        case 0:
            [self selectTab:_profile];
            break;
        case 1:
            [self selectTab:_upload];
            break;
        case 2:
            [self selectTab:_search];
            break;
        case 3:
            [self selectTab:_notification];
            break;
        default:
            break;
    }
}

-(void)resetTabBarTHEME
{
    if (IOS_NEWER_OR_EQUAL_TO_X(7.0))
        self.tabBar.barTintColor = [ThemeManger getThemeColorForApp];
    else
    {
        self.tabBar.tintColor = [ThemeManger getThemeColorForApp];
        [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage alloc] init]];
    }
}

-(UIButton *)addcustmbuttonontab :(UIButton *)btn index:(int)index imageset:(NSArray *)imageset
{
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget :self action:@selector(slectedtab:) forControlEvents:UIControlEventTouchUpInside];
    [btn setAdjustsImageWhenDisabled:YES];
    [btn setTag:index];
    [btn setImage:[UIImage imageNamed:[imageset objectAtIndex:0]] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:[imageset objectAtIndex:1]] forState:UIControlStateSelected];
    [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btn setContentMode:UIViewContentModeScaleAspectFit];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    CGRect frame;
    frame.size.height = self.tabBar.bounds.size.height;
    frame.size.width = CGRectGetWidth(self.view.frame)/4;
    frame.origin.x = index*frame.size.width;
    frame.origin.y = 0;
    [btn setFrame:frame];
    
    return btn;
}

-(IBAction)slectedtab:(id)sender
{
    [_profile setSelected:NO];
    [_upload setSelected:NO];
    [_search setSelected:NO];
    [_notification setSelected:NO];
    
    [sender setSelected:YES];
    [self setSelectedIndex:[sender tag]];
}

-(IBAction)selectTab:(UIButton *)button
{
    @try {
        [_profile setSelected:NO];
        [_upload setSelected:NO];
        [_search setSelected:NO];
        [_notification setSelected:NO];
        
        [button setSelected:YES];
        [self setSelectedIndex:[button tag]];
    }
    @catch (NSException *exception) {
        
    }
}

-(void)resettabview
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
#pragma mark -Rotation

-(void)orientationChanged
{
    [self resetlayout];
    [self resetslectedstate];
}

#ifdef IOS_OLDER_THAN_6
- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
#endif

// For Newer than IOS 6.
#ifdef IOS_NEWER_OR_EQUAL_TO_6
-(BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}
#endif

#pragma mark - Hide Tabbar

+(void)hideTabbar
{
    MainTabBarVC *weakself = [app.leftNavController.viewControllers lastObject];
    [weakself hideTabbar];
}

- (void)hideTabbar
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, screenHeight, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, screenHeight)];
        }
    }
    
    [UIView commitAnimations];
}

+ (void)showTabBar
{
    MainTabBarVC *weakself = [app.leftNavController.viewControllers lastObject];
    [weakself showTabBar];
}

- (void)showTabBar
{
    if ([DefaultsValues getIntegerValueFromUserDefaults_ForKey:@"badgeValue"] > 0) {
        [self showNotificationViewFor:3];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in self.view.subviews)
    {
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, screenHeight - 49, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, screenHeight)];
        }
    }
    
    [UIView commitAnimations];
}

+(BOOL)isTabbarHidden
{
    MainTabBarVC *weakself = [app.leftNavController.viewControllers lastObject];
    return [weakself isTabbarHidden];
}

-(BOOL)isTabbarHidden
{
    for(UIView *view in self.view.subviews)
    {
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        
        if([view isKindOfClass:[UITabBar class]])
        {
            if (CGRectGetMinY(view.frame) == screenHeight - 49) {
                return false;
            }
            else {
                return true;
            }
        }
    }
    return false;
}

- (void) showNotificationViewFor:(NSUInteger)tabIndex
{
    // To get the vertical location we start at the bottom of the window, go up by height of the tab bar and go up again by the notification view
    CGFloat verticalLocation = self.view.window.frame.size.height - self.tabBar.frame.size.height - notificationView.frame.size.height - 2.0;
    notificationView.frame = CGRectMake([self horizontalLocationFor:tabIndex], verticalLocation, notificationView.frame.size.width, notificationView.frame.size.height);
    notoficationCountLabel.text = [NSString stringWithFormat:@"%d", [DefaultsValues getIntegerValueFromUserDefaults_ForKey:@"badgeValue"]];

    if (!notificationView.superview) {
        [self.view.window addSubview:notificationView];
    }
    
    notificationView.alpha = 0.0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    notificationView.alpha = 1.0;
    [UIView commitAnimations];
}

- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
    // A single tab item's width is the entire width of the tab bar divided by number of items
    CGFloat tabItemWidth = self.tabBar.frame.size.width / self.tabBar.items.count;
    // A half width is tabItemWidth divided by 2 minus half the width of the notification view
    CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (notificationView.frame.size.width / 2.0);
    
    // The horizontal location is the index times the width plus a half width
    return (tabIndex * tabItemWidth) + halfTabItemWidth;
}


- (IBAction)hideNotificationView:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    notificationView.alpha = 0.0;
    [UIView commitAnimations];
    notoficationCountLabel.text = @"";
}

+ (void) hideNotificationView : (BOOL) setBadheToZero {
    MainTabBarVC *weakself = [app.leftNavController.viewControllers lastObject];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    weakself.notificationView.alpha = 0.0;
    [UIView commitAnimations];
    if (setBadheToZero) {
        [DefaultsValues setIntegerValueToUserDefaults:0 ForKey:@"badgeValue"];
        weakself.notoficationCountLabel.text = @"";
    }
}

- (IBAction)tapNotificationView:(id)sender {
    [DefaultsValues setIntegerValueToUserDefaults:0 ForKey:@"badgeValue"];
    [self hideNotificationView:sender];
    [self selectTab:_notification];
}

@end