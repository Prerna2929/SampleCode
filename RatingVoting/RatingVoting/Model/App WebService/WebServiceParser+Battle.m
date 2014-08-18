//
//  WebServiceParser+Battle.m
//  RatingVoting
//
//  Created by c32 on 06/08/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "WebServiceParser+Battle.h"
#import "PostDetail.h"

@implementation WebServiceParser (Battle)

- (void)BattleService:(BattleServiceType)battle
           parameters:(NSString*)parameters
        customeobject:(id)object
                block:(ResponseBlock)block
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        /******************* Set Url for WebService ********************/
        NSError *error = nil;
        NSHTTPURLResponse *response = nil;
        NSString *URLString;
        NSData   *jsonData;
        NSString *nextStartRecord;
        switch (battle)
        {
                /******************* Route Managment ********************/
            case WSCreateBattle:
                URLString=URLCrateBattle;
                break;
            case WSInviteForBattle:
                URLString=URLInviteForBattle;
                break;
            case WSAcceptRejectbattle:
                URLString=URLAcceptRejectBattle;
                break;
            case WSGetBattlebyUser:
                URLString=URLGetBattleByUser;
                break;
            default:
                break;
        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:DEFAULT_TIMEOUT];
        NSString *PostParamters = parameters;
        NSData *postData = [PostParamters dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
        
        if (jsonData!=nil) {
            [request setHTTPBody:jsonData];
            [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }
        else {
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        }
        
        id   Responceobjects = nil;
        ShowNetworkIndicator(YES);
        
        NSData   *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        if (data.length>0)
        {
            Responceobjects = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            Responceobjects = [(NSDictionary *)Responceobjects valueForKey:@"response"];
            
            nextStartRecord = [(NSDictionary *)Responceobjects valueForKey:@"next_start_record"];
            
            switch (battle)
            {
                    /******************* data Managment ********************/
                case WSCreateBattle:
                {
                    if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] isEqualToString:Success])
                    {
                        responseString = Success;
                    }
                    else if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] isEqualToString:Failure])
                    {
                        NSDictionary *errorDict = [[NSDictionary alloc]initWithObjectsAndKeys:[(NSDictionary *)Responceobjects valueForKey:@"error"], @"msg", nil];
                        error = [NSError errorWithDomain:@"Internal Error" code:2 userInfo:errorDict];
                    }
                }
                    break;
                    
                case WSInviteForBattle:
                {
                    if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] isEqualToString:Success])
                    {
                        responseString = Success;
                    }
                    else if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] isEqualToString:Failure])
                    {
                        NSDictionary *errorDict = [[NSDictionary alloc]initWithObjectsAndKeys:[(NSDictionary *)Responceobjects valueForKey:@"error"], @"msg", nil];
                        error = [NSError errorWithDomain:@"Internal Error" code:2 userInfo:errorDict];
                    }
                }
                    break;
                case WSAcceptRejectbattle:
                {
                    if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] isEqualToString:Success])
                    {
                        responseString = Success;
                    }
                    else if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] isEqualToString:Failure])
                    {
                        NSDictionary *errorDict = [[NSDictionary alloc]initWithObjectsAndKeys:[(NSDictionary *)Responceobjects valueForKey:@"error"], @"msg", nil];
                        error = [NSError errorWithDomain:@"Internal Error" code:2 userInfo:errorDict];
                    }
                }
                    break;
                case WSGetBattlebyUser:
                {
                    if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] isEqualToString:Success])
                    {
                        id  to_Responceobjects = (NSMutableArray *)[Responceobjects valueForKey:@"data"];
                        NSMutableArray *myPostList = [[NSMutableArray alloc]init];
                        
                        for (id object in to_Responceobjects) {
                            for (NSDictionary *dict in object) {
                                PostDetail *postDetail = [[PostDetail alloc]initWithDictionary:dict];
                                [myPostList addObject:postDetail];
                            }
                        }
                        
//                        [CacheData setCacheToUserDefaults:myPostList ForKey:keyAllbattlePostDetail];
                        
                        NSArray* filteredBattleArray = NSArray.new;
                        NSPredicate *filter ;
                        
                        filter= [NSPredicate predicateWithFormat:@"SELF.to_userPost ==[c] %@", @"1"];
                        
                        filteredBattleArray = [myPostList filteredArrayUsingPredicate:filter];
                        
//                        NSArray *sortedArrayFinalArray;
                        
//                        sortedArrayFinalArray = [[NSArray arrayWithArray:filteredBattleArray] sortedArrayUsingComparator:^NSComparisonResult(PostDetail * a, PostDetail * b) {
//                            
//                            if ([[a battleID] integerValue] > [[b battleID] integerValue])
//                                return NSOrderedAscending;
//                            else if ([[a battleID] integerValue] < [[b battleID] integerValue])
//                                return NSOrderedDescending;
//                            else
//                                return NSOrderedSame;
//                        }];
                        
                        [CacheData setCacheToUserDefaults:[filteredBattleArray mutableCopy] ForKey:keyBattleToPostDetail];
                        
                        filteredBattleArray = NSArray.new;
                        filter= [NSPredicate predicateWithFormat:@"SELF.to_userPost ==[c] %@", @"0"];
                        filteredBattleArray = [myPostList filteredArrayUsingPredicate:filter];
                        
//                        sortedArrayFinalArray = NSArray.new;
                        
//                        sortedArrayFinalArray = [[NSArray arrayWithArray:filteredBattleArray] sortedArrayUsingComparator:^NSComparisonResult(PostDetail * a, PostDetail * b) {
//                            
//                            if ([[a battleID] integerValue] > [[b battleID] integerValue])
//                                return NSOrderedAscending;
//                            else if ([[a battleID] integerValue] < [[b battleID] integerValue])
//                                return NSOrderedDescending;
//                            else
//                                return NSOrderedSame;
//                        }];
                        
                        [CacheData setCacheToUserDefaults:[filteredBattleArray mutableCopy] ForKey:keyBattleFromPostDetail];
                        
                        myPostList = myPostList;
                    }
                    else if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] isEqualToString:Failure])
                    {
                        NSDictionary *errorDict = [[NSDictionary alloc]initWithObjectsAndKeys:[(NSDictionary *)Responceobjects valueForKey:@"error"], @"msg", nil];
                        error = [NSError errorWithDomain:@"Internal Error" code:2 userInfo:errorDict];
                    }
                }
                    break;
                default:
                    break;
            }
        }
        else if(error != nil)
        {
            runOnMainQueueWithoutDeadlocking(^{
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            });
        }
        else if(data.length == 0)
        {
            runOnMainQueueWithoutDeadlocking(^{
                [SVProgressHUD dismiss];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if ( error )
                {
                    //ShowNetworkIndicator(NO);
                    block(error,Responceobjects,responseString, nil);
                }
                else
                {
                    //ShowNetworkIndicator(NO);
                    block(error,Responceobjects,responseString, nextStartRecord);
                }
            }];
        });
    }];
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [self.WSoperationQueue addOperation:operation];
}
@end
