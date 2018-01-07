//
//  TimesViewController.h
//  TrainApp
//
//  Created by Mia on 22/03/2017.
//  Copyright © 2017 Mia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StationData.h"

@interface TimesViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) StationData *station;

@end
