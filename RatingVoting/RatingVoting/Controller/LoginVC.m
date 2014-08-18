//
//  LoginVC.m
//  RatingVoting
//
//  Created by c85 on 07/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "LoginVC.h"
#import "RegistrationVC.h"
#import "TrendsVC.h"
#import "ForgetPasswordVC.h"
#import "NSString+Extensions.h"
#import "CustomTextField.h"
#import "ICETutorialController.h"
#import "WebServiceParser+Login.h"
#import "IQKeyboardManager.h"

#define kSignInY 377
#define kSignUpY 431

@interface LoginVC ()
{
    BOOL isSignInOpen, isSignUpOpen;
    UITapGestureRecognizer *tap;
}
@end

@implementation LoginVC

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
    [self setTutorialView];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
//    [[IQKeyboardManager sharedManager] setEnable:YES];
//    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
//    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
//    [IQKeyboardManager sharedManager].canAdjustTextView =NO;
//    [IQKeyboardManager sharedManager].shouldAdoptDefaultKeyboardAnimation=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) handleTap:(UITapGestureRecognizer *)sender
{
    if (isSignInOpen)
        [self closeSignInView];
    if (isSignUpOpen)
        [self closeSignUpView];
}

#pragma mark - User Action

-(IBAction)signInClick:(id)sender
{
    if (isSignUpOpen) {
        [self closeSignUpView];
    }
    if (isSignInOpen) {
        
        if (txtUserName.text.length != 0 && txtPassword.text.length != 0) {
            
            WebServiceParser *server = [WebServiceParser sharedMediaServer];
            [self closeSignInView];
            [self.view endEditing:YES];
            
            [GlobalHelper showHUDLoaderwithType:blackMask message:@"Signing In, Please wait.."];
            
            [server loginRequest:WSLogin
                      parameters:[NSString stringWithFormat:@"username=%@&password=%@&device_token=%@",txtUserName.text, txtPassword.text, app.deviceUDID]
                      customeobject:nil
                              block:^(NSError *error, id objects, NSString *responseString,NSString *nextUrl) {
                 if (error) {
                     [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                     [UIAlertView showWithTitle:AppName message:[error.userInfo objectForKey:@"msg"] cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                     }];
                 }
                 else {
                     
                     UserDetail *curUser = (UserDetail*)objects;
                     
                     [self closeSignInView];
                     
                     [CacheData setObjectCacheToUserDefaults:curUser ForKey:keyCurrentUserObj];
                     
                     [DefaultsValues setStringValueToUserDefaults:txtUserName.text ForKey:kUserName];
                     [DefaultsValues setStringValueToUserDefaults:txtPassword.text ForKey:kUserPassword];
                     [DefaultsValues setStringValueToUserDefaults:curUser.userId ForKey:kUserId];
                     
                     [SessionDetail currentSession];
                     [SessionDetail currentSession].userDetail = curUser;
                     
                     txtUserName.text = @"";
                     txtPassword.text = @"";
                     
                     [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                     
                     [self setDrawerController];
                 }
             }];
        }
        else {
            [UIAlertView showWithTitle:AppName message:Alert_Login_Mandatory_Field cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        }
    }
    else {
        txtUserName.hidden = false;
        txtPassword.hidden = false;
        txtUserName.alpha = 0.0;
        txtPassword.alpha = 0.0;
        [self openSignInView];
    }
}

-(IBAction)signUpClick:(id)sender
{
    if (isSignInOpen) {
        [self closeSignInView];
    }
    
    if (isSignUpOpen) {
        
        if (txtSignUpUserName.text.length != 0 && txtEmail.text.length != 0 && txtSignUpPassword.text.length != 0 && txtCnfmPassword.text.length != 0 && txtNickName.text.length != 0) {
            
            if ([txtEmail.text isValidEmail]) {
                
                if ([txtSignUpPassword.text isEqualToString:txtCnfmPassword.text]) {
                    
                    WebServiceParser *server = [WebServiceParser sharedMediaServer];
                    
                    [GlobalHelper showHUDLoaderwithType:blackMask message:@"Please wait.."];
                    
                    [server loginRequest:WSRegistration
                              parameters:[NSString stringWithFormat:@"username=%@&password=%@&email=%@&nickname=%@&device_token=%@", txtSignUpUserName.text, txtSignUpPassword.text, txtEmail.text, txtNickName.text, app.deviceUDID]
                           customeobject:nil
                                   block:^(NSError *error, id objects, NSString *responseString,NSString *nextUrl) {
                                       if (error) {
                                           TRC_DBG(@"fail to Load Routes ");
                                           
                                           [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                                           [UIAlertView showWithTitle:AppName message:[error.userInfo objectForKey:@"msg"] cancelButtonTitle:@"OK" otherButtonTitles:nil setAccessibilityHint:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                               
                                           }];
                                       }
                                       else {
                                           UserDetail *curUser = (UserDetail*)objects;
                                           
                                           [UIAlertView showWithTitle:AppName message:[NSString stringWithFormat:@"Welcome! %@", curUser.username] cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                               
                                           }];
                                           
                                           [CacheData setObjectCacheToUserDefaults:curUser ForKey:keyCurrentUserObj];
                                           
                                           [self closeSignUpView];
                                           
                                           [DefaultsValues setStringValueToUserDefaults:txtSignUpUserName.text ForKey:kUserName];
                                           [DefaultsValues setStringValueToUserDefaults:txtSignUpPassword.text ForKey:kUserPassword];
                                           
                                           txtSignUpUserName.text = @"";
                                           txtEmail.text = @"";
                                           txtSignUpPassword.text = @"";
                                           txtCnfmPassword.text = @"";
                                           txtNickName.text = @"";
                                           
                                           [SessionDetail currentSession];
                                           [SessionDetail currentSession].userDetail = curUser;
                                           [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                                           [self setDrawerController];
                                       }
                                   }];
                }
                else {
                    [UIAlertView showWithTitle:AppName message:Alert_Registration_Mandatory_Retype_Password cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    }];
                }
            }
            else {
                [UIAlertView showWithTitle:AppName message:Alert_Registration_Mandatory_Email cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                }];
            }
        }
        else {
            [UIAlertView showWithTitle:AppName message:Alert_Registration_Mandatory_Field cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        }
    }
    else {
        
        txtEmail.alpha = 0.0;
        txtSignUpPassword.alpha = 0.0;
        txtCnfmPassword.alpha = 0.0;
        txtSignUpUserName.alpha = 0.0;
        txtNickName.alpha = 0.0;
        txtUserName.hidden = true;
        txtPassword.hidden = true;
        [self openSignUpView];
    }
}

#pragma mark - Animation for Sign in and Sign up view

-(void)setActiveImages
{
    UIButton *btnActive, *btnDeactivate;
    
    if (isSignInOpen) {
        btnActive = btnSignIn;
        btnDeactivate = btnSignUp;
    }
    else {
        btnActive = btnSignUp;
        btnDeactivate = btnSignIn;
    }
    [btnActive setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    btnActive.backgroundColor = [UIColor clearColor];
    btnActive.alpha = 0.8;
    
    [btnDeactivate setBackgroundImage:nil forState:UIControlStateNormal];
    btnDeactivate.backgroundColor = [UIColor blackColor];
    btnDeactivate.alpha = 1.0;
}

-(void)openSignInView
{
    isSignInOpen = YES;
    [UIView animateWithDuration:0.3 animations:^{
        
        [self setFrameOfControls:txtPassword WithParentView:signUpView];
        [self setFrameOfControls:txtUserName WithParentView:txtPassword];
        [self setFrameOfControls:signInView WithParentView:txtUserName];
        
        [self setActiveImages];
        
        txtUserName.alpha = 0.65;
        txtPassword.alpha = 0.65;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)openSignUpView
{
    isSignUpOpen = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        txtSignUpPassword.hidden = NO;
        txtEmail.hidden = NO;
        txtNickName.hidden = NO;
        txtSignUpUserName.hidden = NO;
        txtCnfmPassword.hidden = NO;
        
        CGRect frame = txtCnfmPassword.frame;
        frame.origin.y = CGRectGetHeight(self.view.frame) - CGRectGetHeight(txtCnfmPassword.frame);
        txtCnfmPassword.frame = frame;
        
        [self setFrameOfControls:txtSignUpPassword WithParentView:txtCnfmPassword];
        [self setFrameOfControls:txtEmail WithParentView:txtSignUpPassword];
        [self setFrameOfControls:txtNickName WithParentView:txtEmail];
        [self setFrameOfControls:txtSignUpUserName WithParentView:txtNickName];
        [self setFrameOfControls:signUpView WithParentView:txtSignUpUserName];
        [self setFrameOfControls:signInView WithParentView:signUpView];
        
        [self setActiveImages];
        
        txtNickName.alpha = 0.65;
        txtEmail.alpha = 0.65;
        txtSignUpPassword.alpha = 0.65;
        txtCnfmPassword.alpha = 0.65;
        txtSignUpUserName.alpha = 0.65;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)closeSignInView
{
    isSignInOpen = NO;
    [UIView animateWithDuration:.3 animations:^{
        
        [self setFrameOfControls:txtPassword WithParentView:signUpView];
        [self setFrameOfControls:txtUserName WithParentView:signUpView];
        [self setFrameOfControls:signInView WithParentView:signUpView];
        
        txtPassword.hidden = NO;
        txtUserName.hidden = NO;
        
    } completion:^(BOOL finished) {
        txtPassword.hidden = YES;
        txtUserName.hidden = YES;
//        signInView.hidden = YES;
    }];
}

-(void)closeSignUpView
{
    isSignUpOpen = NO;
    
    [UIView animateWithDuration:.3 animations:^{
        
        
        
        CGRect frame = txtSignUpPassword.frame;
        frame.origin.y = CGRectGetMinY(txtCnfmPassword.frame);
        txtSignUpPassword.frame = frame;
        
        frame = txtEmail.frame;
        frame.origin.y = CGRectGetMinY(txtCnfmPassword.frame);
        txtEmail.frame = frame;
        
        frame = txtNickName.frame;
        frame.origin.y = CGRectGetMinY(txtCnfmPassword.frame);
        txtNickName.frame = frame;
        
        frame = txtSignUpUserName.frame;
        frame.origin.y = CGRectGetMinY(txtCnfmPassword.frame);
        txtSignUpUserName.frame = frame;
        
        frame = signUpView.frame;
        frame.origin.y = CGRectGetHeight(self.view.frame) - CGRectGetHeight(signUpView.frame);
        signUpView.frame = frame;
        
        [self setFrameOfControls:signInView WithParentView:signUpView];
        
    } completion:^(BOOL finished) {
        txtSignUpPassword.hidden = YES;
        txtEmail.hidden = YES;
        txtNickName.hidden = YES;
        txtSignUpUserName.hidden = YES;
        txtCnfmPassword.hidden = YES;
        
    }];
}

#pragma mark - Set Frames

-(void)setFrameOfControls:(UIView*)control WithParentView:(UIView*)parentView
{
    CGRect frame = control.frame;
    frame.origin.y = CGRectGetMinY(parentView.frame) - (CGRectGetHeight(control.frame) + 5);
    control.frame = frame;
}

#pragma mark - Validation

-(void)checkEmail
{
}

#pragma mark - Tutorial View

-(void)setTutorialView
{
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 1"
                                                            description:@"Champs-Elysées by night"
                                                            pictureName:@"tutorial_background_00@2x.jpg"];
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 2"
                                                            description:@"The Eiffel Tower with\n cloudy weather"
                                                            pictureName:@"tutorial_background_01@2x.jpg"];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 3"
                                                            description:@"An other famous street of Paris"
                                                            pictureName:@"tutorial_background_02@2x.jpg"];
    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 4"
                                                            description:@"The Eiffel Tower with a better weather"
                                                            pictureName:@"tutorial_background_03@2x.jpg"];
    ICETutorialPage *layer5 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 5"
                                                            description:@"The Louvre's Museum Pyramide"
                                                            pictureName:@"tutorial_background_04@2x.jpg"];
    //
    //    // Set the common style for SubTitles and Description (can be overrided on each page).
