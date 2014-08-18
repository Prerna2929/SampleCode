//
//  UserProfileVC.m
//  RatingVoting
//
//  Created by c85 on 09/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "UserProfileVC.h"
#import "SettingsVC.h"
#import "OwnPostCell.h"
#import "Base64.h"
#import "MainTabBarVC.h"
#import "PostDetail.h"
#import "AchievementVC.h"
#import "FavouritePostVC.h"
#import "UIButton+WebCache.h"
#import "TrendsVC.h"
#import "FollowersVC.h"
#import "UIImageView+WebCache.h"
#import "UserDetail.h"
#import "WebServiceParser+Post.h"
#import "WebServiceParser+User.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIViewController+MMDrawerController.h"

static NSString *paramFollow = @"follow";
static NSString *paramUnfollow = @"unfollow";
static NSString *GalleryPick = @"From Gallery";
static NSString *CameraPick = @"From Camera";

typedef enum
{
    All=1,
    Achivements,
    Favourites,
    FollowedUsers
}ProfileMenu;

typedef enum
{
    Following=100,
    NotFollowing
}FollowStatus;

typedef enum
{
    FromGallery=100,
    FromCamera
}PickerType;

typedef enum
{
    AddProfileImage = 100,
    RemoveProileImage
}ProfilePic;

@interface UserProfileVC ()
{
    ProfileMenu selMenu;
    FollowStatus relationShipStatus;
    BOOL isPullToRefresh, isLoadMoreCalled;
    NSInteger nextFirstRecord;
    ProfilePic changeProfileStatus;
    PickerType *imgPickerType;
    AchievementVC *achievementVC;
    FavouritePostVC *favPostVC;
    FollowersVC *followerVC;
    UIButton *btnProfile;
    UIActionSheet *actionSheetEditPhoto;
    UIActivityIndicatorView *indicator;
#pragma mark - for visiting user list array
    NSMutableArray *idList;
}
@property (nonatomic, strong) NSMutableArray *myPostList;
@property (readwrite, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation UserProfileVC
@synthesize myPostList;

#pragma mark - Class methods

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
    
    selMenu = All;
    
    [self initializeProfileChangeButton];
    defaultImageIndecator.contentMode = UIViewContentModeScaleAspectFit;
    [btnAll setSelected:YES];
    idList = [NSMutableArray new];
    myPostList = [[NSMutableArray alloc]init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    isLoadMoreCalled = YES;
    
    [self setNavigationbarButton];
    [self setUserDetails:[SessionDetail currentSession].userDetail];
    [self addCollectionview];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshMyPost)
                  forControlEvents:UIControlEventValueChanged];
    [colMyPost addSubview:self.refreshControl];
    colMyPost.alwaysBounceVertical = YES;
    
    achievementVC = getVC(@"MainTabBar", @"idAchievementVC");
    achievementVC.view.frame = CGRectMake(320, 0, CGRectGetWidth(achievementVC.view.frame), CGRectGetHeight(mainScrollView.frame)-95);
    [mainScrollView addSubview:achievementVC.view];
    
    favPostVC = getVC(@"MainTabBar", @"idFavouritePostVC");
    favPostVC.view.frame = CGRectMake(640, 0, CGRectGetWidth(favPostVC.view.frame), CGRectGetHeight(mainScrollView.frame)-95);
    [mainScrollView addSubview:favPostVC.view];
    
    followerVC = getVC(@"MainTabBar", @"idFollowersVC");
    followerVC.view.frame = CGRectMake(960, 0, CGRectGetWidth(followerVC.view.frame), CGRectGetHeight(mainScrollView.frame)-95);
    followerVC._delegate = self;
    [mainScrollView addSubview:followerVC.view];
    
    myPostList = [NSMutableArray new];
    
    [self getMyPostForUser:[SessionDetail currentSession].userDetail.userId];
    
    imgUserProfile.layer.cornerRadius = 2.0f;
    imgUserProfile.layer.masksToBounds = YES;
    imgUserProfile.layer.borderColor = [UIColor blackColor].CGColor;
    imgUserProfile.layer.borderWidth = 1.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    if ([DefaultsValues getIntegerValueFromUserDefaults_ForKey:@"badgeValue"] > 0) {
        [MainTabBarVC showTabBar];
    }
    [super viewWillAppear:YES];
    
    app.needToCallCenterWillApper = YES;
    
    isLoadMoreCalled = YES;
    
    if ([MainTabBarVC isTabbarHidden]) {
        [MainTabBarVC showTabBar];
    }
}

