//
//  WebServiceParser+Login.h
//  RatingVoting
//
//  Created by c85 on 20/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "WebServiceParser.h"

typedef enum
{
    WSLogin,
    WSCheckAvailability,
    WSRegistration
    
} WSLoginRequestType;

@interface WebServiceParser (Login)

- (void)loginRequest:(WSLoginRequestType)servicetype
         parameters:(NSString*)parameters
      customeobject:(id)object
              block:(ResponseBlock)block;
@end




