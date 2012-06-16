//
//  TRHandleViewController.h
//  TechRadar
//
//  Created by Cyril Wei on 6/16/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TRHandleMovePercentBlock)(id, CGFloat);

@interface TRHandleViewController : UIViewController <UIGestureRecognizerDelegate> {
    CGFloat firstX;
    CGFloat firstY;
}

@property (nonatomic, copy) TRHandleMovePercentBlock moveCancelled;
@property (nonatomic, copy) TRHandleMovePercentBlock moveDone;
@property (nonatomic, copy) TRHandleMovePercentBlock moveToPercent;

@end