- (void) initializeProfileChangeButton{
    btnProfile = [UIButton buttonWithType:UIButtonTypeCustom];
    btnProfile.frame = imgUserProfile.frame;
    [btnProfile setBackgroundColor:[UIColor clearColor]];
    [btnProfile addTarget:self action:@selector(openActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [btnProfile setEnabled:NO];
}

#pragma mark -  NavigationBar

-(void)setNavigationbarButton
{
    app.leftNavController.navigationBarHidden = YES;
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 2, 35, 35);
    btnLeft.backgroundColor = [UIColor clearColor];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"settingsIcon"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(settingsClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 2, 35, 35);
    btnRight.backgroundColor = [UIColor clearColor];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"rightArrow"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(closeDrawer:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void) viewWillDisappear:(BOOL)animated {
    [MainTabBarVC hideNotificationView:NO];
}

- (IBAction)closeDrawer:(id)sender {
    [MainTabBarVC hideNotificationView:NO];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        TrendsVC *trendsVC = (TrendsVC *)[[app.centralNavController viewControllers] firstObject];
        trendsVC.isDefaultMode = YES;
        trendsVC.trendSegment.hidden = NO;
        [trendsVC.colTrends reloadData];
    }];
}

#pragma mark - Set Details

-(void)setUserDetails : (UserDetail * ) userObj
{
    @try {
        self.navigationItem.title = userObj.username;
        lblUsername.text = userObj.username;
        lblTotalBattles.text = [NSString stringWithFormat:@"%@",userObj.totalBattleWon];
        lblTotalFollowers.text = [NSString stringWithFormat:@"%@",userObj.totalFollowers ];
        lblTotalPosts.text = [NSString stringWithFormat:@"%@",userObj.totalPosting];
        lblTotalStars.text = [NSString stringWithFormat:@"%@",userObj.totalCoins];
        
        if ([userObj.userId isEqualToString:[SessionDetail currentSession].userDetail.userId])
        {
            btnFollow.hidden = YES;
            [btnProfile setEnabled:YES];
            [self.view addSubview:btnProfile];
        }
        else
        {
            [btnProfile setEnabled:NO];
            [btnProfile removeFromSuperview];
            btnFollow.hidden = NO;
            if (userObj.followStatus)
            {
                relationShipStatus = Following;
                [btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
            }
            else
            {
                relationShipStatus = NotFollowing;
                [btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
            }
        }
        [imgUserProfile setImageWithURL:[NSURL URLWithString:userObj.profilePicture] placeholderImage:[GlobalHelper setPlaceholder:ProfilePlaceHolder]];
        
        [btnFollow addTarget:self action:@selector(followUnfollowUser:) forControlEvents:UIControlEventTouchUpInside];
        [btnFollow setAccessibilityValue:userObj.userId];
        [btnFollow setAccessibilityLabel:userObj.username];
        [btnFollow setBackgroundColor:[ThemeManger getThemeColorForApp]];
        btnFollow.layer.cornerRadius = 5;
        btnFollow.layer.masksToBounds = YES;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        NSLog(@"finally");
    }
}

#pragma mark - follow unfollow user
- (IBAction)followUnfollowUser:(id)sender {
    NSString *params ;
    switch (relationShipStatus) {
        case Following:
            params = [NSString stringWithFormat:@"follow_from=%@&follow_to=%@&status=%@",[SessionDetail currentSession].userDetail.userId, [sender accessibilityValue], paramUnfollow];
            break;
        case NotFollowing:
            params = [NSString stringWithFormat:@"follow_from=%@&follow_to=%@&status=%@",[SessionDetail currentSession].userDetail.userId, [sender accessibilityValue], paramFollow];
            break;
        default:
            break;
    }
    
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    [service GetUserInfo:WSFollowUnFollowUser
              parameters:params
           customeobject:nil
                   block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
                       if (error) {
                           [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                       }
                       else {
                           if ([responseString isEqualToString:@"success"])
                           {
                               switch (relationShipStatus) {
                                   case Following:
                                   {
                                       [GlobalHelper showNotification:notifyError message:[NSString stringWithFormat:@"UnFollowed @%@", [sender accessibilityLabel]] forVC:self];
                                       relationShipStatus = NotFollowing;
                                       [btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
                                       UserDetail *currentObj = (UserDetail *)[idList lastObject];
                                       currentObj.followStatus = NO;
                                       [idList replaceObjectAtIndex:[idList count]-1 withObject:currentObj];
                                   }
                                       break;
                                    case NotFollowing:
                                   {
                                       [GlobalHelper showNotification:notifySuccess message:[NSString stringWithFormat:@"Following @%@", [sender accessibilityLabel]] forVC:self];
                                       relationShipStatus = Following;
                                       [btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
                                       UserDetail *currentObj = (UserDetail *)[idList lastObject];
                                       currentObj.followStatus = YES;
                                       [idList replaceObjectAtIndex:[idList count]-1 withObject:currentObj];
                                   }
                                       break;
                                   default:
                                       break;
                               }
                           }
                       }
                   }];
}


#pragma mark - Set Default Menu

-(void)setDefaultMenu
{
    [btnAll setSelected:NO];
    [btnAchivements  setSelected:NO];
    [btnFavourite  setSelected:NO];
    [btnFollowingUsers  setSelected:NO];
}

#pragma mark - Get Data

-(void)getMyPostForUser : (NSString *) userID
{
    [GlobalHelper showActiviIndicatorOnView:defaultImageIndecator
                                  withStyle:UIActivityIndicatorViewStyleWhite
                                   hideShow:showIndicator];
    
    nextFirstRecord = isPullToRefresh ? 0 : nextFirstRecord;
    
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    [service PostRequest:WSGetMyPost
                 parameters:[NSString stringWithFormat:@"user_id=%@&start_record=%ld",userID, (long)nextFirstRecord]
              customeobject:nil
                      block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
                          [GlobalHelper showActiviIndicatorOnView:defaultImageIndecator
                                                        withStyle:UIActivityIndicatorViewStyleWhiteLarge
                                                         hideShow:hideIndicator];
                          if (isPullToRefresh) {
                              [myPostList removeAllObjects];
                              myPostList = NSMutableArray.new;
                          }
                          isPullToRefresh = NO;
                          isLoadMoreCalled = YES;
                          if (error) {
                              [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                          }
                          else {
                              [myPostList addObjectsFromArray:objects];
                              
                              if (myPostList.count > 0) {
                                  [UIView animateWithDuration:0.8 animations:^() {
                                      defaultImageIndecator.hidden = YES;
                                      [colMyPost setBackgroundView:nil];
                                  }];
                              }
                              else {
                                  [UIView animateWithDuration:0.8 animations:^() {
                                      [colMyPost setBackgroundView:defaultImageIndecator];
                                      defaultImageIndecator.image = [UIImage imageNamed:@"noownposts"];
                                      defaultImageIndecator.hidden = NO;
                                  }];
                              }
                              
                              if (myPostList.count <= [objects count]) {
                                  [CacheData setCacheToUserDefaults:myPostList ForKey:keyMyPosts];
                              }
                              
                              if (nextUrl != nil)
                                  nextFirstRecord = [nextUrl integerValue];
                              
                              [self.refreshControl endRefreshing];
                              [colMyPost reloadData];
                              [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                          }
                      }];
}

-(void)refreshMyPost
{
    if ([colMyPost numberOfSections]==0)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
           // [colMyPost reloadDataWithPlaceholderString:@"Loading new post.." wihtUIColor:[UIColor lightTextColor]];
        }];
    }
    if (self.refreshControl!=nil)
    {
        if (colMyPost.contentOffset.y <=0) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
                    
                    colMyPost.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
                    
                } completion:^(BOOL finished){
                    isPullToRefresh = YES;
                    
                    [self.refreshControl beginRefreshing];
                    
                    if (idList.count > 0)
                        [self getMyPostForUser: ((UserDetail *) [idList lastObject]).userId];
                    else
                        [self getMyPostForUser:[SessionDetail currentSession].userDetail.userId];
                    
                }];
            }];
        }
    }
    else
    {
        if (idList.count > 0)
            [self getMyPostForUser: ((UserDetail *) [idList lastObject]).userId];
        else
            [self getMyPostForUser:[SessionDetail currentSession].userDetail.userId];
    }
}

