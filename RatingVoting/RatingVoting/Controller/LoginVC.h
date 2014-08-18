//
//  LoginVC.h
//  RatingVoting
//
//  Created by c85 on 07/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomTextField;

@interface LoginVC : BaseVC <UITextFieldDelegate>
{
    IBOutlet UIView *signInView, *signUpView;
    IBOutlet UIButton *btnSignIn, *btnSignUp;
    IBOutlet CustomTextField *txtUserName, *txtPassword, *txtNickName, *txtCnfmPassword, *txtSignUpUserName, *txtSignUpPassword, *txtEmail;
}
@end
