//
//  TRItemsPanel.m
//  TechRadar
//
//  Created by Cyril Wei on 6/5/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "TRItemsPanel.h"
#import "QuartzCore/QuartzCore.h"
#import "TRItem.h"
#import "TRItemsPanelLayout.h"

#define DEGREES_TO_RADIANS(degrees) ((M_PI * degrees)/ 180)

@implementation TRItemsPanel

- (NSArray *)items
{
    return [_items copy];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _items = [[NSMutableArray alloc] initWithCapacity:5];
        
        self.backgroundColor = [UIColor lightGrayColor];
        
        
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds 
//                                                       byRoundingCorners:UIRectCornerTopLeft
//                                                             cornerRadii:CGSizeMake(10.0, 10.0)];
        self.clipsToBounds = NO;

//        self.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
//        self.layer.shadowColor = [[UIColor grayColor] CGColor];
//        self.layer.shadowPath = maskPath.CGPath;
        
        self.layout = [[TRItemsPanelLayout alloc] init];
        self.layout.itemsPanel = self;
    }
    return self;
}

- (void)dealloc
{
    [_items release];
    
    [super dealloc];
}

- (void)addItem:(TRItem *)item
{
    [_items addObject:item];
    [self.layout reset];
    
    [self addSubview:item];
    
    [self setNeedsLayout];
}

- (void)relayout
{
    [self.layout reset];
    [self.layout layoutItems];
    
    NSMutableArray *pointArray = [[NSMutableArray alloc] initWithCapacity:self.items.count];
    for (int i = 0; i < self.items.count; i ++) {
        [pointArray addObject:[NSValue valueWithCGPoint:((UIView *)[_items objectAtIndex:i]).center]];
    }

    [self.layout reset];
    [UIView animateWithDuration:0.5f animations:^{
        for (int i = 0; i < self.items.count; i ++) {
            ((UIView *)[_items objectAtIndex:i]).center = ((NSValue *)[pointArray objectAtIndex:i]).CGPointValue;
        }
    }];
}

- (void)layoutSubviews
{
//    CGFloat radius = sqrt(pow(self.frame.origin.x + self.frame.size.width, 2) + pow(374.0f, 2));
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = self.shapePath.CGPath;
    
    self.layer.mask = maskLayer;
    
    [self.layout layoutItems];
}

- (UIBezierPath *)shapePath
{
    CGFloat radius = self.frame.origin.x + self.frame.size.width;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0.0f - self.frame.origin.x, 374.0f)
                                                            radius:radius
                                                        startAngle:DEGREES_TO_RADIANS(-75.0f)
                                                          endAngle:DEGREES_TO_RADIANS(75.0f)
                                                         clockwise:YES];
    
    [maskPath addLineToPoint:CGPointMake(0.0f - self.frame.origin.x, 374.0f)];

    return maskPath;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