#pragma mark - User Action

-(IBAction)menuClick:(id)sender
{
    [self setDefaultMenu];
    switch ([sender tag]) {
        case 1: {
            [btnAll setSelected:YES];
            selMenu = All;
            [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
            break;
            
        case 2: {
            [btnAchivements  setSelected:YES];
            selMenu = Achivements;
            [mainScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
        
            if (idList.count > 0)
                [achievementVC getAllAchivementsForUserID: ((UserDetail *) [idList lastObject]).userId];
            else
                [achievementVC getAllAchivementsForUserID: [SessionDetail currentSession].userDetail.userId];
        }
            break;
            
        case 3: {
            [btnFavourite  setSelected:YES];
            selMenu = Favourites;
            [mainScrollView setContentOffset:CGPointMake(640, 0) animated:YES];
            
            if (idList.count > 0)
                [favPostVC getFavouritePostforuserID : ((UserDetail *) [idList lastObject]).userId];
            else
                [favPostVC getFavouritePostforuserID : [SessionDetail currentSession].userDetail.userId];
            
        }
            break;
            
        case 4: {
            [btnFollowingUsers  setSelected:YES];
            selMenu = FollowedUsers;
            [mainScrollView setContentOffset:CGPointMake(960, 0) animated:YES];
            if (idList.count > 0)
                [followerVC getAllFollowersForUserID : ((UserDetail *) [idList lastObject]).userId];
            else
                [followerVC getAllFollowersForUserID : [SessionDetail currentSession].userDetail.userId];
        }
            break;
        default:
            break;
    }
}

-(IBAction)settingsClick:(id)sender
{
    SettingsVC *profile = getVC(@"SettingsVC", @"idSettingsVC");
    [self.navigationController pushViewController:profile animated:YES];
}

#pragma mark - collectionview delegate methods

-(void)addCollectionview
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(94, 94)];
    [flowLayout setMinimumInteritemSpacing:4];
    [flowLayout setMinimumLineSpacing:8];
    [flowLayout setScrollDirection:(UICollectionViewScrollDirectionVertical)];
    
    [colMyPost setCollectionViewLayout:flowLayout];
    [colMyPost setAllowsSelection:YES];
    [colMyPost setContentInset:UIEdgeInsetsMake(10, 10, 0, 10)];
    [colMyPost setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return myPostList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OwnPostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserPostDetailCell" forIndexPath:indexPath];
    
    PostDetail *detail = [myPostList objectAtIndex:indexPath.row];
    
    
    
    
    [cell.btnPostImage.imageView setContentMode:UIViewContentModeScaleAspectFill];
    cell.btnPostImage.layer.cornerRadius = 5;
    cell.btnPostImage.layer.masksToBounds = YES;
    
    if ([detail.postType isEqualToString:@"video"]) {
        [cell.btnPostImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", detail.videoFrame]] forState:UIControlStateNormal placeholderImage:[GlobalHelper setPlaceholder:SmallPostPlaceHolder] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        }];
        [cell.imgIndicator setImage:[UIImage imageNamed:@"videoindecator"]];
    }
    else {
        
//        NSString *URL = [NSString stringWithFormat:@"%@",paraImageURL_Thumb(detail.postImage)];
        
        [cell.btnPostImage setImageWithURL:[NSURL URLWithString:detail.postImage] forState:UIControlStateNormal placeholderImage:[GlobalHelper setPlaceholder:SmallPostPlaceHolder] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        }];
        [cell.imgIndicator setImage:[UIImage imageNamed:@"imageindicator"]];
    }
    
    [cell.btnPostImage addTarget:self action:@selector(selectPost:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnPostImage setTag:indexPath.row];
    

    [cell.btnTotalVotes setTitle:detail.totalUpVotes forState:UIControlStateNormal];
    [cell.btnTotalVotes setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)selectPost:(id)sender {
//    [self closeDrawer];
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        TrendsVC *trendsVC = (TrendsVC *)[[app.centralNavController viewControllers] firstObject];
        trendsVC.isDefaultMode = NO;
        trendsVC.selectedPost = [myPostList objectAtIndex:[sender tag]];
        trendsVC.trendSegment.hidden = YES;
        [trendsVC.colTrends reloadData];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height) {
        if (isLoadMoreCalled) {
//            isPullToRefresh = NO;
            isLoadMoreCalled = NO;
            if (myPostList.count < nextFirstRecord)
                [self getMyPostForUser:[SessionDetail currentSession].userDetail.userId];
        }
    }
}

#pragma mark - visit user delegate
- (void) visitUser:(NSString *)userId  visitedUserobj : (UserDetail *) userobj
{
    [myPostList removeAllObjects];
    [colMyPost reloadData];
    
    [[achievementVC achievemntList] removeAllObjects];
    [[followerVC followersList] removeAllObjects];
    [[favPostVC favPostList] removeAllObjects];
    
//    [self getUserInfoForUserID:userId];
    
    [self addNavigationBackButton];
    
    if ([userobj.userId isEqualToString:[SessionDetail currentSession].userDetail.userId]) {
        [self getUserInfoForUserID:userId];
    }
    else {
        [idList addObject:userobj];
        [self setUserDetails:userobj];
    }
    
    [self setDefaultMenu];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self getMyPostForUser:userId];
    });
    
    [btnAll setSelected:YES];
    selMenu = All;
    
    
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:NO];
                         [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                     }];
    
}

