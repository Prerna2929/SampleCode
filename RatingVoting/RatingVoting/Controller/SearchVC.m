//
//  SearchVC.m
//  RatingVoting
//
//  Created by c85 on 25/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "SearchVC.h"
#import "SearchCell.h"
#import "SearchDetail.h"
#import "MainTabBarVC.h"
#import "TrendsVC.h"
#import "PostDetail.h"
#import "UserProfileVC.h"
#import "MainTabBarVC.h"
#import "UIImageView+WebCache.h"
#import "WebServiceParser+Search.h"
#import "UIViewController+MMDrawerController.h"


typedef enum
{
    TagSearchType,
    UserSearchType
}SearchType;

@interface SearchVC ()
{
    SearchType selSearchType;
}
@property (nonatomic, strong) NSMutableArray *searchList, *tagList, *usersList;
@end

@implementation SearchVC

@synthesize searchList;

#pragma mark - Class Methodd

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
    _tagList = [[NSMutableArray alloc]init];
    _usersList = [[NSMutableArray alloc]init];
    searchList = [[NSMutableArray alloc]init];
    [self setAllTags];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    if ([DefaultsValues getIntegerValueFromUserDefaults_ForKey:@"badgeValue"] > 0) {
//        [MainTabBarVC hideNotificationView:NO];
//    }
    
    if ([MainTabBarVC isTabbarHidden]) {
        [MainTabBarVC showTabBar];
    }
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

- (void) viewWillDisappear:(BOOL)animated {
//    [MainTabBarVC hideNotificationView:NO];
}

#pragma mark - User Action

-(IBAction)segmentValueChanged:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl*) sender;
    
    switch (segment.selectedSegmentIndex) {
            
        case 0:
        {
            [self setAllTags];
        }
            break;
            
        case 1:
        {
            [self setAllUsers];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Others

-(void)setAllTags
{
    selSearchType = TagSearchType;
    [searchList removeAllObjects];
    [searchList addObjectsFromArray:_tagList];
    [tblSearch reloadData];
}

-(void)setAllUsers
{
    selSearchType = UserSearchType;
    [searchList removeAllObjects];
    [searchList addObjectsFromArray:_usersList];
    [tblSearch reloadData];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
    return [self getHeightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selSearchType == TagSearchType) {
        
        [self closeDrawer];
        
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
             TrendsVC *trendsVC = (TrendsVC *)[[app.centralNavController viewControllers] firstObject];
             trendsVC.isDefaultMode = NO;
             trendsVC.selectedPost = [searchList objectAtIndex:indexPath.row];
            trendsVC.trendSegment.hidden = YES;
             [trendsVC.colTrends reloadData];
        }];
    }
    else
    {
        UserDetail *user = [searchList objectAtIndex:indexPath.row];
        MainTabBarVC *tabbarVC = [[app.leftNavController viewControllers] objectAtIndex:0];
        
        [tabbarVC.profileVC visitUser: user.userId visitedUserobj:user];
        
        tabbarVC.selectedIndex = 0;
        [tabbarVC selectTab:tabbarVC.profile];
    }
}

#pragma mark - TableView Data source Custom methods

-(CGFloat)getHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((UITableViewCell*)[self getCellForRowAtIndexPath:indexPath]).contentView.frame.size.height;
}

-(UITableViewCell*)getCellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    SearchCell *cell = [tblSearch dequeueReusableCellWithIdentifier:@"searchCustomCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    if (selSearchType == TagSearchType) {
        
        PostDetail *postDetail = [searchList objectAtIndex:indexPath.row];
        cell.lblUserName.text = postDetail.postByUserName;
        cell.lblPostDescription.text = postDetail.postText;
        [cell.imgUser setImageWithURL:[NSURL URLWithString:postDetail.postImage] placeholderImage:[GlobalHelper setPlaceholder:SmallPostPlaceHolder]];
    }
    else {
        
        UserDetail *user = [searchList objectAtIndex:indexPath.row];
        cell.lblUserName.text = user.username;
        cell.lblPostDescription.text = @"";
        [cell.imgUser setImageWithURL:[NSURL URLWithString:user.profilePicture] placeholderImage:[GlobalHelper setPlaceholder:ProfilePlaceHolder]];
    }
    
    cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.height/2;
    cell.imgUser.layer.masksToBounds = YES;
    
    cell.sepratorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.contentView.frame), 1)];
    cell.sepratorView.backgroundColor = [UIColor clearColor];
    cell.sepratorView.image = [UIImage imageNamed:@"divider"];
    [cell addSubview:cell.sepratorView];
    
    return cell;
}

#pragma mark - Search delegates

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchbar resignFirstResponder];

    if (searchbar.text.length == 0) {
        selSearchType == TagSearchType ? [self setAllTags] : [self setAllUsers];
    }
    else {
        if (selSearchType == UserSearchType) {
            [self searchUser];
        }
        else {
            [self searchTag];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchbar resignFirstResponder];
}

-(void)searchUser
{
    [GlobalHelper showHUDLoaderwithType:blackMask message:@"Searching..."];

    WebServiceParser *server = [WebServiceParser sharedMediaServer];
    
    [server searchRequest:WSSearchUser
               parameters:[NSString stringWithFormat:@"user_id=%@&search_criteria=%@&search_term=%@&start_record=%@&batchValue=%@",[SessionDetail currentSession].userDetail.userId,@"user",searchbar.text,@"0",@"50"]
            customeobject:nil
                    block:^(NSError *error, id objects, NSString *responseString,NSString *nextUrl) {
                        if (error) {
                            [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                            [UIAlertView showWithTitle:AppName message:[error.userInfo objectForKey:@"msg"] cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            }];
                        }
                        else {
                            [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                            
                            SearchDetail *searchdetail = (SearchDetail*) objects;
                            
                            [_usersList removeAllObjects];
                            [_usersList addObjectsFromArray:searchdetail.searchList];
                            
                            if (_usersList.count == 0) {
                                [GlobalHelper dispToastMessage:@"No user found!"];
                            }
                            
                            [self setAllUsers];
                        }
                    }];
}

-(void)searchTag
{
    [GlobalHelper showHUDLoaderwithType:blackMask message:@"Searching..."];
    
    WebServiceParser *server = [WebServiceParser sharedMediaServer];
    
    [server searchRequest:WSSearchHasTag
               parameters:[NSString stringWithFormat:@"user_id=%@&search_criteria=%@&search_term=%@&start_record=%@&batchValue=%@",[SessionDetail currentSession].userDetail.userId,@"hashtag",searchbar.text,@"0",@"50"]
            customeobject:nil
                    block:^(NSError *error, id objects, NSString *responseString,NSString *nextUrl) {
                        if (error) {
                            [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                        }
                        else {
                            [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                            SearchDetail *searchdetail = (SearchDetail*) objects;
                            
                            [_tagList removeAllObjects];
                            [_tagList addObjectsFromArray:searchdetail.searchList];
                            
                            if (_tagList.count == 0) {
                                [GlobalHelper dispToastMessage:@"No tags found!"];
                            }
                            
                            [self setAllTags];
                        }
                    }];
}

@end
