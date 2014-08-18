//
//  CustomTextField.m
//  RatingVoting
//
//  Created by c85 on 10/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "CustomTextField.h"



@implementation CustomTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setImage:[UIImage imageNamed:@"textClearBtn"] forState:UIControlStateNormal];
    [clearButton setFrame:CGRectMake(0, 0, 32, 32)];
    clearButton.imageEdgeInsets = (UIEdgeInsets){.right=10};
    [clearButton addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightViewMode:UITextFieldViewModeWhileEditing];
    [self setRightView:clearButton];
}

- (IBAction)clearTextField:(id)sender {
    self.text = @"";
}

@end
