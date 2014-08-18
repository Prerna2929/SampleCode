//
//  SearchuserForBattleVC.m
//  RatingVoting
//
//  Created by c32 on 06/08/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "SearchuserForBattleVC.h"
#import "SearchCell.h"
#import "WebServiceParser+Search.h"
#import "WebServiceParser+Battle.h"
#import "UIImageView+WebCache.h"
#import "SearchDetail.h"

@interface SearchuserForBattleVC ()
{
    IBOutlet UIView *topNavigationView;
    NSMutableArray *userSearchList, *searchList;
}
@end

@implementation SearchuserForBattleVC

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
    app.needToCallCenterWillApper = NO;
    searchList  =[NSMutableArray new];
    userSearchList = [NSMutableArray new];
    [topNavigationView setBackgroundColor:[ThemeManger getThemeColorForApp]];
    [self.view setBackgroundColor:[ThemeManger getThemeBackgroundColor]];
    [tblUserSearch setBackgroundColor:[UIColor clearColor]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        userSearchList = [NSMutableArray new];
        
        [CacheData getcachedataArrayFor_:keySearchUserList myMethod:^(BOOL finished, NSMutableArray *retrivedArray)
        {
            if(finished){
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    [userSearchList addObjectsFromArray:retrivedArray];
                    
                    if (userSearchList.count > 0) {
                        [self setAllUsers];
                    }
                }];
            }
        }];
    });
}

#pragma mark - search bar delegate method

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [userSearchbar resignFirstResponder];
    
    if (userSearchbar.text.length == 0) {
        [self setAllUsers];
    }
    else {
        [self searchUser];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [userSearchbar resignFirstResponder];
}

-(void)setAllUsers
{
    searchList = NSMutableArray.new;
    [searchList removeAllObjects];
    [searchList addObjectsFromArray:userSearchList];
    [tblUserSearch reloadData];
}


-(void)searchUser
{
    [GlobalHelper showHUDLoaderwithType:blackMask message:@"Searching..."];
    
    WebServiceParser *server = [WebServiceParser sharedMediaServer];
    
    [server searchRequest:WSSearchUser
               parameters:[NSString stringWithFormat:@"user_id=%@&search_criteria=%@&search_term=%@&start_record=%@&batchValue=%@",[SessionDetail currentSession].userDetail.userId,@"user",userSearchbar.text,@"0",@"50"]
            customeobject:nil
                    block:^(NSError *error, id objects, NSString *responseString,NSString *nextUrl) {
                        if (error) {
                            [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                            [UIAlertView showWithTitle:AppName message:([error.userInfo objectForKey:@"msg"] != nil) ? [error.userInfo objectForKey:@"msg"] : error.localizedDescription cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            }];
                        }
                        else {
                            [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                            
                            SearchDetail *searchdetail = (SearchDetail*) objects;
                            
                            [userSearchList removeAllObjects];
                            [userSearchList addObjectsFromArray:searchdetail.searchList];
                            
                            [CacheData setCacheToUserDefaults:userSearchList ForKey:keySearchUserList];
                            
                            if (userSearchList.count == 0) {
                                [GlobalHelper dispToastMessage:@"No user found!"];
                            }
                            
                            [self setAllUsers];
                        }
                    }];
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
//    if (selSearchType == TagSearchType) {
//        
//        [self closeDrawer];
//        
//        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
//            TrendsVC *trendsVC = (TrendsVC *)[[app.centralNavController viewControllers] firstObject];
//            trendsVC.isDefaultMode = NO;
//            trendsVC.selectedPost = [searchList objectAtIndex:indexPath.row];
//            trendsVC.trendSegment.hidden = YES;
//            [trendsVC.colTrends reloadData];
//        }];
//    }
//    else
//    {
//        UserDetail *user = [searchList objectAtIndex:indexPath.row];
//        MainTabBarVC *tabbarVC = [[app.leftNavController viewControllers] objectAtIndex:0];
//        
//        [tabbarVC.profileVC visitUser: user.userId visitedUserobj:user];
//        
//        tabbarVC.selectedIndex = 0;
//        [tabbarVC selectTab:tabbarVC.profile];
//    }
}

#pragma mark - TableView Data source Custom methods

-(CGFloat)getHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((UITableViewCell*)[self getCellForRowAtIndexPath:indexPath]).contentView.frame.size.height;
}

-(UITableViewCell*)getCellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    SearchCell *cell = [tblUserSearch dequeueReusableCellWithIdentifier:@"searchUserCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    UserDetail *user = [searchList objectAtIndex:indexPath.row];
    cell.lblUserName.text = user.username;
    cell.lblPostDescription.text = user.nickname;
    [cell.imgUser setImageWithURL:[NSURL URLWithString:user.profilePicture] placeholderImage:[GlobalHelper setPlaceholder:ProfilePlaceHolder]];
    cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.height/2;
    cell.imgUser.layer.masksToBounds = YES;
    
    [cell.inviteForBattle addTarget:self action:@selector(inviteForBattle:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.inviteForBattle setAccessibilityIdentifier:user.userId];
    
    if ([user.userId isEqualToString:[SessionDetail currentSession].userDetail.userId])
        cell.inviteForBattle.hidden=YES;
    else
        cell.inviteForBattle.hidden=NO;
    
    cell.sepratorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.contentView.frame), 1)];
    cell.sepratorView.backgroundColor = [UIColor clearColor];
    cell.sepratorView.image = [UIImage imageNamed:@"divider"];
    [cell addSubview:cell.sepratorView];
    
    return cell;
}


#pragma mark - Invite for Battle

- (IBAction)inviteForBattle:(id)sender {
    WebServiceParser *server = [WebServiceParser sharedMediaServer];
    
    [server BattleService:WSInviteForBattle parameters:[NSString stringWithFormat:@"request_from=%@&request_to=%@", [SessionDetail currentSession].userDetail.userId, [sender accessibilityIdentifier]] customeobject:nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
        if (error) {
            [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
            [UIAlertView showWithTitle:AppName message:([error.userInfo objectForKey:@"msg"] != nil) ? [error.userInfo objectForKey:@"msg"] : error.localizedDescription cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        }
        else {
            if ([responseString isEqualToString:@"success"])
                [GlobalHelper dispToastMessage:@"Sent invitation successfully!"];
        }
    }];
}


- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}



@end
