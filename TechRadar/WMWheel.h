//
//  WMWheel.h
//  WheelMenu
//
//  Created by Cyril Wei on 8/26/12.
//  Copyright (c) 2012 Cyril Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMWheelItem.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}
static inline double distance (CGPoint pointA, CGPoint pointB) {return sqrt(pow(pointB.x - pointA.x, 2.0f) + pow(pointB.y - pointA.y, 2.0f));}

@class WMWheel;

@protocol WMWheelDataSource <NSObject>

@required
- (int)itemsCount;
- (WMWheelItem *)itemAtIndex:(int)index;

@optional
- (UIImage *)indicatorImage;
- (CGFloat)radius;
- (CGPoint)indicatorAxis;
@end

@protocol WMWheelDelegate <NSObject>

@optional
- (void)wheel:(WMWheel *)wheel didRotateToItemAtIndex:(NSNumber *)index;

@end

@interface WMWheel : UIView <UIGestureRecognizerDelegate> {
    UIImageView *indicator;
    CGFloat indicatorAngle;
    CGFloat startedAngle;
    CGFloat radius;
    
    NSMutableArray *items;
    
    BOOL _isFirstTimeLayout;
    
    CGFloat _minAngle;
    CGFloat _maxAngle;
    
    int _selectedIndex;
}

@property (nonatomic, assign) CGPoint center;

@property (nonatomic, assign) id<WMWheelDataSource> dataSource;
@property (nonatomic, assign) id<WMWheelDelegate> delegate;

- (id)initWithFrame:(CGRect)frame center:(CGPoint)centerPoint radius:(CGFloat)radius;

@end
