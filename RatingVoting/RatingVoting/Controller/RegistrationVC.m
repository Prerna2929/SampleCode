//
//  RegistrationVC.m
//  RatingVoting
//
//  Created by c85 on 07/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "RegistrationVC.h"
#import "UserDetail.h"
#import "TrendsVC.h"

@interface RegistrationVC ()
{
    UIView *signUpView;
    UserDetail *_newUser;
}

@end

@implementation RegistrationVC

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
    _newUser = [[UserDetail alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - User Action

-(IBAction)signUpClick:(id)sender
{
//    if (_newUser.firstName.length != 0 && _newUser.lastName.length != 0 && _newUser.email.length != 0 && _newUser.password.length != 0 && _newUser.rePassword.length != 0) {
//        
//        if ([_newUser.password isEqualToString:_newUser.rePassword]) {
//            
//            TrendsVC *trendsVC = getVC(@"Center", @"idTrendsVC");
//            [self.navigationController pushViewController:trendsVC animated:YES];
//        }
//        else {
//            [UIAlertView showWithTitle:AppName message:Alert_Registration_Mandatory_Retype_Password cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                
//            }];
//        }
//    }
//    else {
//        [UIAlertView showWithTitle:AppName message:Alert_Registration_Mandatory_Field cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            
//        }];
//    }
}

#pragma mark - TableView Methods

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (signUpView == nil) {
        signUpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tblRegistration.frame.size.width, 50)];
        signUpView.backgroundColor = [UIColor clearColor];
        
        UIButton *btnSignUp = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSignUp addTarget:self action:@selector(signUpClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnSignUp setTitle:@"Sign Up" forState:UIControlStateNormal];
        btnSignUp.frame = CGRectMake(0, 0, CGRectGetWidth(tblRegistration.frame), 35);
        btnSignUp.titleLabel.font = [UIFont systemFontOfSize:17.0];
        btnSignUp.titleLabel.textColor = [UIColor blueColor];
        btnSignUp.backgroundColor = [UIColor lightGrayColor];
        btnSignUp.alpha = 0.5;
        
        [signUpView addSubview:btnSignUp];
    }
    return signUpView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *CustomCellIdentifier;
    
    if (cell == nil)
    {
        if (indexPath.row == 0) {
            
            CustomCellIdentifier = @"userImgCell";
            cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
            
            UITextField *txtFirstName = (UITextField*) [cell viewWithTag:1];
            txtFirstName.placeholder = @"First Name";
            txtFirstName.tag = indexPath.row + 1;
            
            UITextField *txtLastName = (UITextField*) [cell viewWithTag:2];
            txtLastName.placeholder = @"Last Name";
            txtLastName.tag = indexPath.row + 2;
            
        }
        else {
            
            CustomCellIdentifier = @"inputCell";
            cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
            
            UITextField *tf = (UITextField*) [[cell.contentView subviews]objectAtIndex:0];
            tf.tag = indexPath.row + 2;
            
            switch (indexPath.row) {
                case 1:
                    tf.placeholder = @"Email";
                    break;
                case 2:
                    tf.placeholder = @"Password";
                    tf.secureTextEntry = YES;
                    break;
                case 3:
                    tf.placeholder = @"Re-Enter Password";
                    tf.secureTextEntry = YES;
                    break;
                default:
                    break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 110 : 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
//            _newUser.firstName = textField.text;
            break;
        case 2:
//            _newUser.lastName = textField.text;
            break;
        case 3:
            _newUser.email = textField.text;
            break;
        case 4:
            _newUser.password = textField.text;
            break;
        case 5:
//            _newUser.rePassword = textField.text;
            break;
        default:
            break;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
