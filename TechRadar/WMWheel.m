//
//  WMWheel.m
//  WheelMenu
//
//  Created by Cyril Wei on 8/26/12.
//  Copyright (c) 2012 Cyril Wei. All rights reserved.
//

#import "WMWheel.h"

@implementation WMWheel

@synthesize center = _center;

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame center:(CGPoint)centerPoint radius:(CGFloat)aRadius
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.center = centerPoint;
        self->radius = aRadius;
        
        _minAngle = CGFLOAT_MAX;
        _maxAngle = CGFLOAT_MIN;
        
        _isFirstTimeLayout = YES;
        _selectedIndex = -1;
    }
    return self;
}

- (void)layoutSubviews
{
    if (_isFirstTimeLayout) {
        [self initItems];
        
        [self initBackground];
        [self initIndicator];
        [self initOverlay];
        
        [self initGesture];
        
        _isFirstTimeLayout = NO;
    }
}

- (void)initItems
{
    if (self.dataSource) {
        int count = [self.dataSource itemsCount];
        items = [[NSMutableArray alloc] initWithCapacity:count];
        for (int i = 0; i < count; i ++) {
            WMWheelItem *item =[self.dataSource itemAtIndex:i];
            if (item.angle < _minAngle) {
                _minAngle = item.angle;
            }
            if (item.angle > _maxAngle) {
                _maxAngle = item.angle;
            }
            [items addObject:item];
        }
        
        _minAngle *= 1.2f;
        _maxAngle *= 1.2f;
    }
}

- (void)initBackground
{
    UIImage *image = [UIImage imageNamed:@"wheel_background.png"];
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:image];
    [self addSubview:bgImage];
    [self sendSubviewToBack:bgImage];
    [bgImage release];
}

- (void)initIndicator
{
    UIImage *image;
    if ([_dataSource respondsToSelector:@selector(indicatorImage)]) {
        image = [_dataSource performSelector:@selector(indicatorImage)];
    } else {
        image = [UIImage imageNamed:@"wheel_indicator.png"];
    }
    indicator = [[UIImageView alloc] initWithImage:image];
    indicator.contentMode = UIViewContentModeRight;
    
    CGSize indicatorSize = indicator.frame.size;
    CGRect indicatorFrame = CGRectMake(0,
                                       0,
                                       radius * 2,
                                       indicatorSize.height);
    indicator.frame = indicatorFrame;
    indicator.center = self.center;
    
    [self addSubview:indicator];

    _selectedIndex = 0;
//    indicatorAngle = radians(((WMWheelItem *)[items objectAtIndex:0]).angle);
    [self transformIndicatorToIndex:_selectedIndex animated:YES];
}

- (void)initOverlay
{
    UIImage *image = [UIImage imageNamed:@"wheel_front_control_panel.png"];
    UIImageView *overlayImage = [[UIImageView alloc] initWithImage:image];
    [self addSubview:overlayImage];
    [self bringSubviewToFront:overlayImage];
    [overlayImage release];
}

- (void)initGesture
{
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGR.minimumNumberOfTouches = 1;
    panGR.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:panGR];
    [panGR release];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGR.numberOfTouchesRequired = 1;
    tapGR.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGR];
    [tapGR release];
}

- (void)dealloc
{
    [indicator release];
    
    [super dealloc];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint touchedPoint = [sender locationInView:self];

        CGFloat newX = touchedPoint.x;
        CGFloat newY = touchedPoint.y - self.center.y;
        
        CGFloat a = sqrt(pow(newX - radius, 2.0f) + pow(newY, 2.0f));
        CGFloat b = radius;
        CGFloat c = sqrt(pow(newX, 2.0f) + pow(newY, 2.0f));
        
        CGFloat angleDelta =  acos((c * c + b * b - a * a) / (2.0f * b * c));
        angleDelta = copysign(angleDelta, newY);
        
        __block CGFloat selectedAngle = _minAngle;
        
        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WMWheelItem *item = (WMWheelItem *)obj;
            if (fabs(selectedAngle - angleDelta) > fabs(angleDelta - radians(item.angle))) {
                selectedAngle = radians(item.angle);
                _selectedIndex = idx;
            }
        }];
        
        [self transformIndicatorToIndex:_selectedIndex animated:YES];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)sender
{
    CGPoint translate = [sender translationInView:self];
    static CGPoint startPoint;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        startedAngle = indicatorAngle;
        startPoint = [sender locationInView:self];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat scale = radius / distance(startPoint, self.center);
        
        CGFloat startedX = radius * cos(startedAngle);
        CGFloat startedY = radius * sin(startedAngle);
        
        CGFloat newX = startedX + translate.x * scale;
        CGFloat newY = startedY + translate.y * scale;
        
        CGFloat a = sqrt(pow(newX - radius, 2.0f) + pow(newY, 2.0f));
        CGFloat b = radius;
        CGFloat c = sqrt(pow(newX, 2.0f) + pow(newY, 2.0f));
        
        CGFloat angleDelta =  acos((c * c + b * b - a * a) / (2.0f * b * c));
        angleDelta = copysign(angleDelta, newY);
        
        indicatorAngle = angleDelta;
        [self transformIndicatorTo:indicatorAngle animated:NO];
    } else if (sender.state == UIGestureRecognizerStateCancelled) {
        [self transformIndicatorTo:startedAngle animated:YES];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        __block CGFloat selectedAngle = _minAngle;

        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WMWheelItem *item = (WMWheelItem *)obj;
            if (fabs(selectedAngle - indicatorAngle) > fabs(indicatorAngle - radians(item.angle))) {
                selectedAngle = radians(item.angle);
                _selectedIndex = idx;
            }
        }];
        
        [self transformIndicatorToIndex:_selectedIndex animated:YES];
    }
}

- (void)transformIndicatorToIndex:(NSInteger)index animated:(BOOL)animated
{
    indicatorAngle = radians(((WMWheelItem *)[items objectAtIndex:index]).angle);
    [self transformIndicatorTo:indicatorAngle animated:animated];

    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(wheel:didRotateToItemAtIndex:)]) {
            [self.delegate performSelector:@selector(wheel:didRotateToItemAtIndex:) withObject:self withObject:[NSNumber numberWithInt:_selectedIndex]];
        }
    }
}

- (void)transformIndicatorTo:(CGFloat)angle animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.25f animations:^{
            [self transformIndicatorTo:angle];
        }];
    } else {
        [self transformIndicatorTo:angle];
    }
}

- (void)transformIndicatorTo:(CGFloat)angle
{
    if (angle < radians(_minAngle)) {
        angle = radians(_minAngle);
    } else if (angle > radians(_maxAngle)) {
        angle = radians(_maxAngle);
    }
  
    indicator.transform = CGAffineTransformMakeRotation(angle);
}

@end
