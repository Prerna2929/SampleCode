//
//  FollowersDetails.m
//  RatingVoting
//
//  Created by c32 on 07/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "FollowersDetails.h"

NSString *const kEmail = @"email";
NSString *const kFollowState = @"follow_state";
NSString *const kNickName = @"nickname";
NSString *const kProfilePicture = @"profile_picture";
NSString *const kTotalBattleWon = @"total_battle_won";
NSString *const kTotalCoins = @"total_coins";
NSString *const kTotalFollowers = @"total_followers";
NSString *const kTotalPosting = @"total_posting";
NSString *const kTotalTrophies = @"total_trophies";
NSString *const kUserNameFollower = @"username";
NSString *const kUserIdFollower = @"user_id";

@implementation FollowersDetails

@synthesize user_id = _user_id;
@synthesize email = _email;
@synthesize follow_state = _follow_state;
@synthesize nickname = _nickname;
@synthesize profile_picture = _profile_picture;
@synthesize total_battle_won = _total_battle_won;
@synthesize total_coins = _total_coins;
@synthesize total_followers = _total_followers;
@synthesize total_posting = _total_posting;
@synthesize total_trophies = _total_trophies;
@synthesize username = _username;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.email = [self objectOrNilForKey:kEmail fromDictionary:dict];
        
        self.follow_state = [self objectOrNilForKey:kFollowState fromDictionary:dict];
        
        self.nickname = [self objectOrNilForKey:kNickName fromDictionary:dict];
        
        self.profile_picture = [self objectOrNilForKey:kProfilePicture fromDictionary:dict];
        
        self.total_battle_won = [self objectOrNilForKey:kTotalBattleWon fromDictionary:dict];
        
        self.total_coins = [self objectOrNilForKey:kTotalCoins fromDictionary:dict];
        
        self.total_followers = [self objectOrNilForKey:kTotalFollowers fromDictionary:dict];
        
        self.total_posting = [self objectOrNilForKey:kTotalPosting fromDictionary:dict];
        
        self.total_trophies = [self objectOrNilForKey:kTotalTrophies fromDictionary:dict];
        
        self.user_id = [self objectOrNilForKey:kUserIdFollower fromDictionary:dict];
        
        self.username = [self objectOrNilForKey:kUserNameFollower fromDictionary:dict];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.email forKey:kEmail];
    [mutableDict setValue:self.follow_state forKey:kFollowState];
    
    [mutableDict setValue:self.nickname forKey:kNickName];
    
    [mutableDict setValue:self.profile_picture forKey:kProfilePicture];
    
    [mutableDict setValue:self.total_battle_won forKey:kTotalBattleWon];
    
    [mutableDict setValue:self.total_coins forKey:kTotalCoins];
    
    [mutableDict setValue:self.total_followers forKey:kTotalFollowers];
    
    [mutableDict setValue:self.total_posting forKey:kTotalPosting];
    
    [mutableDict setValue:self.total_trophies forKey:kTotalTrophies];
    
    [mutableDict setValue:self.user_id forKey:kUserIdFollower];
    
    [mutableDict setValue:self.username forKey:kUserNameFollower];
    
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
    
    self.email = [aDecoder decodeObjectForKey:kEmail];
   
    self.follow_state = [aDecoder decodeObjectForKey:kFollowState];
    
    self.nickname = [aDecoder decodeObjectForKey:kNickName];
    
    self.profile_picture = [aDecoder decodeObjectForKey:kProfilePicture];
    
    self.total_battle_won = [aDecoder decodeObjectForKey:kTotalBattleWon];
    
    self.total_coins = [aDecoder decodeObjectForKey:kTotalCoins];
    
    self.total_followers = [aDecoder decodeObjectForKey:kTotalFollowers];
    
    self.total_posting = [aDecoder decodeObjectForKey:kTotalPosting];
    
    self.total_trophies = [aDecoder decodeObjectForKey:kTotalTrophies];
    
    self.user_id = [aDecoder decodeObjectForKey:kUserIdFollower];
    
    self.username = [aDecoder decodeObjectForKey:kUserNameFollower];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_email forKey:kEmail];
    [aCoder encodeObject:_follow_state forKey:kFollowState];
    
    [aCoder encodeObject:_nickname forKey:kNickName];
    
    [aCoder encodeObject:_profile_picture forKey:kProfilePicture];
    
    [aCoder encodeObject:_total_battle_won forKey:kTotalBattleWon];
    
    [aCoder encodeObject:_total_coins forKey:kTotalCoins];
    
    [aCoder encodeObject:_total_followers forKey:kTotalFollowers];
    
    [aCoder encodeObject:_total_posting forKey:kTotalPosting];
    
    [aCoder encodeObject:_total_trophies forKey:kTotalTrophies];
    
    [aCoder encodeObject:_user_id forKey:kUserIdFollower];
    
    [aCoder encodeObject:_username forKey:kUserNameFollower];
    
}

- (id)copyWithZone:(NSZone *)zone
{
    FollowersDetails *copy = [[FollowersDetails alloc] init];
    
    if (copy)
    {
        copy.email = [self.email copyWithZone:zone];
        copy.follow_state = [self.follow_state copyWithZone:zone];
        copy.nickname = [self.nickname copyWithZone:zone];
        copy.profile_picture = [self.profile_picture copyWithZone:zone];
        copy.total_battle_won = [self.total_battle_won copyWithZone:zone];
        copy.total_followers = [self.total_followers copyWithZone:zone];
        copy.total_posting = [self.total_posting copyWithZone:zone];
        copy.total_trophies = [self.total_trophies copyWithZone:zone];
        copy.user_id = [self.user_id copyWithZone:zone];
        copy.username = [self.username copyWithZone:zone];
    }
    
    return copy;
}

@end
