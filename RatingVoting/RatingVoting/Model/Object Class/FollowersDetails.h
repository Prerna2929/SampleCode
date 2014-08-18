//
//  FollowersDetails.h
//  RatingVoting
//
//  Created by c32 on 07/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowersDetails : NSObject

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *follow_state;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *profile_picture;
@property (nonatomic, strong) NSString *total_battle_won;
@property (nonatomic, strong) NSString *total_coins;
@property (nonatomic, strong) NSString *total_followers;
@property (nonatomic, strong) NSString *total_posting;
@property (nonatomic, strong) NSString *total_trophies;

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *username;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end