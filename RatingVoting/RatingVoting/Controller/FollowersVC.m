//
//  FollowersVC.m
//  RatingVoting
//
//  Created by c85 on 09/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "FollowersVC.h"
#import "WebServiceParser+Followers.h"
#import "UITableView+Placeholder.h"
#import "WebService-Prefix.h"
#import "UIImageView+WebCache.h"
#import "FollowersCell.h"
#import "UserProfileVC.h"
#import "FollowersDetails.h"

@interface FollowersVC ()
{
    BOOL isPullToRefresh, isLoadMoreCalled;
    NSInteger nextStartRecordFollowers;
    
    NSString *currentUserId;
}

@property (readwrite, nonatomic) UIRefreshControl *refreshControlFollowers;

@end

@implementation FollowersVC
@synthesize followersList;

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
	self.title = @"Following";
    defaultFollowers.contentMode = UIViewContentModeScaleAspectFit;
    followersList = [[NSMutableArray alloc]init];
    self.refreshControlFollowers = [[UIRefreshControl alloc] init];
    self.refreshControlFollowers.tintColor = [UIColor whiteColor];
    [tblAllFollowers setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tblAllFollowers.alwaysBounceVertical = YES;
    [self.refreshControlFollowers addTarget:self
                            action:@selector(refresAchievementList)
                  forControlEvents:UIControlEventValueChanged];
    isLoadMoreCalled = YES;
    [tblAllFollowers addSubview:self.refreshControlFollowers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)refresAchievementList
{
    if ([tblAllFollowers numberOfSections]==0)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [tblAllFollowers reloadDataWithPlaceholderString:@"Searching more achievement details.." wihtUIColor:[UIColor lightTextColor]];
            
        }];
    }
    if (self.refreshControlFollowers!=nil)
    {
        if (tblAllFollowers.contentOffset.y <=0) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
                    
                    tblAllFollowers.contentOffset = CGPointMake(0, -self.refreshControlFollowers.frame.size.height);
                    
                } completion:^(BOOL finished){
                    
                    [self.refreshControlFollowers beginRefreshing];
                    isPullToRefresh = YES;
                    [self callFollowersWS];
                }];
            }];
        }
    }
    else
    {
        isPullToRefresh = YES;
        [self callFollowersWS];
    }
}

-(void)callFollowersWS
{
//    if (followersList.count == 0)
//        [GlobalHelper dispToastMessage:@"Fetching Followers.."];
    
    [GlobalHelper showActiviIndicatorOnView:defaultFollowers
                                  withStyle:UIActivityIndicatorViewStyleWhite
                                   hideShow:showIndicator
     ];
    
    nextStartRecordFollowers = isPullToRefresh ? 0 : nextStartRecordFollowers;
    
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    [service FollowersRequest:WSGetAllFollowers parameters:[NSString stringWithFormat:@"user_id=%@&start_record=%ld&logged_in_user=%@",currentUserId,(long)nextStartRecordFollowers, [SessionDetail currentSession].userDetail.userId] customeobject:nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
        [GlobalHelper showActiviIndicatorOnView:defaultFollowers
                                      withStyle:UIActivityIndicatorViewStyleWhite
                                       hideShow:hideIndicator
         ];
        if (isPullToRefresh) {
            [followersList removeAllObjects];
        }
        isPullToRefresh = NO;
        isLoadMoreCalled = YES;
        
        if (error) {
            TRC_DBG(@"fail to Load followers ");
            [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
        }
        else {
            [followersList addObjectsFromArray:objects];
            
            if (followersList.count > 0) {
                [UIView animateWithDuration:0.8 animations:^() {
                    defaultFollowers.hidden = YES;
                    [tblAllFollowers setBackgroundView:nil];
                }];
            }
            else {
                [UIView animateWithDuration:0.8 animations:^() {
                    [tblAllFollowers setBackgroundView:defaultFollowers];
                    defaultFollowers.image = [UIImage imageNamed:@"nofollowers"];
                    defaultFollowers.hidden = NO;
                }];
            }
            
            if (followersList.count <= [objects count]) {
                [CacheData setCacheToUserDefaults:followersList ForKey:keyMyFollowers];
            }
            [self.refreshControlFollowers endRefreshing];
            if (nextUrl != nil) nextStartRecordFollowers = [nextUrl integerValue];
            [tblAllFollowers reloadData];
            [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
        }
    }];
    
}

-(void) getAllFollowersForUserID : (NSString *) userID
{
    currentUserId = userID;
    if (followersList.count == 0)
        [self callFollowersWS];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tblAllFollowers) {
        return followersList.count;
    }
    else return 0;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [__delegate visitUser: ((UserDetail *) [followersList objectAtIndex:indexPath.row]).userId visitedUserobj:[followersList objectAtIndex:indexPath.row]];
}

#pragma mark - TableView Data source Custom methods

-(CGFloat)getHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    return ((UITableViewCell*)[self getCellForRowAtIndexPath:indexPath]).contentView.frame.size.height;
}

-(UITableViewCell*)getCellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    UserDetail *follower = [followersList objectAtIndex:indexPath.row];
    
    FollowersCell *cell = [tblAllFollowers dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell %ld", (long)follower.userId]];
    if (!cell) {
        
        cell = [[FollowersCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"Cell %ld", (long)follower.userId]];

        [cell.imgFollowerProfile setImageWithURL:[NSURL URLWithString:follower.profilePicture] placeholderImage:[GlobalHelper setPlaceholder:ProfilePlaceHolder]];
        
        cell.lblFollowerUserName.text = follower.username;
        
        CGSize size = [cell.lblFollowerUserName sizeThatFits:CGSizeMake(cell.lblFollowerUserName.frame.size.width, HUGE_VALF)];
        cell.lblFollowerUserName.frame = (CGRect) {.origin = cell.lblFollowerUserName.frame.origin, .size = {cell.lblFollowerUserName.frame.size.width, size.height}};
        
        cell.contentView.frame = (CGRect) {.origin = cell.contentView.frame.origin, .size = {cell.contentView.frame.size.width, 10 + size.height + CGRectGetMinY(cell.textLabel.frame)}};
    }
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height) {
        if (isLoadMoreCalled) {
            isLoadMoreCalled = NO;
            if (followersList.count < nextStartRecordFollowers)
                [self callFollowersWS];
        }
    }
}

@end