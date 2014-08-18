//
//  UIViewController+Helper.h
//  Bringaz
//
//  Created by Parth Patel on 09/05/14.
//  Copyright (c) 2014 AlexWard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Helper)
- (void)tableView:(UITableView *)tableView
 performOperation:(void(^)())operation
       completion:(void(^)(BOOL finished))completion;

- (void)tableView:(UITableView *)tableView
 performOperation:(void(^)())operation
         tillTime:(NSInteger )Time
       completion:(void(^)(BOOL finished))completion;
@end
