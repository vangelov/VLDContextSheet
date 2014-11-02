//
//  VLDContextSheet.m
//
//  Created by Vladimir Angelov on 2/7/14.
//  Copyright (c) 2014 Vladimir Angelov. All rights reserved.
//

#import "VLDContextSheetItemView.h"
#import "VLDContextSheet.h"

typedef struct {
    CGRect rect;
    CGFloat rotation;
} VLDZone;

static const NSInteger VLDMaxTouchDistanceAllowance = 40;
static const NSInteger VLDZonesCount = 10;

static inline VLDZone VLDZoneMake(CGRect rect, CGFloat rotation) {
    VLDZone zone;
    
    zone.rect = rect;
    zone.rotation = rotation;
    
    return zone;
}

static CGFloat VLDVectorDotProduct(CGPoint vector1, CGPoint vector2) {
    return vector1.x * vector2.x + vector1.y * vector2.y;
}

static CGFloat VLDVectorLength(CGPoint vector) {
    return sqrt(vector.x * vector.x + vector.y * vector.y);
}

static CGRect VLDOrientedScreenBounds() {
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) &&
        bounds.size.width < bounds.size.height) {
        
        bounds.size = CGSizeMake(bounds.size.height, bounds.size.width);
    }
    
    return bounds;
}

@interface VLDContextSheet ()

@property (strong, nonatomic) NSArray *itemViews;
@property (strong, nonatomic) UIView *centerView;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) VLDContextSheetItemView *selectedItemView;
@property (assign, nonatomic) BOOL openAnimationFinished;
@property (assign, nonatomic) CGPoint touchCenter;
@property (strong, nonatomic) UIGestureRecognizer *starterGestureRecognizer;

@end

@implementation VLDContextSheet {
    
    VLDZone zones[VLDZonesCount];
}

- (id) initWithFrame: (CGRect) frame {
    return [self initWithItems: nil];
}

- (id) initWithItems: (NSArray *) items {
    self = [super initWithFrame: VLDOrientedScreenBounds()];
    
    if(self) {
        _items = items;
        _radius = 100;
        _rangeAngle = M_PI / 1.6;
        
        [self createSubviews];
    }
    
    return self;
}

- (void) dealloc {
    [self.starterGestureRecognizer removeTarget: self action: @selector(gestureRecognizedStateObserver:)];
}

- (void) createSubviews {
    _backgroundView = [[UIView alloc] initWithFrame: CGRectZero];
    _backgroundView.backgroundColor = [UIColor colorWithWhite: 0 alpha: 0.6];
    [self addSubview: self.backgroundView];
    
    _itemViews = [[NSMutableArray alloc] init];
    
    for(VLDContextSheetItem *item in _items) {
        VLDContextSheetItemView *itemView = [[VLDContextSheetItemView alloc] init];
        itemView.item = item;
        
        [self addSubview: itemView];
        [(NSMutableArray *) _itemViews addObject: itemView];
    }
    
    VLDContextSheetItemView *sampleItemView = _itemViews[0];
    
    _centerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, sampleItemView.frame.size.width, sampleItemView.frame.size.width)];
    _centerView.layer.cornerRadius = 25;
    _centerView.layer.borderWidth = 2;
    _centerView.layer.borderColor = [UIColor grayColor].CGColor;
    [self addSubview: _centerView];

}

- (void) layoutSubviews {
    [super layoutSubviews];
        
    self.backgroundView.frame = self.bounds;
}

- (void) setCenterViewHighlighted: (BOOL) highlighted {
    _centerView.backgroundColor = highlighted ? [UIColor colorWithWhite: 0.5 alpha: 0.4] : nil;
}

