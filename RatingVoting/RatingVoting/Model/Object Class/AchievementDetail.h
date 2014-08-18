//
//  AchievementDetail.h
//
//  Created by c46  on 27/06/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AchievementDetail : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *achievementName;
@property (nonatomic, strong) NSString *achievedOn;
@property (nonatomic, strong) NSString *achievementId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
