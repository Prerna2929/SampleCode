//
//  NotificationVC.m
//  RatingVoting
//
//  Created by c85 on 21/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "NotificationVC.h"
#import "NotificationCell.h"
#import "MainTabBarVC.h"
#import "WebServiceParser+Battle.h"
#import "NotificationDetail.h"
#import "UIImageView+WebCache.h"
#import "WebServiceParser+User.h"
#import "PostVC.h"

#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT

static NSString* userFollowNotification = @"UserFollow";
static NSString* userUnFollowNotification = @"UserUnFollow";
static NSString* battleAcceptedNotification = @"BattleAccept";
static NSString* battleRejectedNotification = @"BattleReject";
static NSString* battleInvitationNotification = @"BattleInvite";
static NSString* commentMentionNotification = @"CommentMention";
static NSString* commentPostNotification = @"CommentPost";
static NSString* commentLikeNotification = @"CommentLike";
static NSString* commentUnLikeNotification = @"CommentUnLike";
static NSString* voteUpNotification = @"VotePostUp";
static NSString* voteDownNotification = @"VotePostDown";
static NSString* battlePostNotification = @"PostForBattle";


@interface NotificationVC ()
{
    NSMutableArray *NotificationList ; NSArray *filteredNotificationArr;
    IBOutlet UIImageView *defaultImageNotification;
    BOOL isPullToRefresh, isLoadMoreCalled;
    NSInteger nextFirstRecord;
    NSInteger selectedNotificationIndex;
    NotificationDetail *SelectedBattlePostNotification ;
}
@end

@implementation NotificationVC

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
    isLoadMoreCalled = YES;
    selectedSegment = NotBattle;
    defaultImageNotification.contentMode = UIViewContentModeScaleAspectFit;
    filteredNotificationArr = NSArray.new;
    NotificationList = NSMutableArray.new;
    [GlobalHelper performActionOnnavigationBarIsHidden:NO
                                              isOpaque:YES
                                         isTranslucent:NO
                                             tintColor:[ThemeManger getThemeColorForApp]
                               navigationbarTitleColor:[UIColor blackColor]
                                  navigationController:self.navigationController];
    
    self.navigationItem.title = @"Notifications";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadNotification:)
                                                 name:notificationReloadNotificationTable
                                               object:nil];
    
//    isPullToRefresh = YES;;
    isPullToRefresh = YES;
    
    if ([DefaultsValues getIntegerValueFromUserDefaults_ForKey:@"badgeValue"] > 0) {
        [MainTabBarVC hideNotificationView:YES];
        isPullToRefresh = YES;
    }
    
    if ([MainTabBarVC isTabbarHidden]) {
        [MainTabBarVC showTabBar];
    }
    
    [UIView animateWithDuration:0.8 animations:^() {
        defaultImageNotification.hidden = NO;
        defaultImageNotification.image = nil;
        [tblNotification setBackgroundView:nil];
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self getNotificationForUser : [SessionDetail currentSession].userDetail.userId];
    });
}

#pragma mark - get notification

- (void) getNotificationForUser : (NSString *) user_id {
    
    [GlobalHelper showActiviIndicatorOnView:defaultImageNotification
                                  withStyle:UIActivityIndicatorViewStyleWhite
                                   hideShow:showIndicator];
    
    nextFirstRecord = isPullToRefresh ? 0 : nextFirstRecord;
    
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    [service GetUserInfo:WSGetAllNotifications parameters:[NSString stringWithFormat:@"user_id=%@&start_record=%ld", user_id, (long)nextFirstRecord] customeobject:nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
        
        [GlobalHelper showActiviIndicatorOnView:defaultImageNotification
                                      withStyle:UIActivityIndicatorViewStyleWhiteLarge
                                       hideShow:hideIndicator];
        
        if (isPullToRefresh) {
            [NotificationList removeAllObjects];
            NotificationList = NSMutableArray.new;
        }
        isPullToRefresh = NO;
        isLoadMoreCalled = YES;
        
        if (error) {
            [UIAlertView showWithTitle:AppName message:[error.userInfo objectForKey:@"msg"] cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        }
        else {
            if ([objects count] == 0) {
                [UIView animateWithDuration:0.8 animations:^() {
                    [tblNotification setBackgroundView:defaultImageNotification];
                    defaultImageNotification.image = [UIImage imageNamed:@"nonotification"];
                    defaultImageNotification.hidden = NO;
                }];
            }
            else {
                [UIView animateWithDuration:0.8 animations:^() {
                    defaultImageNotification.hidden = YES;
                    [tblNotification setBackgroundView:nil];
                }];
            }
            
            if (nextUrl != nil)
                nextFirstRecord = [nextUrl integerValue];
            
            
            [NotificationList addObjectsFromArray:objects];
            filteredNotificationArr = NSArray.new;
            filteredNotificationArr = NotificationList;
            
            switch (selectedSegment) {
                case NotBattle:
                    [self setNonBattleNotification];
                    break;
                case BattleType:
                    [self setBattleNotifications];
                    break;
                default:
                    break;
            }
            
            
        }
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height) {
        if (isLoadMoreCalled) {
            //            isPullToRefresh = NO;
            isLoadMoreCalled = NO;
            if (NotificationList.count < nextFirstRecord)
                [self getNotificationForUser:[SessionDetail currentSession].userDetail.userId];
        }
    }
}

#pragma mark - User Action

-(IBAction)segmentValueChanged:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl*) sender;
    
    switch (segment.selectedSegmentIndex) {
        case 0:
        {
            [self setNonBattleNotification];
        }
            break;
        case 1:
        {
            [self setBattleNotifications];
        }
            break;
        default:
            break;
    }
}



