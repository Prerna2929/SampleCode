//
//  SettingsVC.m
//  RatingVoting
//
//  Created by c85 on 16/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "SettingsVC.h"
#import "LoginVC.h"
#import "UIViewController+MMDrawerController.h"
#import "UIViewController+Helper.h"
#import <QuartzCore/QuartzCore.h>

#define SettingList @[@"Push Notification",@"Vibration",@"Invite Friends",@"Contact to Admin",@"Change Password", @"Delete Account", @"Log Out"]

@interface SettingsVC ()
@property (nonatomic, strong) NSArray *settingList;
@end

@implementation SettingsVC

@synthesize settingList;

#pragma mark - Class Methods

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
    self.title = @"Settings";
    settingList = SettingList;
    
    [GlobalHelper performActionOnnavigationBarIsHidden:NO
                                              isOpaque:YES
                                         isTranslucent:NO
                                             tintColor:[ThemeManger getNavigationTintColor]
                               navigationbarTitleColor:[UIColor whiteColor]
                                  navigationController:self.navigationController];
    
    [tblSettings setTableFooterView:[UIView new]];
    [self addbackButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - add back button

- (void) addbackButton
{
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 2, 35, 35);
    btnLeft.backgroundColor = [UIColor clearColor];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return settingList.count;
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
    switch (indexPath.row) {
        case 0:
        {
        }
            break;
        case 1:
        {
        }
            break;
        case 2:
        {
        }
            break;
        case 3:
        {
        }
            break;
        case 4:
        {
        }
            break;
        case 6:
        {
            [UIAlertView showWithTitle:AppName message:@"Are you sure you want to logout?" cancelButtonTitle:@"NO" otherButtonTitles:@[@"YES"] setAccessibilityHint:@"logout" tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex != [alertView cancelButtonIndex])
                {
//                    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                        [SessionDetail currentSession].userDetail = nil;
                        [DefaultsValues removeObjectForKey:kUserName];
                        [DefaultsValues removeObjectForKey:kUserPassword];
                    [app.mainNavController popToRootViewControllerAnimated:YES];
                    
//                        LoginVC *loginController = (LoginVC *)[[app.mainNavController viewControllers] firstObject];
//                        app.mainNavController = [[UINavigationController alloc] initWithRootViewController:loginController];
//                        app.mainNavController.navigationBarHidden=YES;
//                        app.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//                        [app.window setRootViewController:app.mainNavController];
//                        [app.window makeKeyAndVisible];
//                    }];
                }
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - TableView Data source Custom methods

-(CGFloat)getHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((UITableViewCell*)[self getCellForRowAtIndexPath:indexPath]).contentView.frame.size.height;
}

-(UITableViewCell*)getCellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tblSettings dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell %d", indexPath.row]];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"Cell %d", indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.text = [settingList objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        cell.textLabel.frame = CGRectMake(20, 11, 150, 25);
        cell.textLabel.font = [ThemeManger getThemeFontWithSize:13.0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        switch (indexPath.row)
        {
            case 0:
            case 1:
            {
                UISwitch *notificationstatus = [[UISwitch alloc] initWithFrame:CGRectMake(260, 8, 50, 25)];
                [notificationstatus addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
                [notificationstatus setOnTintColor:[UIColor colorWithRed:0.45 green:0.90 blue:0.96 alpha:0.7f]];
                notificationstatus.backgroundColor = [UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1.0];
                notificationstatus.layer.cornerRadius = 16.0;
                notificationstatus.tintColor = [UIColor colorWithRed:0.45 green:0.90 blue:0.96 alpha:1.0f];
                [cell.contentView addSubview:notificationstatus];
            }
                break;
            default:
                break;
        }
    }
    return cell;
}

#pragma mark - handle switch status

- (void) switchToggled:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        [mySwitch setOn:YES animated:YES];
        mySwitch.thumbTintColor = [UIColor whiteColor];
    } else {
        [mySwitch setOn:NO animated:YES];
        mySwitch.thumbTintColor = [UIColor whiteColor];
    }
    mySwitch.tintColor = [UIColor colorWithRed:0.45 green:0.90 blue:0.96 alpha:1.0f];
}

@end
