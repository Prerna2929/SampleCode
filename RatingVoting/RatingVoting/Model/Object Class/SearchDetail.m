//
//  SearchDetail.m
//  RatingVoting
//
//  Created by c85 on 26/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "SearchDetail.h"
#import "PostDetail.h"

NSString *const kResponseStatus = @"status";
NSString *const kResponseData = @"data";
NSString *const kResponseNextStartRecord = @"next_start_record";

@interface SearchDetail ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SearchDetail

@synthesize status = _status;
@synthesize searchList = _searchList;
@synthesize nextStartRecord = _nextStartRecord;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict withSearchType:(NSInteger)searchType
{
    self = [super init];
    _searchList = [[NSMutableArray alloc]init];
    _searchType = searchType;
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        
        self.status = [self objectOrNilForKey:kResponseStatus fromDictionary:dict];
        
        NSObject *receivedData = [dict objectForKey:kResponseData];
        NSMutableArray *parsedData = [NSMutableArray array];
        
        if ([receivedData isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *item in (NSArray *)receivedData) {
                
                if ([item isKindOfClass:[NSDictionary class]]) {
                    
                    if (_searchType == 0) {
                        [parsedData addObject:[UserDetail modelObjectWithDictionary:item]];
                    }
                    else {
                        [parsedData addObject:[PostDetail modelObjectWithDictionary:item]];
                    }
                }
            }
        }
        else if ([receivedData isKindOfClass:[NSDictionary class]]) {
            
            if (_searchType == 0) {
                [parsedData addObject:[UserDetail modelObjectWithDictionary:(NSDictionary *)receivedData]];
            }
            else {
                [parsedData addObject:[PostDetail modelObjectWithDictionary:(NSDictionary *)receivedData]];
            }
        }
        
        self.searchList = [NSArray arrayWithArray:parsedData];
        self.nextStartRecord = [[self objectOrNilForKey:kResponseNextStartRecord fromDictionary:dict] doubleValue];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.status forKey:kResponseStatus];
    
    NSMutableArray *tempArrayForData = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.searchList) {
        
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForData addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        }
        else {
            // Generic object
            [tempArrayForData addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kResponseData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.nextStartRecord] forKey:kResponseNextStartRecord];
    
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
    
    self.status = [aDecoder decodeObjectForKey:kResponseStatus];
    self.searchList = [aDecoder decodeObjectForKey:kResponseData];
    self.nextStartRecord = [aDecoder decodeDoubleForKey:kResponseNextStartRecord];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_status forKey:kResponseStatus];
    [aCoder encodeObject:_searchList forKey:kResponseData];
    [aCoder encodeDouble:_nextStartRecord forKey:kResponseNextStartRecord];
}

- (id)copyWithZone:(NSZone *)zone
{
    SearchDetail *copy = [[SearchDetail alloc] init];
    
    if (copy) {
        
        copy.status = [self.status copyWithZone:zone];
        copy.searchList = [self.searchList copyWithZone:zone];
        copy.nextStartRecord = self.nextStartRecord;
    }
    
    return copy;
}

@end
