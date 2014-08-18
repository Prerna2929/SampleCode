//
//  AchievementVC.m
//  RatingVoting
//
//  Created by c85 on 28/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "AchievementVC.h"
#import "AchievementDetail.h"
#import "UITableView+Placeholder.h"
#import "WebServiceParser+Achievements.h"

@interface AchievementVC ()
{
    BOOL isPullToRefresh, isLoadMoreCalled;
    NSInteger nextStartRecord;
    
    NSString *currentUserID;
}

@property (readwrite, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation AchievementVC
@synthesize achievemntList;

#pragma mark - Class Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    achievemntList = [[NSMutableArray alloc]init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    tblAchivements.alwaysBounceVertical = YES;
    isLoadMoreCalled = YES;
    defaultAchievement.contentMode = UIViewContentModeScaleAspectFit;
    [tblAchivements setTableFooterView:[UIView new]];
    [self.refreshControl addTarget:self
                            action:@selector(refresAchievementList)
                  forControlEvents:UIControlEventValueChanged];
    [tblAchivements addSubview:self.refreshControl];
}

-(void)viewWillAppear:(BOOL)animated
{
    isLoadMoreCalled = YES;
}

#pragma mark - Get Data

-(void)getAllAchivementsForUserID : (NSString *) userID
{
    currentUserID = userID;
    if (achievemntList.count == 0)
        [self callAchievementWSForUserID : currentUserID];
}

-(void)callAchievementWSForUserID : (NSString *) userID
{
//    if (achievemntList.count == 0)
//        [GlobalHelper dispToastMessage:@"Fetching Achivements.."];
    
    [GlobalHelper showActiviIndicatorOnView:defaultAchievement
                                  withStyle:UIActivityIndicatorViewStyleWhite
                                   hideShow:showIndicator
     ];
    
    nextStartRecord = isPullToRefresh ? 0 : nextStartRecord;
    
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    [service achivementRequest:WSGetAllAchivements
                    parameters:[NSString stringWithFormat:@"user_id=%@&start_record=%ld",userID,(long)nextStartRecord]
                 customeobject:nil
                         block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
                             
                             [GlobalHelper showActiviIndicatorOnView:defaultAchievement
                                                           withStyle:UIActivityIndicatorViewStyleWhite
                                                            hideShow:hideIndicator
                              ];
                             
                             if (isPullToRefresh) {
                                 [achievemntList removeAllObjects];
                             }
                             isPullToRefresh = NO;
                             isLoadMoreCalled = YES;
                             
                             if (error) {
                                 [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                             }
                             else {
                                 [achievemntList addObjectsFromArray:objects];
                                 
                                 if (achievemntList.count > 0) {
                                     [UIView animateWithDuration:0.8 animations:^() {
                                         defaultAchievement.hidden = YES;
                                         [tblAchivements setBackgroundView:nil];
                                     }];
                                 }
                                 else {
                                     [UIView animateWithDuration:0.8 animations:^() {
                                         [tblAchivements setBackgroundView:defaultAchievement];
                                         defaultAchievement.image = [UIImage imageNamed:@"noachievements"];
                                         defaultAchievement.hidden = NO;
                                     }];
                                 }

                                 if (achievemntList.count <= [objects count]) {
                                     [CacheData setCacheToUserDefaults:achievemntList ForKey:keyMyAchievements];
                                 }
                                 
                                 if (nextUrl != nil) nextStartRecord = [nextUrl integerValue];
                                 
                                 [self.refreshControl endRefreshing];

                                 [tblAchivements reloadData];
                                 [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                             }
                         }];
}

-(void)refresAchievementList
{
    if ([tblAchivements numberOfSections]==0)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [tblAchivements reloadDataWithPlaceholderString:@"Searching more achievement details.." wihtUIColor:[UIColor lightTextColor]];
            
        }];
    }
    if (self.refreshControl!=nil)
    {
        if (tblAchivements.contentOffset.y <=0) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
                    
                    tblAchivements.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
                    
                } completion:^(BOOL finished){
                    
                    [self.refreshControl beginRefreshing];
                    isPullToRefresh = YES;
                    [self callAchievementWSForUserID:currentUserID];
                }];
            }];
        }
    }
    else
    {
        isPullToRefresh = YES;
        [self callAchievementWSForUserID:currentUserID];
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tblAchivements) {
        return achievemntList.count;
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
}

#pragma mark - TableView Data source Custom methods

-(CGFloat)getHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((UITableViewCell*)[self getCellForRowAtIndexPath:indexPath]).contentView.frame.size.height;
}

-(UITableViewCell*)getCellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    AchievementDetail *achivement = [achievemntList objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tblAchivements dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell %ld", (long)achivement.achievementId]];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"Cell %ld", (long)indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        
        cell.textLabel.text = achivement.achievementName;
        cell.textLabel.textColor = [UIColor whiteColor];
        
        CGSize size = [cell.textLabel sizeThatFits:CGSizeMake(cell.textLabel.frame.size.width, HUGE_VALF)];
        cell.textLabel.frame = (CGRect) {.origin = cell.textLabel.frame.origin, .size = {cell.textLabel.frame.size.width, size.height}};
        
        //        if (size.height > 60) {
        cell.contentView.frame = (CGRect) {.origin = cell.contentView.frame.origin, .size = {cell.contentView.frame.size.width, 10 + size.height + CGRectGetMinY(cell.textLabel.frame)}};
        //        }
        //        else {
        //            cell.contentView.frame = (CGRect) {.origin = cell.contentView.frame.origin, .size = {cell.contentView.frame.size.width, 65}};
        //        }
    }
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height) {
        if (isLoadMoreCalled && nextStartRecord > 0) {
            isLoadMoreCalled = NO;
            if (achievemntList.count < nextStartRecord)
                [self getAllAchivementsForUserID:currentUserID];
        }
    }
}

@end
