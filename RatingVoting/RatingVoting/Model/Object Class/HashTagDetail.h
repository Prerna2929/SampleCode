//
//  HashTagDetail.h
//  RatingVoting
//
//  Created by c32 on 03/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HashTagDetail : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *hashtagId;
@property (nonatomic, strong) NSString *hashtag;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end