- (void) getUserInfoForUserID : (NSString *) userID {
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    [service GetUserInfo:WSGetUserInfo parameters:[NSString stringWithFormat:@"user_id=%@&login_user_id=%@", userID,[SessionDetail currentSession].userDetail.userId] customeobject:nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
        if (error) {
            [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
//            [UIAlertView showWithTitle:AppName message:[error.userInfo objectForKey:@"msg"] cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            }];
        }
        else {
//            [self addNavigationBackButton];
            [idList addObject:(UserDetail *) objects];
            if ([[SessionDetail currentSession].userDetail.userId isEqualToString:((UserDetail *) objects).userId]) {
                [SessionDetail currentSession].userDetail = objects;
            }
            [self setUserDetails:objects];
        }
    }];
}

#pragma mark - add back button

- (void) addNavigationBackButton
{
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 2, 35, 35);
    btnLeft.backgroundColor = [UIColor clearColor];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (IBAction)back:(id)sender
{
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:NO];
                         [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                     }];
    if (idList.count > 1)
    {
        [myPostList removeAllObjects];
        [colMyPost reloadData];
        [idList removeLastObject];
        [self setUserDetails:[idList lastObject]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self getMyPostForUser: ((UserDetail *) [idList lastObject]).userId];
        });
        
        [idList removeObjectAtIndex:[idList count]-1];
    }
    else
    {
        [idList removeAllObjects];
        [myPostList removeAllObjects];
        [colMyPost reloadData];
        
        [[achievementVC achievemntList] removeAllObjects];
        [[followerVC followersList] removeAllObjects];
        [[favPostVC favPostList] removeAllObjects];
        
        [self setNavigationbarButton];
        
        [self setUserDetails:[SessionDetail currentSession].userDetail];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self getMyPostForUser:[SessionDetail currentSession].userDetail.userId];
        });
    }
}

