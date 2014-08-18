//
//  NotificationDetail.h
//  RatingVoting
//
//  Created by c32 on 23/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationDetail : NSObject

@property (nonatomic, strong) NSString *notification_ID;
@property (nonatomic, strong) NSString *notification_TO;
@property (nonatomic, strong) NSString *notification_FROM;
@property (nonatomic, strong) NSString *notification_TEXT;
@property (nonatomic, strong) NSString *notification_CATEGORY;
@property (nonatomic, strong) NSString *notification_POST_ID;
@property (nonatomic, strong) NSString *notification_COMMENT_ID;
@property (nonatomic, strong) NSString *notification_BATTLE_ID;
@property (nonatomic, strong) NSString *notification_TYPE;
@property (nonatomic, strong) NSString *notification_CREATED_ON;
@property (nonatomic, strong) NSString *notification_PROFILE_PIC;
@property (nonatomic, strong) NSString *notification_USERNAME;


- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
