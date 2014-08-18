//
//  AchievementDetail.m
//
//  Created by c46  on 27/06/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "AchievementDetail.h"


NSString *const kAchievementDetailAchievementName = @"achievement_name";
NSString *const kAchievementDetailAchievedOn = @"achieved_on";
NSString *const kAchievementDetailAchievementId = @"achievement_id";


@interface AchievementDetail ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation AchievementDetail

@synthesize achievementName = _achievementName;
@synthesize achievedOn = _achievedOn;
@synthesize achievementId = _achievementId;


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
            self.achievementName = [self objectOrNilForKey:kAchievementDetailAchievementName fromDictionary:dict];
            self.achievedOn = [self objectOrNilForKey:kAchievementDetailAchievedOn fromDictionary:dict];
            self.achievementId = [self objectOrNilForKey:kAchievementDetailAchievementId fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.achievementName forKey:kAchievementDetailAchievementName];
    [mutableDict setValue:self.achievedOn forKey:kAchievementDetailAchievedOn];
    [mutableDict setValue:self.achievementId forKey:kAchievementDetailAchievementId];

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

    self.achievementName = [aDecoder decodeObjectForKey:kAchievementDetailAchievementName];
    self.achievedOn = [aDecoder decodeObjectForKey:kAchievementDetailAchievedOn];
    self.achievementId = [aDecoder decodeObjectForKey:kAchievementDetailAchievementId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_achievementName forKey:kAchievementDetailAchievementName];
    [aCoder encodeObject:_achievedOn forKey:kAchievementDetailAchievedOn];
    [aCoder encodeObject:_achievementId forKey:kAchievementDetailAchievementId];
}

- (id)copyWithZone:(NSZone *)zone
{
    AchievementDetail *copy = [[AchievementDetail alloc] init];
    
    if (copy) {

        copy.achievementName = [self.achievementName copyWithZone:zone];
        copy.achievedOn = [self.achievedOn copyWithZone:zone];
        copy.achievementId = [self.achievementId copyWithZone:zone];
    }
    
    return copy;
}


@end
