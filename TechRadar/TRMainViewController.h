//
//  TRMainViewController.h
//  TechRadar
//
//  Created by Cyril Wei on 6/11/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRHandleViewController.h"
#import "TRCategoryViewController.h"
#import "TRItemsViewController.h"
#import "TRMenuViewController.h"

@interface TRMainViewController : UIViewController

@property (nonatomic, retain) TRCategoryViewController *coverViewController;
@property (nonatomic, retain) TRItemsViewController *contentViewController;
@property (nonatomic, retain) TRHandleViewController *handleViewController;
@property (nonatomic, retain) TRMenuViewController *menuViewController;

@end
