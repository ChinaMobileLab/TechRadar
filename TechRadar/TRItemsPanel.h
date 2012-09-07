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
@class TRItemsPanel;

@protocol TRItemsPanelDelegate <NSObject>

- (void)TRItemsPanelTapped:(TRItemsPanel *)panel;

@end

@interface TRItemsPanel : UIView {
    NSMutableArray *_items;
}

@property (nonatomic, readonly) NSArray *items;
@property (nonatomic, retain) TRItemsPanelLayout *layout;

@property (nonatomic, assign) id<TRItemsPanelDelegate> delegate;

@property(nonatomic, assign) float rightEdgeRadius;

@property(nonatomic, assign) float rightEdgeCenter;

@property(nonatomic, retain) UIBezierPath *rightEdge;

@property(nonatomic, retain) UIBezierPath *leftEdge;

- (void)addItem:(TRItem *)item;

- (void)clearItems;

- (void)relayout;

- (id)initWithFrame:(CGRect)frame leftEdge:(UIBezierPath *)theLeftEdge rightEdge:(UIBezierPath *)theRightEdge theCenterXOffset:(float)theCenterXOffset;
@end