- (void) createZones {
    CGRect screenRect = self.bounds;
    
    NSInteger rowHeight1 = 120;
    
    zones[0] = VLDZoneMake(CGRectMake(0, 0, 70, rowHeight1), 0.8);
    zones[1] = VLDZoneMake(CGRectMake(zones[0].rect.size.width, 0, 40, rowHeight1), 0.4);
    
    zones[2] = VLDZoneMake(CGRectMake(zones[1].rect.origin.x + zones[1].rect.size.width, 0, screenRect.size.width - 2 *(zones[0].rect.size.width + zones[1].rect.size.width), rowHeight1), 0);
    
    zones[3] = VLDZoneMake(CGRectMake(zones[2].rect.origin.x + zones[2].rect.size.width, 0, zones[1].rect.size.width, rowHeight1),  -zones[1].rotation);
    zones[4] = VLDZoneMake(CGRectMake(zones[3].rect.origin.x + zones[3].rect.size.width, 0, zones[0].rect.size.width, rowHeight1), -zones[0].rotation);
    
    NSInteger rowHeight2 = screenRect.size.height - zones[0].rect.size.height;
    
    zones[5] = VLDZoneMake(CGRectMake(0, zones[0].rect.size.height, zones[0].rect.size.width, rowHeight2), M_PI - zones[0].rotation);
    zones[6] = VLDZoneMake(CGRectMake(zones[5].rect.size.width, zones[5].rect.origin.y, zones[1].rect.size.width, rowHeight2), M_PI - zones[1].rotation);
    zones[7] = VLDZoneMake(CGRectMake(zones[6].rect.origin.x + zones[6].rect.size.width, zones[5].rect.origin.y, zones[2].rect.size.width, rowHeight2), M_PI - zones[2].rotation);
    zones[8] = VLDZoneMake(CGRectMake(zones[7].rect.origin.x + zones[7].rect.size.width, zones[5].rect.origin.y, zones[3].rect.size.width, rowHeight2), M_PI - zones[3].rotation);
    zones[9] = VLDZoneMake(CGRectMake(zones[8].rect.origin.x + zones[8].rect.size.width, zones[5].rect.origin.y, zones[4].rect.size.width, rowHeight2), M_PI - zones[4].rotation);
}

/* Only used for testing the touch zones */
- (void) drawZones {
    for(int i = 0; i < VLDZonesCount; i++) {
        UIView *zoneView = [[UIView alloc] initWithFrame: zones[i].rect];
        
        CGFloat hue = ( arc4random() % 256 / 256.0 );
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        
        zoneView.backgroundColor = color;
        [self addSubview: zoneView];
    }
}

- (void) updateItemView: (UIView *) itemView
          touchDistance: (CGFloat) touchDistance
               animated: (BOOL) animated  {
    
    if(!animated) {
        [self updateItemViewNotAnimated: itemView touchDistance: touchDistance];
    }
    else  {        
        [UIView animateWithDuration: 0.4
                              delay: 0
             usingSpringWithDamping: 0.45
              initialSpringVelocity: 7.5
                            options: UIViewAnimationOptionBeginFromCurrentState
                         animations: ^{
                             [self updateItemViewNotAnimated: itemView
                                               touchDistance: touchDistance];
                         }
                         completion: nil];
    }
}

- (void) updateItemViewNotAnimated: (UIView *) itemView touchDistance: (CGFloat) touchDistance  {
    NSInteger itemIndex = [self.itemViews indexOfObject: itemView];
    CGFloat angle = -0.65 + self.rotation + itemIndex * (self.rangeAngle / self.itemViews.count);
    
    CGFloat resistanceFactor = 1.0 / (touchDistance > 0 ? 6.0 : 3.0);
    
    itemView.center = CGPointMake(self.touchCenter.x + (self.radius + touchDistance * resistanceFactor) * sin(angle),
                                  self.touchCenter.y + (self.radius + touchDistance * resistanceFactor) * cos(angle));
    
    CGFloat scale = 1 + 0.2 * (fabs(touchDistance) / self.radius);
    
    itemView.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void) openItemsFromCenterView {
    self.openAnimationFinished = NO;
    
    for(int i = 0; i < self.itemViews.count; i++) {
        VLDContextSheetItemView *itemView = self.itemViews[i];
        itemView.transform = CGAffineTransformIdentity;
        itemView.center = self.touchCenter;
        [itemView setHighlighted: NO animated: NO];
        
        [UIView animateWithDuration: 0.5
                              delay: i * 0.01
             usingSpringWithDamping: 0.45
              initialSpringVelocity: 7.5
                            options: 0
                         animations: ^{
                             [self updateItemViewNotAnimated: itemView touchDistance: 0.0];
                             
                         }
                         completion: ^(BOOL finished) {
                             self.openAnimationFinished = YES;
                         }];
    }
}

- (void) closeItemsToCenterView {
    [UIView animateWithDuration: 0.1
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         self.alpha = 1.0;
                     }];
    
}

- (void) startWithGestureRecognizer: (UIGestureRecognizer *) gestureRecognizer inView: (UIView *) view {
    [view addSubview: self];
    
    self.frame = VLDOrientedScreenBounds();
    [self createZones];
    
    self.starterGestureRecognizer = gestureRecognizer;
    
    self.touchCenter = [self.starterGestureRecognizer locationInView: self];
    self.centerView.center = self.touchCenter;
    self.selectedItemView = nil;
    [self setCenterViewHighlighted: YES];
    self.rotation = [self rotationForCenter: self.centerView.center];
    
    [self openItemsFromCenterView];
    
    [self.starterGestureRecognizer addTarget: self action: @selector(gestureRecognizedStateObserver:)];
}