-(void) setBattleNotifications {
    selectedSegment = BattleType;
    NSPredicate *filter ;
    filter= [NSPredicate predicateWithFormat:@"SELF.notification_CATEGORY ==[c] %@", @"BATTLE"];
    filteredNotificationArr = NSArray.new;
    filteredNotificationArr = [NotificationList filteredArrayUsingPredicate:filter];
    [tblNotification reloadData];
}

-(void) setNonBattleNotification {
    selectedSegment = NotBattle;
    NSPredicate *filter ;
    filter= [NSPredicate predicateWithFormat:@"SELF.notification_CATEGORY !=[c] %@", @"BATTLE"];
    filteredNotificationArr = NSArray.new;
    filteredNotificationArr = [NotificationList filteredArrayUsingPredicate:filter];
    [tblNotification reloadData];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return filteredNotificationArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getHeightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - TableView Data source Custom methods

-(CGFloat)getHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
    return ((UITableViewCell*)[self getCellForRowAtIndexPath:indexPath]).contentView.frame.size.height;
}

-(UITableViewCell*)getCellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NotificationCell *cell = [tblNotification dequeueReusableCellWithIdentifier:@"notificationCell"];
    if (cell)
    {
        NotificationDetail *notification= (NotificationDetail *) [filteredNotificationArr objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];

        cell.lblMessage.text = notification.notification_TEXT;
        [cell.imgUser setImageWithURL:[NSURL URLWithString:notification.notification_PROFILE_PIC] placeholderImage:[GlobalHelper setPlaceholder:ProfilePlaceHolder]];
        cell.imgUser.backgroundColor = [UIColor lightGrayColor];
        cell.imgUser.layer.cornerRadius = CGRectGetWidth(cell.imgUser.frame) / 2.0f;
        cell.imgUser.layer.masksToBounds = YES;
        
        switch (selectedSegment) {
            case NotBattle:
            {
                cell.btnRejectBattle.hidden = YES;
                
                cell.btnAcceptBattle.hidden = YES;
                
                cell.RejectedBattle.hidden = YES;
                cell.btnMakePostForbattle.hidden = YES;
            }
                break;
            case BattleType:
            {
                SWITCH(notification.notification_TYPE) {
                    CASE(battleAcceptedNotification)
                    {
                        cell.RejectedBattle.hidden = YES;
                        cell.btnMakePostForbattle.hidden = NO;
                        cell.btnRejectBattle.hidden = YES;
                        cell.btnAcceptBattle.hidden = YES;
                        
                        [cell.btnMakePostForbattle addTarget:self action:@selector(makePostForbattle:) forControlEvents:UIControlEventTouchUpInside];
                        
                        break;
                    }
                    CASE(battleRejectedNotification)
                    {
                        cell.RejectedBattle.hidden = NO;
                        cell.btnMakePostForbattle.hidden = YES;
                        cell.btnRejectBattle.hidden = YES;
                        cell.btnAcceptBattle.hidden = YES;
                        break;
                    }
                    CASE(battleInvitationNotification)
                    {
                        [cell.btnAcceptBattle setTag:indexPath.row];
                        [cell.btnRejectBattle setTag:indexPath.row];
                        
                        cell.btnRejectBattle.hidden = NO;
                        cell.btnAcceptBattle.hidden = NO;
                        
                        cell.RejectedBattle.hidden = YES;
                        cell.btnMakePostForbattle.hidden = YES;
                        
                        cell.btnAcceptBattle.accessibilityIdentifier = notification.notification_BATTLE_ID;
                        cell.btnAcceptBattle.accessibilityValue = notification.notification_ID;

                        cell.btnRejectBattle.accessibilityIdentifier = notification.notification_BATTLE_ID;
                        cell.btnRejectBattle.accessibilityValue = notification.notification_ID;
                        
                        [cell.btnAcceptBattle addTarget:self action:@selector(acceptReject:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [cell.btnRejectBattle addTarget:self action:@selector(acceptReject:) forControlEvents:UIControlEventTouchUpInside];
                        break;
                    }
                    CASE(battlePostNotification)
                    {
                        cell.btnRejectBattle.hidden = YES;
                        cell.btnAcceptBattle.hidden = YES;
                        cell.RejectedBattle.hidden = YES;
                        cell.btnMakePostForbattle.hidden = YES;
                        [cell.contentView setBackgroundColor:[UIColor colorWithRed:9 green:45 blue:27 alpha:0.6]];
                        break;
                    }
                    DEFAULT;
                        break;
                }
            }
                break;
            default:
                break;
        }
        
        cell.sepratorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.contentView.frame), 1)];
        cell.sepratorView.backgroundColor = [UIColor clearColor];
        cell.sepratorView.image = [UIImage imageNamed:@"divider"];
        [cell addSubview:cell.sepratorView];
    }
    
    return cell;
}

