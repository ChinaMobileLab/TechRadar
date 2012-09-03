//
//  TRMainViewController.h
//  TechRadar
//
//  Created by Cyril Wei on 6/11/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRItemsViewController.h"
#import "WMWheel.h"

@interface TRMainViewController : UIViewController <WMWheelDataSource, WMWheelDelegate> {
    CADisplayLink *displayLink;

    NSMutableArray *items;
}

@property (nonatomic, retain) TRItemsViewController *contentViewController;

@end
