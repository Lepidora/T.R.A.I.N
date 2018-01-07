//
//  JSONParser.h
//  TrainApp
//
//  Created by Mia on 22/03/2017.
//  Copyright © 2017 Mia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject

+ (NSMutableDictionary *) getJSONFromURL:(NSString *)urlString;

@end