#pragma mark - open action sheet

- (IBAction)openActionSheet:(id)sender {
    [UIActionSheet showFromTabBar:self.tabBarController.tabBar
                        withTitle:@"Profile Image"
                cancelButtonTitle:@"Cancel"
           destructiveButtonTitle:[[SessionDetail currentSession].userDetail.profilePicture isEqualToString:@"http://107.170.93.130/api/uploads/no_profile_picture.png"] ? nil : @"Remove Photo"
                otherButtonTitles:@[GalleryPick,CameraPick]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex)
    {
        if (buttonIndex != [actionSheet cancelButtonIndex])
        {
            if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:GalleryPick]) {
                [self addNewPicFromViewController:self usingDelegate:self sourceType:FromGallery];
            }
            else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:CameraPick]) {
                [self addNewPicFromViewController:self usingDelegate:self sourceType:FromCamera];
            }
            else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Remove Photo"]) {
                [imgUserProfile setImage:[UIImage imageNamed:@"profilePlaceholder"]];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    [self updateProflePicture:RemoveProileImage];
                });
            }
        }
    }];
}

#pragma mark - ImagePicker Methods

-(BOOL)addNewPicFromViewController:(UIViewController*)controller usingDelegate:(id )delegate sourceType : (PickerType) type{
    
    app.needToCallCenterWillApper = NO;
    
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    switch (type) {
        case FromGallery:
            mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            break;
        case FromCamera:
            mediaUI.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        default:
            break;
    }
    
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = delegate;
    
    [controller presentViewController:mediaUI animated:YES completion:nil];
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    imgUserProfile.image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];

    btnProfile.enabled = NO;
    
    [GlobalHelper showActiviIndicatorOnView:imgUserProfile
                                  withStyle:UIActivityIndicatorViewStyleWhite
                                   hideShow:showIndicator
                           ];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self updateProflePicture:AddProfileImage];
    });
}

