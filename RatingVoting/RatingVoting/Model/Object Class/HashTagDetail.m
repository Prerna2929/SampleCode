//
//  HashTagDetail.m
//  RatingVoting
//
//  Created by c32 on 03/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "HashTagDetail.h"

NSString *const kHashtagId = @"hashtagId";
NSString *const kHashtag = @"hashtag";

@implementation HashTagDetail

@synthesize hashtag = _hashtag;
@synthesize hashtagId = _hashtagId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.hashtagId = [self objectOrNilForKey:kHashtagId fromDictionary:dict];
        self.hashtag = [self objectOrNilForKey:kHashtag fromDictionary:dict] == nil ? @"" : [NSString stringWithFormat:@"#%@",[dict objectForKey:@"hashtag"]];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.hashtagId forKey:kHashtagId];
    [mutableDict setValue:self.hashtag forKey:kHashtag];
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
    
    self.hashtagId = [aDecoder decodeObjectForKey:kHashtagId];
    self.hashtag = [aDecoder decodeObjectForKey:kHashtag];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_hashtagId forKey:kHashtagId];
    [aCoder encodeObject:_hashtag forKey:kHashtag];
}

- (id)copyWithZone:(NSZone *)zone
{
    HashTagDetail *copy = [[HashTagDetail alloc] init];
    
    if (copy)
    {
        copy.hashtagId = [self.hashtagId copyWithZone:zone];
        copy.hashtag = [self.hashtag copyWithZone:zone];
    }
    
    return copy;
}


@end