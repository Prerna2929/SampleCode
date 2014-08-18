//
//  UINavigationController+RateVote.m
//  RatingVoting
//
//  Created by c85 on 16/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "UINavigationController+RateVote.h"


@implementation UINavigationController (RateVote)

-(void)setDefaultNavigationBarColor
{
    [self.navigationBar setTranslucent:NO];
    [self.navigationBar setOpaque:YES];
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBg"] forBarMetrics:UIBarMetricsDefault];
}

@end
