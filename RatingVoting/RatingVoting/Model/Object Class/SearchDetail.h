//
//  SearchDetail.h
//  RatingVoting
//
//  Created by c85 on 26/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchDetail : NSObject  <NSCoding, NSCopying>

@property (nonatomic, assign) NSInteger searchType;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSArray *searchList;
@property (nonatomic, assign) double nextStartRecord;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict withSearchType:(NSInteger)searchType;
- (NSDictionary *)dictionaryRepresentation;

@end
