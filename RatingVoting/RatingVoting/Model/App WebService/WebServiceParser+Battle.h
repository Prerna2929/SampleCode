//
//  WebServiceParser+Battle.h
//  RatingVoting
//
//  Created by c32 on 06/08/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "WebServiceParser.h"

@interface WebServiceParser (Battle)

typedef enum
{
    WSCreateBattle,
    WSInviteForBattle,
    WSAcceptRejectbattle,
    WSGetBattlebyUser
} BattleServiceType;

- (void)BattleService:(BattleServiceType)battle
            parameters:(NSString*)parameters
         customeobject:(id)object
                 block:(ResponseBlock)block;
@end