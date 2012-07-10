//
//  TRItemsPanelLayout.h
//  TechRadar
//
//  Created by Cyril Wei on 7/9/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRItemsPanel;

@interface TRItemsPanelLayout : NSObject {
    BOOL _isLayouted;
}

@property (nonatomic, assign) TRItemsPanel *itemsPanel;
@property (nonatomic, readonly) BOOL isLayouted;

- (void)layoutItems;
- (void)reset;

@end
