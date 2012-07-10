//
//  TRItemsPanel.h
//  TechRadar
//
//  Created by Cyril Wei on 6/5/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRItem;
@class TRItemsPanelLayout;

@interface TRItemsPanel : UIView {
    NSMutableArray *_items;
}

@property (nonatomic, readonly) NSArray *items;
@property (nonatomic, retain) TRItemsPanelLayout *layout;

- (void)addItem:(TRItem *)item;
- (void)relayout;

@end
