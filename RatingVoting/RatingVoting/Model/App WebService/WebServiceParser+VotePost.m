//
//  WebServiceParser+VotePost.m
//  RatingVoting
//
//  Created by c32 on 08/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "WebServiceParser+VotePost.h"

@implementation WebServiceParser (VotePost)

- (void)VotePostRequest:(DirectionType)direction
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
        switch (direction)
        {
                /******************* Route Managment ********************/
            case DirectionUP:
            case DirectionDOWN:
                URLString=URLVotePost;
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
            
            switch (direction)
            {
                /******************* data Managment ********************/
                case DirectionDOWN:
                {
                    if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] isEqualToString:Success])
                    {
                        
                    }
                    else if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] isEqualToString:Failure])
                    {
                        NSDictionary *errorDict = [[NSDictionary alloc]initWithObjectsAndKeys:[(NSDictionary *)Responceobjects valueForKey:@"error"], @"msg", nil];
                        error = [NSError errorWithDomain:@"Internal Error" code:2 userInfo:errorDict];
                    }
                }
                    break;
                case DirectionUP:
                {
                    if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] isEqualToString:Success])
                    {
                        
                    }
                    else if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] isEqualToString:Failure])
                    {
                        NSDictionary *errorDict = [[NSDictionary alloc]initWithObjectsAndKeys:[(NSDictionary *)Responceobjects valueForKey:@"error"], @"msg", nil];
                        error = [NSError errorWithDomain:@"Internal Error" code:2 userInfo:errorDict];
                    }
                }
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