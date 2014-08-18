//
//  MenuVC.m
//  RatingVoting
//
//  Created by c85 on 07/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "MenuVC.h"

#define Menus @[@"Trends",@"Share",@"Battle",@"Users",@"Favourite posts",@"Notifications",@"Settings",@"Logout"]

@interface MenuVC ()

@end

@implementation MenuVC

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return Menus.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *CustomCellIdentifier;
    
//    NSLog(@"%d",indexPath.row);
    
    if (cell == nil)
    {
        if (indexPath.row == 0) {
            
            CustomCellIdentifier = @"userCell";
            cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
            
            UIImageView *userImg = (UIImageView*)[cell viewWithTag:1];
            userImg.layer.cornerRadius = CGRectGetWidth(userImg.frame) /2;
            userImg.layer.masksToBounds = YES;
        }
        else if (indexPath.row == 1) {
            
            CustomCellIdentifier = @"scoreCell";
            cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
        }
        else {
            
            CustomCellIdentifier = @"menuCell";
            cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
            cell.textLabel.text = [Menus objectAtIndex:indexPath.row - 2];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    else if (indexPath.row == 1) {
        return 60;
    }
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [app.mainNavController popToRootViewControllerAnimated:YES];
}

@end
