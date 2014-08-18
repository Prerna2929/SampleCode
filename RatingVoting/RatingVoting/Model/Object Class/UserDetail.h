//
//  UserDetail.h
//  RatingVoting
//
//  Created by c85 on 09/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "BaseVC.h"

extern NSString *const kUserName;
extern NSString *const kUserId;
extern NSString *const kUserPassword;
extern NSString *const kUserEmailId;

@interface UserDetail : NSObject<NSCoding, NSCopying>

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *totalCoins;
@property (nonatomic, strong) NSString *totalBattleWon;
@property (nonatomic, strong) NSString *totalPosting;
@property (nonatomic, strong) NSString *profilePicture;
@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, strong) NSString *totalFollowers;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *totalTrophies;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *follow_state;
@property (nonatomic, assign) BOOL followStatus;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;
@end
