//
//  UIViewController+Helper.m
//  Bringaz
//
//  Created by Parth Patel on 09/05/14.
//  Copyright (c) 2014 AlexWard. All rights reserved.
//

#import "UIViewController+Helper.h"

@implementation UIViewController (Helper)

- (void)tableView:(UITableView *)tableView
 performOperation:(void(^)())operation
       completion:(void(^)(BOOL finished))completion
{

    
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        // animation has finished
        if (completion)
            completion(YES);
    }];
    
    [tableView beginUpdates];
    if (operation)
        operation();
    [tableView endUpdates];
    
    [CATransaction commit];
    
}

- (void)tableView:(UITableView *)tableView
 performOperation:(void(^)())operation
         tillTime:(NSInteger )Time
       completion:(void(^)(BOOL finished))completion
{
    
    [UIView beginAnimations:@"myAnimationId" context:nil];
    
    [UIView setAnimationDuration:Time]; // Set duration here
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        // animation has finished
        if (completion)
            completion(YES);
    }];
    
    [tableView beginUpdates];
    if (operation)
        operation();
    [tableView endUpdates];
    
    [CATransaction commit];
    
    [UIView commitAnimations];
    
}


@end
