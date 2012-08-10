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
#import "TechRadarConstants.h"

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
            CGFloat radius = 40.0f + ((arc4random() % 40) - 20.0f);
            //            CGFloat x = arc4random() % (int)self.contentSize.width;
            //            CGFloat y = arc4random() % (int)self.contentSize.height;
            
            if ([self isPoint:CGPointMake(x, y) andRadius:radius insidePanel:self.itemsPanel]) {
                [item setRadius:radius];
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
    return [self isPoint:newCenter andRadius:item.radius insidePanel:self.itemsPanel]
        && [self nearestDistanceForItem:item newCenter:newCenter] > currentNearestDistance;
}

- (BOOL)isPoint:(CGPoint)point andRadius:(CGFloat)radius insidePanel:(TRItemsPanel *)panel
{
    CGRect rect = panel.bounds;
    
    UIBezierPath *path = panel.shapePath;
    CGRect sideButtonRect = CGRectMake(TechRadarSideButtonX - TechRadarSideButtonWidth / 2.0f
               , TechRadarSideButtonY - TechRadarSideButtonHeight / 2.0f
               , TechRadarSideButtonWidth, TechRadarSideButtonHeight);

    UIBezierPath *buttonPath = [UIBezierPath bezierPathWithRoundedRect:sideButtonRect cornerRadius:TechRadarSideButtonWidth / 2.0f];
    
    return (point.x >= rect.origin.x + radius && point.x <= rect.size.width - radius &&
            point.y >= rect.origin.y + radius && point.y <= rect.size.height - radius &&
            [self isPath:path containsPoint:point andRadius:radius] &&
            [self isPath:buttonPath notContainsPoint:point andRadius:radius]);
}

- (BOOL)isPath:(UIBezierPath *)path containsPoint:(CGPoint)point andRadius:(CGFloat)radius
{
    CGFloat r = sqrtf(powf(radius, 2.0f)) / 2.0f;
    
    NSArray *moveArray = [NSArray arrayWithObjects:
                          [NSValue valueWithCGPoint:CGPointMake(0.0f, -radius)]
                          , [NSValue valueWithCGPoint:CGPointMake(r, -r)]
                          , [NSValue valueWithCGPoint:CGPointMake(radius, 0.0f)]
                          , [NSValue valueWithCGPoint:CGPointMake(r, r)]
                          , [NSValue valueWithCGPoint:CGPointMake(0.0f, radius)]
                          , [NSValue valueWithCGPoint:CGPointMake(-r, r)]
                          , [NSValue valueWithCGPoint:CGPointMake(-radius, 0.0f)]
                          , [NSValue valueWithCGPoint:CGPointMake(-r, -r)]
                          , nil];
    
    __block BOOL isContains = YES;
    [moveArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGPoint delta = ((NSValue *)obj).CGPointValue;
        CGPoint newCenter = CGPointMake(point.x + delta.x, point.y + delta.y);
        
        if (![path containsPoint:newCenter]) {
            isContains = NO;
            *stop = YES;
        }
    }];

    return isContains;
}

- (BOOL)isPath:(UIBezierPath *)path notContainsPoint:(CGPoint)point andRadius:(CGFloat)radius
{
    CGFloat r = sqrtf(powf(radius, 2.0f)) / 2.0f;
    
    NSArray *moveArray = [NSArray arrayWithObjects:
                          [NSValue valueWithCGPoint:CGPointMake(0.0f, -radius)]
                          , [NSValue valueWithCGPoint:CGPointMake(r, -r)]
                          , [NSValue valueWithCGPoint:CGPointMake(radius, 0.0f)]
                          , [NSValue valueWithCGPoint:CGPointMake(r, r)]
                          , [NSValue valueWithCGPoint:CGPointMake(0.0f, radius)]
                          , [NSValue valueWithCGPoint:CGPointMake(-r, r)]
                          , [NSValue valueWithCGPoint:CGPointMake(-radius, 0.0f)]
                          , [NSValue valueWithCGPoint:CGPointMake(-r, -r)]
                          , nil];
    
    __block BOOL isContains = NO;
    [moveArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGPoint delta = ((NSValue *)obj).CGPointValue;
        CGPoint newPoint = CGPointMake(point.x + delta.x, point.y + delta.y);
        
        if ([path containsPoint:newPoint]) {
            isContains = YES;
            *stop = YES;
        }
    }];
    
    return !isContains;
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
            
            [moveArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                CGPoint delta = ((NSValue *)obj).CGPointValue;
                CGPoint newCenter = CGPointMake(item.center.x + delta.x, item.center.y + delta.y);
                
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
    return [self nearestDistanceForItem:theItem newCenter:theItem.center];
}

- (CGFloat)nearestDistanceForItem:(TRItem *)theItem newCenter:(CGPoint)newCenter
{
    CGFloat nearestDistance = MAXFLOAT;
    
    for (TRItem *item in self.items) {
        if (![theItem isEqual:item]) {
            CGFloat distance = [self distanceBetween:newCenter and:item.center];
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
