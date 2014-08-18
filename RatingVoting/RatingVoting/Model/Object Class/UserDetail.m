//
//  UserDetail.m
//  RatingVoting
//
//  Created by c85 on 09/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "UserDetail.h"

NSString *const kUserName = @"username";
NSString *const kUserId = @"id";
NSString *const kUserPassword = @"password";
NSString *const kUserEmailId = @"email_id";
NSString *const kUserTotalCoins = @"total_coins";
NSString *const kUserTotalBattleWon = @"total_battle_won";
NSString *const kUserTotalPosting = @"total_posting";
NSString *const kUserProfilePicture = @"profile_picture";
NSString *const kUserDeviceType = @"device_type";
NSString *const kUserTotalFollowers = @"total_followers";
NSString *const kUserDeviceToken = @"device_token";
NSString *const kUserTotalTrophies = @"total_trophies";
NSString *const kUserToken = @"token";
NSString *const kUserNickname = @"nickname";
NSString *const kUserEmail = @"email";
NSString *const kFollowStatus = @"login_user_follow_status";

@interface UserDetail ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation UserDetail

@synthesize userId = _userId;
@synthesize totalCoins = _totalCoins;
@synthesize totalBattleWon = _totalBattleWon;
@synthesize totalPosting = _totalPosting;
@synthesize profilePicture = _profilePicture;
@synthesize deviceType = _deviceType;
@synthesize totalFollowers = _totalFollowers;
@synthesize password = _password;
@synthesize deviceToken = _deviceToken;
@synthesize totalTrophies = _totalTrophies;
@synthesize token = _token;
@synthesize username = _username;
@synthesize nickname = _nickname;
@synthesize email = _email;
@synthesize follow_state = _follow_state;
@synthesize followStatus = _followStatus;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.userId = [self objectOrNilForKey:kUserId fromDictionary:dict];
        if (self.userId==nil) {
            self.userId = [self objectOrNilForKey:@"user_id" fromDictionary:dict];
        }
        self.follow_state = [self objectOrNilForKey:kUserTotalCoins fromDictionary:dict];
        
        self.totalCoins = [self objectOrNilForKey:kUserTotalCoins fromDictionary:dict];
        self.totalBattleWon = [self objectOrNilForKey:kUserTotalBattleWon fromDictionary:dict];
        self.totalPosting = [self objectOrNilForKey:kUserTotalPosting fromDictionary:dict];
        self.profilePicture = [self objectOrNilForKey:kUserProfilePicture fromDictionary:dict];
        self.deviceType = [self objectOrNilForKey:kUserDeviceType fromDictionary:dict];
        self.totalFollowers = [self objectOrNilForKey:kUserTotalFollowers fromDictionary:dict];
        self.password = [self objectOrNilForKey:kUserPassword fromDictionary:dict];
        self.deviceToken = [self objectOrNilForKey:kUserDeviceToken fromDictionary:dict];
        self.totalTrophies = [self objectOrNilForKey:kUserTotalTrophies fromDictionary:dict];
        self.token = [self objectOrNilForKey:kUserToken fromDictionary:dict];
        self.username = [self objectOrNilForKey:kUserName fromDictionary:dict];
        self.nickname = [self objectOrNilForKey:kUserNickname fromDictionary:dict];
        self.email = [self objectOrNilForKey:kUserEmail fromDictionary:dict];

        if (self.email == nil)
            self.email = [self objectOrNilForKey:kUserEmailId fromDictionary:dict];
        
        self.followStatus = [[self objectOrNilForKey:kFollowStatus fromDictionary:dict] boolValue];
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.userId forKey:kUserId];
    [mutableDict setValue:self.totalCoins forKey:kUserTotalCoins];
    [mutableDict setValue:self.totalBattleWon forKey:kUserTotalBattleWon];
    [mutableDict setValue:self.totalPosting forKey:kUserTotalPosting];
    [mutableDict setValue:self.profilePicture forKey:kUserProfilePicture];
    [mutableDict setValue:self.deviceType forKey:kUserDeviceType];
    [mutableDict setValue:self.totalFollowers forKey:kUserTotalFollowers];
    [mutableDict setValue:self.password forKey:kUserPassword];
    [mutableDict setValue:self.deviceToken forKey:kUserDeviceToken];
    [mutableDict setValue:self.totalTrophies forKey:kUserTotalTrophies];
    [mutableDict setValue:self.token forKey:kUserToken];
    [mutableDict setValue:self.username forKey:kUserName];
    [mutableDict setValue:self.nickname forKey:kUserNickname];
    [mutableDict setValue:self.email forKey:kUserEmail];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.userId = [aDecoder decodeObjectForKey:kUserId];
    self.totalCoins = [aDecoder decodeObjectForKey:kUserTotalCoins];
    self.totalBattleWon = [aDecoder decodeObjectForKey:kUserTotalBattleWon];
    self.totalPosting = [aDecoder decodeObjectForKey:kUserTotalPosting];
    self.profilePicture = [aDecoder decodeObjectForKey:kUserProfilePicture];
    self.deviceType = [aDecoder decodeObjectForKey:kUserDeviceType];
    self.totalFollowers = [aDecoder decodeObjectForKey:kUserTotalFollowers];
    self.password = [aDecoder decodeObjectForKey:kUserPassword];
    self.deviceToken = [aDecoder decodeObjectForKey:kUserDeviceToken];
    self.totalTrophies = [aDecoder decodeObjectForKey:kUserTotalTrophies];
    self.token = [aDecoder decodeObjectForKey:kUserToken];
    self.username = [aDecoder decodeObjectForKey:kUserName];
    self.nickname = [aDecoder decodeObjectForKey:kUserNickname];
    self.email = [aDecoder decodeObjectForKey:kUserEmail];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_userId forKey:kUserId];
    [aCoder encodeObject:_totalCoins forKey:kUserTotalCoins];
    [aCoder encodeObject:_totalBattleWon forKey:kUserTotalBattleWon];
    [aCoder encodeObject:_totalPosting forKey:kUserTotalPosting];
    [aCoder encodeObject:_profilePicture forKey:kUserProfilePicture];
    [aCoder encodeObject:_deviceType forKey:kUserDeviceType];
    [aCoder encodeObject:_totalFollowers forKey:kUserTotalFollowers];
    [aCoder encodeObject:_password forKey:kUserPassword];
    [aCoder encodeObject:_deviceToken forKey:kUserDeviceToken];
    [aCoder encodeObject:_totalTrophies forKey:kUserTotalTrophies];
    [aCoder encodeObject:_token forKey:kUserToken];
    [aCoder encodeObject:_username forKey:kUserName];
    [aCoder encodeObject:_nickname forKey:kUserNickname];
    [aCoder encodeObject:_email forKey:kUserEmail];
}

- (id)copyWithZone:(NSZone *)zone
{
    UserDetail *copy = [[UserDetail alloc] init];
    
    if (copy) {
        
        copy.userId = [self.userId copyWithZone:zone];
        copy.totalCoins = [self.totalCoins copyWithZone:zone];
        copy.totalBattleWon = [self.totalBattleWon copyWithZone:zone];
        copy.totalPosting = [self.totalPosting copyWithZone:zone];
        copy.profilePicture = [self.profilePicture copyWithZone:zone];
        copy.deviceType = [self.deviceType copyWithZone:zone];
        copy.totalFollowers = [self.totalFollowers copyWithZone:zone];
        copy.password = [self.password copyWithZone:zone];
        copy.deviceToken = [self.deviceToken copyWithZone:zone];
        copy.totalTrophies = [self.totalTrophies copyWithZone:zone];
        copy.token = [self.token copyWithZone:zone];
        copy.username = [self.username copyWithZone:zone];
        copy.nickname = [self.nickname copyWithZone:zone];
        copy.email = [self.email copyWithZone:zone];
    }
    
    return copy;
}

@end