//    ICETutorialLabelStyle *subStyle = [[ICETutorialLabelStyle alloc] init];
//    [subStyle setFont:TUTORIAL_SUB_TITLE_FONT];
//    [subStyle setTextColor:TUTORIAL_LABEL_TEXT_COLOR];
//    [subStyle setLinesNumber:TUTORIAL_SUB_TITLE_LINES_NUMBER];
//    [subStyle setOffset:TUTORIAL_SUB_TITLE_OFFSET];
//    
//    ICETutorialLabelStyle *descStyle = [[ICETutorialLabelStyle alloc] init];
//    [descStyle setFont:TUTORIAL_DESC_FONT];
//    [descStyle setTextColor:TUTORIAL_LABEL_TEXT_COLOR];
//    [descStyle setLinesNumber:TUTORIAL_DESC_LINES_NUMBER];
//    [descStyle setOffset:TUTORIAL_DESC_OFFSET];
    
    // Override point for customization after application launch.
    ICETutorialController *tutorialVC = [[ICETutorialController alloc] initWithPages:@[layer1,layer2,layer3,layer4,layer5]];
    [tutorialVC setAutoScrollLooping:YES];
    
    // Set the common styles, and start scrolling (auto scroll, and looping enabled by default)
//    [tutorialVC setCommonPageSubTitleStyle:subStyle];
//    [tutorialVC setCommonPageDescriptionStyle:descStyle];
    
    __block ICETutorialController* weakSelf = tutorialVC;
    
    [tutorialVC setButton2Block:^(UIButton *button){
        
        [weakSelf stopScrolling];
    }];

    [self.view addSubview:tutorialVC.view];
    [self.view sendSubviewToBack:tutorialVC.view];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tutorialVC.view addGestureRecognizer:tap];
    
    // Run it.
    [tutorialVC startScrolling];
}

//-(IBAction)forgetPasswordClick:(id)sender
//{
//    ForgetPasswordVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"idForgetPasswordVC"];
//    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController pushViewController:controller animated:YES];
//}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // verify the text field you wanna validate
    if ((textField != txtSignUpPassword) && (textField != txtPassword) && (textField != txtCnfmPassword)) {
    
        // do not allow the first character to be space | do not allow more than one space
        if ([string isEqualToString:@" "]) {
            if (!textField.text.length)
                return NO;
            if ([[textField.text stringByReplacingCharactersInRange:range withString:string] rangeOfString:@"  "].length)
                return NO;
        }
        
        // allow backspace
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length < textField.text.length) {
            return YES;
        }
        
        // in case you need to limit the max number of characters
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 50) {
            return NO;
        }
        
        // limit the input to only the stuff in this character set, so no emoji or cirylic or any other insane characters
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.@!#$% "];
        
        if ([string rangeOfCharacterFromSet:set].location != NSNotFound) {
            return YES;
        }
        
        return NO;
    }
    
    return YES;
}

@end
