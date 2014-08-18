//
//  NotificationDetail.m
//  RatingVoting
//
//  Created by c32 on 23/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "NotificationDetail.h"

/*
 "id": "21",
 "notification_to": "1",
 "notification_from": "3",
 "notification_text": "Hi apanarola , user id 3 has upvoted your post. that post id is 140",
 "notification_category": "POST",
 "post_id": "140",
 "comment_id": "0",
 "battle_id": "0",
 "notification_type": "VotePostUp",
 "created_on": "2014-07-23 11:01:07",
 "profile_picture": "http://192.168.1.202/ratevoteapp/uploads/no_profile_picture.png"
*/

NSString *const kNotificationID = @"id";
NSString *const kNotificationTO = @"notification_to";
NSString *const kNotificationFROM = @"notification_from";
NSString *const kNotificationTEXT = @"notification_text";
NSString *const kNotificationCATEORY = @"notification_category";
NSString *const kNotificationPOST_ID = @"post_id";
NSString *const kNotificationCOMMENT_ID = @"comment_id";
NSString *const kNotificationBATTLE_ID = @"battle_id";
NSString *const kNotificationTYPE = @"notification_type";
NSString *const kNotificationCREATED_ON = @"created_on";
NSString *const kNotificationPROFILE_PICTURE = @"profile_picture";
NSString *const kNotificationUserName = @"username";


@implementation NotificationDetail

@synthesize notification_BATTLE_ID = _notification_BATTLE_ID;
@synthesize notification_COMMENT_ID = _notification_COMMENT_ID;
@synthesize notification_FROM = _notification_FROM;
@synthesize notification_POST_ID = _notification_POST_ID;
@synthesize notification_ID = _notification_ID;
@synthesize notification_TYPE = _notification_TYPE;
@synthesize notification_CATEGORY = _notification_CATEGORY;
@synthesize notification_CREATED_ON = _notification_CREATED_ON;
@synthesize notification_PROFILE_PIC = _notification_PROFILE_PIC;
@synthesize notification_TEXT = _notification_TEXT;
@synthesize notification_TO = _notification_TO;
@synthesize notification_USERNAME = _notification_USERNAME;

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];

    if(self && [dict isKindOfClass:[NSDictionary class]])
    {
        self.notification_BATTLE_ID = [self objectOrNilForKey:kNotificationBATTLE_ID fromDictionary:dict];
        self.notification_CATEGORY = [self objectOrNilForKey:kNotificationCATEORY fromDictionary:dict];
        
        if ([self.notification_CATEGORY isEqualToString:@"BATTLE"]) {
            NSLog(@"if condition");
        }
        
        self.notification_COMMENT_ID = [self objectOrNilForKey:kNotificationCOMMENT_ID fromDictionary:dict];
        self.notification_CREATED_ON = [self objectOrNilForKey:kNotificationCREATED_ON fromDictionary:dict];
        self.notification_FROM = [self objectOrNilForKey:kNotificationFROM fromDictionary:dict];
        self.notification_ID = [self objectOrNilForKey:kNotificationID fromDictionary:dict];
        self.notification_POST_ID = [self objectOrNilForKey:kNotificationPOST_ID fromDictionary:dict];
        self.notification_PROFILE_PIC = [self objectOrNilForKey:kNotificationPROFILE_PICTURE fromDictionary:dict];
        self.notification_TEXT = [self objectOrNilForKey:kNotificationTEXT fromDictionary:dict];
        self.notification_TO = [self objectOrNilForKey:kNotificationTO fromDictionary:dict];
        self.notification_TYPE = [self objectOrNilForKey:kNotificationTYPE fromDictionary:dict];
        self.notification_USERNAME = [self objectOrNilForKey:kNotificationUserName fromDictionary:dict];
    }
    return self;
}

#pragma mark - Helper Method

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end