- (CGFloat) rotationForCenter: (CGPoint) center {
    for(NSInteger i = 0; i < 10; i++) {
        VLDZone zone = zones[i];
        
        if(CGRectContainsPoint(zone.rect, center)) {
            return zone.rotation;
        }
    }
    
    return 0;
}

- (void) gestureRecognizedStateObserver: (UIGestureRecognizer *) gestureRecognizer {
    if(self.openAnimationFinished && gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint touchPoint = [gestureRecognizer locationInView: self];
        
        [self updateItemViewsForTouchPoint: touchPoint];
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        if(gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
            self.selectedItemView = nil;
        }
        
        [self end];
    }
}

- (CGFloat) signedTouchDistanceForTouchVector: (CGPoint) touchVector itemView: (UIView *) itemView {
    CGFloat touchDistance = VLDVectorLength(touchVector);
    
    CGPoint oldCenter = itemView.center;
    CGAffineTransform oldTransform = itemView.transform;
    
    [self updateItemViewNotAnimated: itemView touchDistance: self.radius + 40];
    
    if(!CGRectContainsRect(self.bounds, itemView.frame)) {
        touchDistance = -touchDistance;
    }
    
    itemView.center = oldCenter;
    itemView.transform = oldTransform;
    
    return touchDistance;
}

- (void) updateItemViewsForTouchPoint: (CGPoint) touchPoint {
    CGPoint touchVector = {touchPoint.x - self.touchCenter.x, touchPoint.y - self.touchCenter.y};
    VLDContextSheetItemView *itemView = [self itemViewForTouchVector: touchVector];
    CGFloat touchDistance = [self signedTouchDistanceForTouchVector: touchVector itemView: itemView];
    
    if(fabs(touchDistance) <= VLDMaxTouchDistanceAllowance) {
        self.centerView.center = CGPointMake(self.touchCenter.x + touchVector.x, self.touchCenter.y + touchVector.y);
        [self setCenterViewHighlighted: YES];
    }
    else {
        [self setCenterViewHighlighted: NO];
        
        [UIView animateWithDuration: 0.4
                              delay: 0
             usingSpringWithDamping: 0.35
              initialSpringVelocity: 7.5
                            options: UIViewAnimationOptionBeginFromCurrentState
                         animations: ^{
                             self.centerView.center = self.touchCenter;
                             
                         }
                         completion: nil];
    }
    
    if(touchDistance > self.radius + VLDMaxTouchDistanceAllowance) {
        [itemView setHighlighted: NO animated: YES];
        
        [self updateItemView: itemView
               touchDistance: 0.0
                    animated: YES];
        
        self.selectedItemView = nil;
        
        return;
    }
    
    if(itemView != self.selectedItemView) {
        [self.selectedItemView setHighlighted: NO animated: YES];
        
        [self updateItemView: self.selectedItemView
               touchDistance: 0.0
                    animated: YES];
        
        [self updateItemView: itemView
               touchDistance: touchDistance
                    animated: YES];
        
        [self bringSubviewToFront: itemView];
    }
    else  {
        [self updateItemView: itemView
               touchDistance: touchDistance
                    animated: NO];
    }
    
    if(fabs(touchDistance) > VLDMaxTouchDistanceAllowance) {
        [itemView setHighlighted: YES animated: YES];
    }
    
    self.selectedItemView = itemView;
}

- (VLDContextSheetItemView *) itemViewForTouchVector: (CGPoint) touchVector  {
    CGFloat maxCosOfAngle = -2;
    VLDContextSheetItemView *resultItemView = nil;
    
    for(int i = 0; i < self.itemViews.count; i++) {
        VLDContextSheetItemView *itemView = self.itemViews[i];
        CGPoint itemViewVector = {
            itemView.center.x - self.touchCenter.x,
            itemView.center.y - self.touchCenter.y
        };
        
        CGFloat cosOfAngle = VLDVectorDotProduct(itemViewVector, touchVector) / VLDVectorLength(itemViewVector);
        
        if(cosOfAngle > maxCosOfAngle) {
            maxCosOfAngle = cosOfAngle;
            resultItemView = itemView;
        }
    }

    return resultItemView;
}

- (void) end {
    [self.starterGestureRecognizer removeTarget: self action: @selector(gestureRecognizedStateObserver:)];
    
    if(self.selectedItemView && self.selectedItemView.isHighlighted) {
        [self.delegate contextSheet: self didSelectItem: self.selectedItemView.item];
    }
    
    [self closeItemsToCenterView];
}

@end
