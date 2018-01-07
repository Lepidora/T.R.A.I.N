//
//  StationData.h
//  TrainApp
//
//  Created by Mia on 22/03/2017.
//  Copyright © 2017 Mia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StationData : NSObject

@property (nonatomic, strong) NSString *stationName;
@property (nonatomic, strong) NSString *code;
@property (nonatomic) double stationDistance;

@end
