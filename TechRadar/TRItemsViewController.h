//
//  TRItemsViewController.h
//  TechRadar
//
//  Created by Cyril Wei on 6/5/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRItemsPanel.h"
#import "TRItem.h"

@interface TRItemsViewController : UIViewController <TRItemsPanelDelegate> {
    NSMutableArray *panels;
}

- (void)relayout;

- (void)initTRItems: (int)panelNum;

@end
