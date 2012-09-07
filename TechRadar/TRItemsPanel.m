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

@synthesize delegate = _delegate;
@synthesize layout = _layout;
@synthesize rightEdgeRadius = _rightEdgeRadius;
@synthesize rightEdgeCenter = _rightEdgeCenter;
@synthesize rightEdge = _rightEdge;
@synthesize leftEdge = _leftEdge;


- (NSArray *)items
{
    return [_items copy];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _items = [[NSMutableArray alloc] initWithCapacity:5];
        self.clipsToBounds = NO;

        self.backgroundColor = [UIColor clearColor];
        
        self.layout = [[TRItemsPanelLayout alloc] init];
        self.layout.itemsPanel = self;
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tapGR];
        [tapGR release];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame leftEdge:(UIBezierPath *)theLeftEdge rightEdge:(UIBezierPath *)theRightEdge theCenterXOffset:(float)theCenterXOffset {
    self = [super initWithFrame:frame];
    if (self) {
        self.leftEdge = theLeftEdge;
        self.rightEdge = theRightEdge;
        _items = [[NSMutableArray alloc] initWithCapacity:5];
        self.clipsToBounds = NO;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];

        self.backgroundColor = [UIColor clearColor];

        self.layout = [[TRItemsPanelLayout alloc] init];
        self.layout.itemsPanel = self;
        self.layout.centerX = theCenterXOffset;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tapGR];
        [tapGR release];
    }
    return self;

}



- (void)tapped:(UIGestureRecognizer*)gestureRecognizer
{
    if (self.delegate) {
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            [self.delegate TRItemsPanelTapped:self];
        }
    }
}

- (void)dealloc
{
    [_items release];

    [_rightEdge release];
    [super dealloc];
}

- (void)addItem:(TRItem *)item
{
    [_items addObject:item];
    [self.layout reset];
    
    [self addSubview:item];
    
    [self setNeedsLayout];
}

- (void)clearItems
{
    for (id item in _items ) {
        [item removeFromSuperview];
    }
    [_items removeAllObjects];
    [self relayout];
}

- (void)relayout
{
    [self.layout layoutItems];
}

- (void)layoutSubviews
{
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.frame = self.bounds;
//    maskLayer.path = self.rightEdge.CGPath;
//    
//    self.layer.mask = maskLayer;
    
    [self.layout layoutItems];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(myContext, [[UIColor redColor] CGColor]);
    CGContextAddPath(myContext, [self.leftEdge CGPath]);
    CGContextStrokePath(myContext);

    CGContextSetStrokeColorWithColor(myContext, [[UIColor blueColor] CGColor]);
    CGContextAddPath(myContext, [self.rightEdge CGPath]);
    CGContextStrokePath(myContext);
    
//    CGContextRelease(myContext);
}


@end
