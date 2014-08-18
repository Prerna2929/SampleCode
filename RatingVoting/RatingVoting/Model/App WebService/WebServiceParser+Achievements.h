//
//  WebServiceParser+Achievements.h
//  RatingVoting
//
//  Created by c85 on 27/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "WebServiceParser.h"

typedef enum
{
    WSGetAllAchivements
}WSAchivementsType;

@interface WebServiceParser (Achievements)

- (void)achivementRequest:(WSAchivementsType)servicetype
           parameters:(NSString*)parameters
        customeobject:(id)object
                block:(ResponseBlock)block;

@end
