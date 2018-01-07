//
//  JSONParser.h
//  TrainApp
//
//  Created by Mia on 22/03/2017.
//  Copyright © 2017 Mia. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser

+ (NSMutableDictionary *) getJSONFromURL:(NSString *)urlString{
    
    if ([NSThread isMainThread]) {
        NSLog(@"You are running network code on the main thread, please reconsider this");
        NSLog(@"Requested URL was %@", urlString);
    }

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *jsonParsingError = nil;
    
    NSMutableDictionary *itemsList = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
    
    return itemsList;
}

@end
