//
//  WebServiceParser+Chat.m
//  Bringaz
//
//  Created by Parth Patel on 03/06/14.
//  Copyright (c) 2014 AlexWard. All rights reserved.
//

#import "WebServiceParser+Chat.h"

@implementation WebServiceParser (Chat)

//- (void)ChatRequest:(WSChatRequestType)servicetype
//         parameters:(NSString*)parameters
//      customeobject:(id)object
//   withmsgReference :(MOMessage *)msglocalInstance
//            inQueue:(NSOperationQueue *)Queue
//              block:(ResponseBlock)block
//{
//    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
//        
//            /******************* Set Url for WebService ********************/
//            NSError *error = nil;
//            NSHTTPURLResponse *response = nil;
//            NSString *URLString;// = [[NSString alloc]init];
//            NSData   *jsonData;
//            switch (servicetype)
//            {
//                    /******************* Route Managment ********************/
//                case WSGetAllChats:
//                {
//                    URLString=URLGetAllChats;
//                    jsonData =[self dictionaryToJSONData:object];
//
//                }
//                    break;
//                case WSSendMsg:
//                {
//                    URLString=URLSendChat;
//                    jsonData =[self dictionaryToJSONData:object];
//                }
//                    break;
//                    
//                default:
//                    break;
//            }
//            
//            TRC_DBG(@"Data Request - >%@",URLString);
//            
//            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:DEFAULT_TIMEOUT];
//            NSString *PostParamters = parameters;
//            NSData *postData = [PostParamters dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
//            [request setURL:[NSURL URLWithString:URLString]];
//            [request setHTTPMethod:@"POST"];
//            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//            [request setHTTPBody:postData];
//            if (jsonData!=nil) {
//                [request setHTTPBody:jsonData];
//                [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//            }
//            else
//            {
//                [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//            }
//            
//            id   Responceobjects = nil;
//            //            ShowNetworkIndicator(YES);
//            NSData   *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//            NSLog(@"%@",responseString);
//            
//            
//            if (data.length>0)
//            {
//                Responceobjects = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//                
//                switch (servicetype)
//                {
//                        /******************* data Managment ********************/
//                    case WSGetAllChats:
//                    {
//                        if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] integerValue] == VALID)
//                        {
//                            Responceobjects = [(NSDictionary *)Responceobjects valueForKey:@"data"];
//                            Responceobjects=[Responceobjects valueForKey:@"Message"];
//                            if ([Responceobjects isKindOfClass:[NSArray class]])
//                            {
//                                
//                                NSMutableArray *array =[NSMutableArray array];
//                                [Responceobjects enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop)
//                                {
//                                     NSError*error=nil;
//                                    MOMessage *msg=[DBManager selectSingle:TABLE_MESSAGE withpredicate:[NSString stringWithFormat:@"uniqueId = '%@'",[obj valueForKey:@"uniqueId"]] fromObjectContext:[ChatManager chatDataSource]];
//                                    
//                                    if (msg==nil)
//                                    {
//                                        msg=[NSEntityDescription insertNewObjectForEntityForName:TABLE_MESSAGE inManagedObjectContext:[ChatManager chatDataSource]];
//                                        [msg setupObjWithServerDictionary:obj];
//                                        
//                                        if (![[ChatManager chatDataSource] save:&error])
//                                        {
//                                            [SVProgressHUD showErrorWithStatus:@"DEBBUG ERROR SAVE GET ALL MSG"];
//                                        }
//                                        
//                                        if ([msg.senderId isEqualToString:[ChatManager sharedDataInstance].receiverId])
//                                        {
//                                            [array addObject:msg];
//                                        }
//                                    }
//                                }];
//                                if (array.count>0)
//                                {
//                                    Responceobjects=array;
//                                }
//                                else
//                                {
//                                    Responceobjects=[NSArray array];
//                                }
//                            }
//                        }  else if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] integerValue] == INVALID)
//                        {
//                            NSDictionary *errorDict = [[NSDictionary alloc]initWithObjectsAndKeys:[(NSDictionary *)Responceobjects valueForKey:@"msg"], @"msg", nil];
//                            error = [NSError errorWithDomain:@"Internal Error" code:2 userInfo:errorDict];
//                        }
//                        else if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] integerValue] == NORESPONCE) {
//                            
//                            NSLog(@"No Responce for call id %d",servicetype);
//                        }
//                    }
//                        break;
//                    case WSSendMsg:
//                    {
//                        
//                        if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] integerValue] == VALID)
//                        {
//                            Responceobjects = [(NSDictionary *)Responceobjects valueForKey:@"Message"];
//                            if(isLike([Responceobjects valueForKey:@"uniqueId"], msglocalInstance.uniqueId))
//                            {
//                                NSError*error=nil;
//                                msglocalInstance.isDelivered=[NSNumber numberWithInt:1];
//                                NSDate *serverTime =[ChatManager getDateFromString:[Responceobjects valueForKey:@"dateTime"]];
//                                msglocalInstance.dateTime=serverTime;
//                                Responceobjects=msglocalInstance;
//                                if (![[ChatManager chatDataSource] save:&error])
//                                {
//                                    [SVProgressHUD showErrorWithStatus:@"DEBBUG ERROR SAVE UPDATE MSG TIMEWITH SERVER"];
//                                }
//                            }
//                            else
//                            {
//                                NSLog(@"isue with update datetime chat");
//                            }
//                        }
//                        else if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] integerValue] == INVALID)
//                        {
//                            NSDictionary *errorDict = [[NSDictionary alloc]initWithObjectsAndKeys:[(NSDictionary *)Responceobjects valueForKey:@"msg"], @"msg", nil];
//                            error = [NSError errorWithDomain:@"Internal Error" code:2 userInfo:errorDict];
//                        }
//                        else if ([[(NSDictionary *)Responceobjects valueForKey:@"status"] integerValue] == NORESPONCE) {
//                            
//                            NSLog(@"No Responce for call id %d",servicetype);
//                        }
//                    }
//                        break;
//                
//                    default:
//                        break;
//                }
//            }
//            else if(error != nil)
//            {
//                runOnMainQueueWithoutDeadlocking(^{
//                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//                });
//            }
//            else if(data.length == 0)
//            {
//                runOnMainQueueWithoutDeadlocking(^{
//                    [SVProgressHUD dismiss];
//                });
//            }
//            
//            
//            dispatch_async(dispatch_get_main_queue(), ^(){
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    if ( error )
//                    {
//                        //ShowNetworkIndicator(NO);
//                        block(error,Responceobjects,responseString);
//                    }
//                    else
//                    {
//                        //ShowNetworkIndicator(NO);
//                        block(error,Responceobjects,responseString);
//                    }
//                }];
//            });
//        
//    }];
//    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
//    //[self.operationQueue cancelAllOperations];
//    [Queue addOperation:operation];
//}
//
//
//
//
@end
