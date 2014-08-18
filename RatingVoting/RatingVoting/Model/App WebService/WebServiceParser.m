//
//  WebServiceParser
//
//  Created by Parth on 8/20/12.
//  Copyright (c) NarolaInfotech. All rights reserved.
//

#import "WebServiceParser.h"

@implementation WebServiceParser

#pragma mark - Properties

@synthesize WSoperationQueue = WSoperationQueue;

#pragma mark - Init NSObject

- (id)init;
{
    if ( ( self = [super init] ) )
    {
        // The maxConcurrentOperationCount should reflect the number of open
        // connections the server can handle. Right now, limit it to two for
        // the sake of this example.
        WSoperationQueue = [[NSOperationQueue alloc] init];
        WSoperationQueue.maxConcurrentOperationCount = 13;
        
        // Allocate a reachability object
        Reachability* reach = [Reachability reachabilityWithHostname:@ServerPath];
        
        // Set the blocks
        reach.reachableBlock = ^(Reachability*reach)
        {
            NSLog(@"%s REACHABLE!",ServerPath);
        };
        
        reach.unreachableBlock = ^(Reachability*reach)
        {
            NSLog(@"%s UNREACHABLE!",ServerPath);
        };
        
        // Start the notifier, which will cause the reachability object to retain itself!
        [reach startNotifier];
        
        [WSoperationQueue addObserver:self forKeyPath:@"operations" options:0 context:NULL];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        

    }
    return self;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                         change:(NSDictionary *)change context:(void *)context
{
    WebServiceParser *parser =[WebServiceParser sharedMediaServer];
    
    if (object == parser.WSoperationQueue && [keyPath isEqualToString:@"operations"]) {
        if ([parser.WSoperationQueue.operations count] == 0) {
            //queue has completed
            ShowNetworkIndicator(NO);
            NSLog(@"queue has completed");
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}

#pragma mark - API

+ (id)sharedMediaServer;
{
    static dispatch_once_t onceToken;
    static id sharedMediaServer = nil;
    
    dispatch_once( &onceToken, ^{
        sharedMediaServer = [[[self class] alloc] init];
        
    });
    
    return sharedMediaServer;
}

- (void)postRequestparameters:(NSData *)data customeobject:(id)object block:(ResponseBlock)block
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            /******************* Set Url for WebService ********************/
            NSError *error = nil;
            NSHTTPURLResponse *response = nil;
            NSString *URLString ;//= [[NSString alloc]init];
            NSData   *jsonData;
            URLString=@"";
            jsonData=data;
           
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:DEFAULT_TIMEOUT];
            NSString *PostParamters;
            TRC_NRM(@"PostParamters -- >%@",PostParamters);
            NSData *postData = [PostParamters dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            [request setURL:[NSURL URLWithString:URLString]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody:postData];
            if (jsonData!=nil) {
                [request setHTTPBody:jsonData];
                [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            }
            else
            {
                [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            }
            
            id   Responceobjects = nil;
            
            NSData   *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"responseString -- > %@",responseString);
            
            if (data.length>0)
            {
                TRC_DBG(@"%@",responseString);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if ( error )
                    {
                        block(error,Responceobjects,responseString, nil);
                    }
                    else
                    {
                        block(error,Responceobjects,responseString, nil);
                    }
                }];
            });
        });
        
    }];
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
}

-(NSData *) dictionaryWithPropertiesOfObject:(id)obj
{
    NSArray *aVoidArray =@[@"NSDate"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        if (![aVoidArray containsObject: key] )
        {
            if ([obj valueForKey:key]!=nil)
            {
                [dict setObject:[obj valueForKey:key] forKey:key];
            }
        }
    }
    TRC_DBG(@"Dict %@",dict);
    free(properties);
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithDictionary:dict] options:0 error:&jsonError];
    if (jsonError!=nil)
    {
        return nil;
    }
    return jsonData;
}

-(NSData *)dictionaryToJSONData:(NSDictionary *)dict
{
    TRC_DBG(@"Dict %@",dict);
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithDictionary:dict] options:0 error:&jsonError];
    if (jsonError!=nil)
    {
        return nil;
    }
    return jsonData;
}

-(NSData *)dictionaryWithmembersOfObject:(id)obj formembers:(NSArray *)members
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *memberkey in members)
    {
        if(memberkey.length>0)
        {
            if ([obj valueForKey:memberkey] != nil)
            {
            [dict setObject:[obj valueForKey:memberkey] forKey:memberkey];
            }
        }
    }
    TRC_DBG(@"Dict %@",dict);
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithDictionary:dict] options:0 error:&jsonError];
    if (jsonError!=nil)
    {
        return nil;
    }
    return jsonData;
}

@end
