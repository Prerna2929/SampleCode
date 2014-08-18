//
//  WebServiceParser+FavouritePost.m
//  RatingVoting
//
//  Created by c85 on 27/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "WebServiceParser+FavouritePost.h"
#import "PostDetail.h"

@implementation WebServiceParser (FavouritePost)

- (void)getFavouritePostRequest:(WSFavouritePostType)servicetype
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
        switch (servicetype)
        {
                /******************* Route Managment ********************/
            case WSGetFavouritePost:
            {
                URLString=URLGetFavouritePost;
            }
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
            
            switch (servicetype)
            {
                    /******************* data Managment ********************/
                    
                case WSGetFavouritePost:
                {
                    if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] isEqualToString:Success])
                    {
                        Responceobjects = [(NSDictionary *)Responceobjects valueForKey:@"data"];
                        NSMutableArray *favPostList = [[NSMutableArray alloc]init];
                        
                        for (NSDictionary *dict in Responceobjects) {
                            
                            PostDetail *achieveDetail = [[PostDetail alloc]initWithDictionary:dict];
                            [favPostList addObject:achieveDetail];
                        }
                        Responceobjects = favPostList;
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