#pragma mark - accept / reject battle

-(IBAction)acceptReject:(id)sender {
    NSString *param;
    SWITCH(((UIButton *) sender).titleLabel.text)
    {
        CASE (@"Accept")
        {
            param = [NSString stringWithFormat:@"battle_id=%@&request_to_user_id=%@&action=accepted&notification_id=%@", ((UIButton *) sender).accessibilityIdentifier, [SessionDetail currentSession].userDetail.userId,((UIButton *) sender).accessibilityValue];
            break;
        }
        CASE (@"Reject")
        {
            param = [NSString stringWithFormat:@"battle_id=%@&request_to_user_id=%@&action=rejected&notification_id=%@", ((UIButton *) sender).accessibilityIdentifier, [SessionDetail currentSession].userDetail.userId,((UIButton *) sender).accessibilityValue];
            break;
        }
        DEFAULT
            break;
    }
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    
    [service BattleService:WSAcceptRejectbattle parameters:param customeobject:Nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
        if (error) {
            [UIAlertView showWithTitle:AppName message:[error.userInfo objectForKey:@"msg"] cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        }
        else {
            NotificationDetail *notification = [filteredNotificationArr objectAtIndex:((UIButton *) sender).tag];
            if ([((UIButton *) sender).titleLabel.text isEqualToString:@"Accept"]) {
                [GlobalHelper showHUDLoaderwithType:successMessage message:@"Battle accepted successfully!"];
                notification.notification_TYPE  = battleAcceptedNotification;
                notification.notification_TEXT  = [NSString stringWithFormat:@"Accepted battle request from %@", notification.notification_USERNAME];
                [tblNotification reloadData];
            }
            else {
                [GlobalHelper showHUDLoaderwithType:successMessage message:@"Battle rejected successfully!"];
                notification.notification_TYPE  = battleRejectedNotification;
                notification.notification_TEXT  = [NSString stringWithFormat:@"Rejected battle request from %@", notification.notification_USERNAME];
                [tblNotification reloadData];
            }
            notification = nil;
        }
        
    }];
}


- (IBAction)makePostForbattle:(id)sender
{
    SelectedBattlePostNotification = [filteredNotificationArr objectAtIndex:((UIButton *) sender).tag];
    
    selectedNotificationIndex = ((UIButton *) sender).tag;
    
    PostVC *postVC = getVC(@"Post", @"idPostVC");
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:postVC];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    app.forBattleProcess = YES;
    app.globNotificationID = SelectedBattlePostNotification.notification_ID;
    app.globBattleID = SelectedBattlePostNotification.notification_BATTLE_ID;
    postVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - received notification to raload Table
- (void) reloadNotification:(NSNotification *) notification {
    SelectedBattlePostNotification = [filteredNotificationArr objectAtIndex:selectedNotificationIndex];
    SelectedBattlePostNotification.notification_TYPE  = battlePostNotification;
    [tblNotification reloadData];
}

@end