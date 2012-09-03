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
    
    CGSize indicatorSize = indicator.frame.size;
    CGRect indicatorFrame = CGRectMake(self.center.x,
                                       self.center.y - indicatorSize.height / 2.0f,
                                       indicatorSize.width,
                                       indicatorSize.height);
    indicator.frame = indicatorFrame;

    [self addSubview:indicator];

    _selectedIndex = 0;
    indicatorAngle = radians(((WMWheelItem *)[items objectAtIndex:0]).angle);
    [self transformIndicatorTo:indicatorAngle animated:YES];
}

- (void)initOverlay
{
    UIImage *image = [UIImage imageNamed:@"wheel_overlay.png"];
    UIImageView *overlayImage = [[UIImageView alloc] initWithImage:image];
    [self addSubview:overlayImage];
    [self bringSubviewToFront:overlayImage];
    [overlayImage release];
}

- (void)initGesture
{
    UISwipeGestureRecognizer *swipeUpGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeUpGR.numberOfTouchesRequired = 1;
    swipeUpGR.direction = UISwipeGestureRecognizerDirectionUp;
//    [self addGestureRecognizer:swipeUpGR];
    [swipeUpGR release];

    UISwipeGestureRecognizer *swipeDownGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeDownGR.numberOfTouchesRequired = 1;
    swipeDownGR.direction = UISwipeGestureRecognizerDirectionDown;
//    [self addGestureRecognizer:swipeDownGR];
    [swipeDownGR release];
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGR.minimumNumberOfTouches = 1;
    panGR.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:panGR];
    [panGR release];
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

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
            -- _selectedIndex;
            if (_selectedIndex < 0) {
                _selectedIndex = 0;
                [self transformIndicatorTo:_minAngle animated:YES];
            }
            
            [self transformIndicatorToIndex:_selectedIndex animated:YES];
        } else if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
            ++ _selectedIndex;
            if (_selectedIndex >= [items count]) {
                _selectedIndex = [items count] - 1;
                [self transformIndicatorTo:_maxAngle animated:YES];
            }
            
            [self transformIndicatorToIndex:_selectedIndex animated:YES];
        }
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
//        NSLog(@"startedX = %f, startedY = %f", startedX, startedY);
        
        CGFloat newX = startedX + translate.x * scale;
        CGFloat newY = startedY + translate.y * scale;
//        NSLog(@"newX = %f, newY = %f", newX, newY);
        
        CGFloat a = sqrt(pow(newX - radius, 2.0f) + pow(newY, 2.0f));
        CGFloat b = radius;
        CGFloat c = sqrt(pow(newX, 2.0f) + pow(newY, 2.0f));
        
        CGFloat angleDelta =  acos((c * c + b * b - a * a) / (2.0f * b * c));
        angleDelta = copysign(angleDelta, newY);

//        NSLog(@"a = %f, b = %f, c = %f, cos(A) = %f, A = %f", a, b, c, (c * c + b * b - a * a) / (2.0f * b * c), angleDelta);
        
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
    
    indicator.transform = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformMakeTranslation(radius / 2.0f, 0.0f), CGAffineTransformMakeRotation(angle)), CGAffineTransformMakeTranslation(-radius / 2.0f, 0.0f));
}

@end