#pragma mark - update profile image

- (void) updateProflePicture : (ProfilePic) status {
    NSString *encodedMedia = nil;
    NSMutableDictionary *updaetUserProfileDic=[[NSMutableDictionary alloc]init];
    switch (status) {
        case AddProfileImage:
        {
            NSData *imageData = [GlobalHelper imageComrassionFor:imgUserProfile.image];
            encodedMedia = [Base64 encode:imageData];
            [updaetUserProfileDic setValue:encodedMedia forKey:@"profile_picture"];
        }
            break;
        case RemoveProileImage:
        {
            encodedMedia = @"";
            [updaetUserProfileDic setValue:@"yes" forKey:@"remove_image"];
        }
            break;
        default:
            break;
    }
    
    [updaetUserProfileDic setValue:[SessionDetail currentSession].userDetail.userId forKey:@"user_id"];
    
    [updaetUserProfileDic setValue:[SessionDetail currentSession].userDetail.nickname forKey:@"nickname"];
    
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    [service GetUserInfo:WSUpdateUserProfile
              parameters:nil
           customeobject:updaetUserProfileDic
                   block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
                       
                       btnProfile.enabled = YES;
                       
                       [GlobalHelper showActiviIndicatorOnView:imgUserProfile
                                                     withStyle:0
                                                      hideShow:hideIndicator
                                              ];
                       
                       if (error) {
                           [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                       }
                       else {
                           switch (status) {
                                case AddProfileImage:
                               {
                                   [SessionDetail currentSession].userDetail.profilePicture = [NSString stringWithFormat:@"%@", objects];
                                   [CacheData setObjectCacheToUserDefaults:[SessionDetail currentSession].userDetail ForKey:keyCurrentUserObj];
                                   [GlobalHelper dispToastMessage:@"Profile Picture Successfully Updated!"];
                               }
                                   break;
                                case RemoveProileImage:
                               {
                                   [SessionDetail currentSession].userDetail.profilePicture = @"http://107.170.93.130/api/uploads/no_profile_picture.png";
                                   [CacheData setObjectCacheToUserDefaults:[SessionDetail currentSession].userDetail ForKey:keyCurrentUserObj];
                                   [GlobalHelper dispToastMessage:@"Profile Picture Removed!"];
                               }
                                   break;
                               default:
                                   break;
                           }
                           
                           
                       }
                   }];
}

@end