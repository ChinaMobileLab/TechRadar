//
//  TRItemsPanelLayout.m
//  TechRadar
//
//  Created by Cyril Wei on 7/9/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "TRItemsPanelLayout.h"
#import "TRItem.h"
#import "TRItemsPanel.h"

@interface TRItemsPanelLayout ()

@property (nonatomic, readonly) NSArray *items;
@property (nonatomic, readonly) CGSize contentSize;

@end

@implementation TRItemsPanelLayout

@synthesize itemsPanel = _itemsPanel;

- (BOOL)isLayouted
{
    return _isLayouted;
}

- (void)reset
{
    _isLayouted = NO;

    if (self.itemsPanel == nil || self.items.count <= 0) {
        return;
    }
    
    for (TRItem *item in self.items) {
        BOOL set = NO;
        do {
            CGFloat x = self.contentSize.width / 2.0f;
            CGFloat y = self.contentSize.height / 2.0f;
            //            CGFloat x = arc4random() % (int)self.contentSize.width;
            //            CGFloat y = arc4random() % (int)self.contentSize.height;
            CGFloat inset = item.radius + 20.0f;
            
            if (x >= inset && x <= self.contentSize.width - inset &&
                y >= inset && y <= self.contentSize.height - inset) {
                item.center = CGPointMake(x, y);
                set = YES;
            }
        } while (!set);
    }
}

- (void)layoutItems
{
    if (self.itemsPanel == nil || self.items.count <= 0 || _isLayouted) {
        return;
    }
    
    CGFloat step = MIN(self.contentSize.width, self.contentSize.height) / 5.0f;

    do {
        [self moveWithStep:step];
        step /= 1.5f;
    } while (step > 1.0f);
    [self moveWithStep:1.0f];
    
    _isLayouted = YES;
}

- (CGSize)contentSize
{
    return self.itemsPanel.frame.size;
}

- (BOOL)shouldItem:(TRItem *)item moveToPoint:(CGPoint)newCenter currentNearestDistance:(CGFloat)currentNearestDistance
{
    BOOL moved = NO;
    CGPoint oldCenter = item.center;
    CGFloat inset = item.radius + 10.0f;
        
    if (newCenter.x >= inset + 20.0f && newCenter.x <= self.contentSize.width - inset - 20.0f &&
        newCenter.y >= inset && newCenter.y <= self.contentSize.height - inset) {
        item.center = newCenter;
        if ([self nearestDistance:item] > currentNearestDistance) {
            moved = YES;
        }
    }
    
    item.center = oldCenter;
    return moved;
}

- (void)moveWithStep:(CGFloat)step
{
    NSArray *moveArray = [NSArray arrayWithObjects:
                          [NSValue valueWithCGPoint:CGPointMake(0.0f, -step)]
                          , [NSValue valueWithCGPoint:CGPointMake(step, -step)]
                          , [NSValue valueWithCGPoint:CGPointMake(step, 0.0f)]
                          , [NSValue valueWithCGPoint:CGPointMake(step, step)]
                          , [NSValue valueWithCGPoint:CGPointMake(0.0f, step)]
                          , [NSValue valueWithCGPoint:CGPointMake(-step, step)]
                          , [NSValue valueWithCGPoint:CGPointMake(-step, 0.0f)]
                          , [NSValue valueWithCGPoint:CGPointMake(-step, -step)]
                          , nil];
    __block BOOL moved = NO;
    do {
        moved = NO;
        for (TRItem *item in self.items) {
            __block CGFloat currentNearestDistance = [self nearestDistance:item];
            
            __block CGPoint oldCenter = item.center;

            [moveArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                CGPoint delta = ((NSValue *)obj).CGPointValue;
                CGPoint newCenter = CGPointMake(oldCenter.x + delta.x, oldCenter.y + delta.y);
                if ([self shouldItem:item moveToPoint:newCenter currentNearestDistance:currentNearestDistance]) {
                    item.center = newCenter;
                    moved = YES;
                    *stop = YES;
                }
            }];
        }
    } while (moved);
}

- (NSArray *)items
{
    return self.itemsPanel.items;
}

- (CGFloat)nearestDistance:(TRItem *)theItem
{
    CGFloat nearestDistance = MAXFLOAT;
    
    for (TRItem *item in self.items) {
        if (![theItem isEqual:item]) {
            CGFloat distance = [self distanceBetween:theItem.center and:item.center];
            if (distance < nearestDistance) {
                nearestDistance = distance;
            }
        }
    }
    
    return nearestDistance;
}

- (CGFloat)distanceBetween:(CGPoint)anPoint and:(CGPoint)theOtherPoint
{
    return powf(anPoint.x - theOtherPoint.x, 2) + powf(anPoint.y - theOtherPoint.y, 2);
}

@end
