//
//  AppConstant.h
//  RatingVoting
//
//  Created by c85 on 07/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#ifndef RatingVoting_AppConstant_h
#define RatingVoting_AppConstant_h


#pragma mark - Macros

#define AppName @"RatingVoting"


#pragma mark - Network Indicators

#define ShowNetworkIndicator(XXX) [UIApplication sharedApplication].networkActivityIndicatorVisible = XXX;


#pragma mark - Device

#define iPadDevice                  UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define IOS_OLDER_THAN_X(XX)            ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] < XX )
#define IOS_NEWER_OR_EQUAL_TO_X(XX)    ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= XX )

#pragma mark - StoryBoard

#define getStroyboard(StoryboardWithName) [UIStoryboard storyboardWithName:[NSString stringWithFormat:@"%@_%@",StoryboardWithName,iPadDevice?@"iPad":@"iPhone"] bundle:NULL]

#define getVC(StroyBoardName,VCIdentifer) [getStroyboard(StroyBoardName)instantiateViewControllerWithIdentifier:VCIdentifer]


#pragma mark - App delegate

#define app         ((AppDelegate*)[[UIApplication sharedApplication] delegate])


#define DownVoteImageArray @[ [UIImage imageNamed:@"dustbinAnim1.png"],\
                [UIImage imageNamed:@"dustbinAnim2.png"],\
                [UIImage imageNamed:@"dustbinAnim3.png"],\
                [UIImage imageNamed:@"dustbinAnim4.png"],\
                [UIImage imageNamed:@"dustbinAnim5.png"],\
                [UIImage imageNamed:@"dustbinAnim5.png"],\
                [UIImage imageNamed:@"dustbinAnim5.png"],\
                [UIImage imageNamed:@"dustbinAnim5.png"],\
                [UIImage imageNamed:@"dustbinAnim5.png"],\
                [UIImage imageNamed:@"dustbinAnim5.png"],\
                [UIImage imageNamed:@"dustbinAnim5.png"],\
                [UIImage imageNamed:@"dustbinAnim5.png"],\
                [UIImage imageNamed:@"dustbinAnim5.png"],\
                [UIImage imageNamed:@"dustbinAnim5.png"],\
                [UIImage imageNamed:@"dustbinAnim5.png"],\
                [UIImage imageNamed:@"dustbinAnim5.png"],\
                [UIImage imageNamed:@"dustbinAnim5.png"],\
                [UIImage imageNamed:@"dustbinAnim5.png"],\
                [UIImage imageNamed:@"dustbinAnim5.png"],\
                [UIImage imageNamed:@"dustbinAnim6.png"],\
                [UIImage imageNamed:@"dustbinAnim7.png"],\
                [UIImage imageNamed:@"dustbinAnim8.png"],\
                [UIImage imageNamed:@"dustbinAnim9.png"]]


#define UpVoteImageArray @[ [UIImage imageNamed:@"star1"],\
                [UIImage imageNamed:@"star2"],\
                [UIImage imageNamed:@"star3"],\
                [UIImage imageNamed:@"star4"],\
                [UIImage imageNamed:@"star5"],\
                [UIImage imageNamed:@"star6"],\
                [UIImage imageNamed:@"star7"],\
                [UIImage imageNamed:@"star8"],\
                [UIImage imageNamed:@"star9"],\
                [UIImage imageNamed:@"star10"],\
                [UIImage imageNamed:@"star11"],\
                [UIImage imageNamed:@"star12"],\
                [UIImage imageNamed:@"star13"],\
                [UIImage imageNamed:@"star14"]]


#pragma mark - Strings

#endif