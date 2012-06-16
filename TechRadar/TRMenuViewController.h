//
//  TRMenuViewController.h
//  TechRadar
//
//  Created by Cyril Wei on 6/16/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TRMenuMovePercentBlock)(id, CGFloat);

@interface TRMenuViewController : UIViewController <UIGestureRecognizerDelegate>  {
    CGFloat firstX;
    CGFloat firstY;
}

@property (nonatomic, copy) TRMenuMovePercentBlock moveStart;
@property (nonatomic, copy) TRMenuMovePercentBlock moveToPercent;
@property (nonatomic, copy) TRMenuMovePercentBlock moveCancelled;
@property (nonatomic, copy) TRMenuMovePercentBlock moveDone;

- (void)reset;

@end
