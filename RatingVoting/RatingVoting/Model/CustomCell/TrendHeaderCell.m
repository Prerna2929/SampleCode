//
//  TrendHeaderCell.m
//  RatingVoting
//
//  Created by c85 on 11/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "TrendHeaderCell.h"

@implementation TrendHeaderCell

NSString *selectedUser;

@synthesize delegateGetCommentText;

- (id)initWithFrame:(CGRect)frame withType:(viewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        if (type == TableHeaderType)
            self = [[[NSBundle mainBundle] loadNibNamed:@"TrendHeaderCell" owner:self options:nil] objectAtIndex:0];
        else {
            self = [[[NSBundle mainBundle] loadNibNamed:@"TrendHeaderCell" owner:self options:nil] objectAtIndex:1];
            _txtComment.text = @"Write Comment Here";
            _txtComment.textColor = [UIColor lightGrayColor];
            _btnSend.enabled = NO;
            _txtComment.delegate = self;
            _txtComment.layer.cornerRadius = 5;
            _txtComment.layer.masksToBounds = YES;
        }
    }
    return self;
}

- (IBAction)getComment:(id)sender
{
    [delegateGetCommentText CommentText:_txtComment.text withID:selectedUser];
    _txtComment.text = @"";
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (_txtComment.text.length == 0 || [_txtComment.text isEqualToString:@"Write Comment Here"]) {
        _txtComment.text = @"";
    }
    _txtComment.textColor = [UIColor blackColor];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    //    textView.backgroundColor = [UIColor lightGrayColor];
}

- (void) textViewDidChange:(UITextView *)textView
{
    [delegateGetCommentText setDDListHidden:YES forTextView:textView withFilteredArray:nil];
    
    _txtComment.textColor = [UIColor blackColor];
    
    if (app.userNames)
    {
        // Split the text into words and find the words beginning with the character '@'
        _words = [[textView.text componentsSeparatedByString:@" "] mutableCopy];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] '@'"];
        NSArray* names = [_words filteredArrayUsingPredicate:predicate];
        if (_oldArray)
        {
            // To find the current editing name
            NSMutableSet* set1 = [NSMutableSet setWithArray:names];
            NSMutableSet* set2 = [NSMutableSet setWithArray:_oldArray];
            [set1 minusSet:set2];
            if (set1.count > 0)
            {
                _currentName = [[set1 allObjects] componentsJoinedByString:@""];
                _currentName = [_currentName stringByReplacingOccurrencesOfString:@"@" withString:@""];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.username contains[cd] %@", _currentName];
                NSArray *results = [app.userNames filteredArrayUsingPredicate:predicate];
                _currentNames = results;

                if (results.count > 0)
                {
                    [delegateGetCommentText setDDListHidden:NO forTextView:textView withFilteredArray:[_currentNames mutableCopy]];
                }
                else
                {
                    [delegateGetCommentText setDDListHidden:YES forTextView:textView withFilteredArray:nil];
                }
            }
        }
        _oldArray = [[NSArray alloc] initWithArray:names];
    }
    
    if (textView.text.length > 0) {
        _btnSend.enabled = YES;
    }
    else {
        _btnSend.enabled = NO;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if(_txtComment.text.length == 0)
    {
        _txtComment.textColor = [UIColor lightGrayColor];
        _txtComment.text = @"Write Comment Here";
    }
    else {
        _txtComment.textColor = [UIColor blackColor];
    }
    return YES;
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    // verify the text field you wanna validate
    if (textView == self.txtComment) {
        
        // do not allow the first character to be space | do not allow more than one space
        if ([text isEqualToString:@" "]) {
            if (!textView.text.length)
                return NO;
//            if ([[textView.text stringByReplacingCharactersInRange:range withString:text] rangeOfString:@"    "].length)
//                return NO;
        }
        
        // allow backspace
        if ([textView.text stringByReplacingCharactersInRange:range withString:text].length < textView.text.length) {
            return YES;
        }
        
        // in case you need to limit the max number of characters
//        if ([textView.text stringByReplacingCharactersInRange:range withString:text].length > 30) {
//            return NO;
//        }
        
        // limit the input to only the stuff in this character set, so no emoji or cirylic or any other insane characters
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.@!#$%&^*    "];
        
        if ([text rangeOfCharacterFromSet:set].location != NSNotFound) {
            return YES;
        }
        
        return NO;
    }
    
    return YES;
}

@end