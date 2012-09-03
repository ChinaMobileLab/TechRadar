//
//  TRItemsPanelLayout.h
//  TechRadar
//
//  Created by Cyril Wei on 7/9/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRItemsPanel;

@interface TRItemsPanelLayout : NSObject

@property (nonatomic, assign) TRItemsPanel *itemsPanel;
@property (nonatomic, readonly, getter = isLayouted) BOOL isLayouted;

- (void)layoutItems;
- (void)reset;

@end
