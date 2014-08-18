//
//  BaseVC.m
//  RatingVoting
//
//  Created by c85 on 07/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "BaseVC.h"
#import "TrendsVC.h"
#import "MainTabBarVC.h"
#import "BattleVC.h"
#import "WebServiceParser+User.h"
#import "UIViewController+MMDrawerController.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setDefaultNavigationBarColor];
    [self.view setBackgroundColor:[ThemeManger getThemeBackgroundColor]];
    [GlobalHelper performActionOnnavigationBarIsHidden:NO
                                              isOpaque:YES
                                         isTranslucent:NO
                                             tintColor:[ThemeManger getNavigationTintColor]
                               navigationbarTitleColor:[UIColor whiteColor]
                                  navigationController:self.navigationController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setDrawerController
{
    [SessionDetail currentSession];

    TrendsVC *trendsVC = getVC(@"Center", @"idTrendsVC");
    app.centralNavController = [[UINavigationController alloc]initWithRootViewController:trendsVC];
    trendsVC.isDefaultMode = YES;
    trendsVC.selectedPost = nil;
    
    MainTabBarVC *profile = getVC(@"MainTabBar", @"idMainTabBarVC");
    app.leftNavController = [[UINavigationController alloc]initWithRootViewController:profile];
    
    BattleVC *battleVC = getVC(@"Battle", @"idBattleVC");
    app.rightNavController = [[UINavigationController alloc]initWithRootViewController:battleVC];
    
    app.drawerController = [[MMDrawerController alloc]initWithCenterViewController:app.centralNavController leftDrawerViewController:app.leftNavController rightDrawerViewController:app.rightNavController];
    
    [app.drawerController setMaximumLeftDrawerWidth:CGRectGetWidth(self.view.frame)];
    [app.drawerController setMaximumRightDrawerWidth:CGRectGetWidth(self.view.frame)];

    [app.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [app.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    [app.drawerController setShouldStretchDrawer:NO];
    
    app.mainNavController.navigationBarHidden = YES;
    
    [app.mainNavController pushViewController:app.drawerController animated:YES];
}

-(void)openLeftView
{
    [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
    }];
}

-(void)openRightView
{
    [self.mm_drawerController openDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
        
    }];
}

-(void)closeDrawer
{
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
}

-(void)setTitleView:(NSString*)title
{
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor blackColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = title;
    lbl.font = [ThemeManger getThemeFontBoldWithSize:14.0];
    [self.navigationItem setTitleView:lbl];
}

#pragma mark - detect gesture

- (void) detectGestureDrawer
{
    [self.mm_drawerController
     setGestureShouldRecognizeTouchBlock:^BOOL(MMDrawerController *drawerController, UIGestureRecognizer *gesture, UITouch *touch) {
         BOOL shouldRecognizeTouch = NO;
         if(drawerController.openSide == MMDrawerSideLeft &&
            [gesture isKindOfClass:[UIPanGestureRecognizer class]])
         {
//             UIView * customView = [drawerController.centerViewController myCustomSubview];
//             CGPoint location = [touch locationInView:customView];
//             shouldRecognizeTouch = (CGRectContainsPoint(customView.bounds, location));
         }
         return shouldRecognizeTouch;
     }];
}

#pragma mark - getAllUserName for universal use
- (void) getAllUserName {
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    [service GetUserInfo:WSGetAllNames parameters:nil customeobject:nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
        if (error) {
        }
        else {
            NSMutableArray *userNameList = (NSMutableArray *)objects;
            [CacheData setCacheToUserDefaults:userNameList ForKey:keyUserNames];
            app.userNames = NSMutableArray.new;
            [app.userNames addObjectsFromArray:userNameList];
            userNameList = nil;
        }
    }];
}

@end