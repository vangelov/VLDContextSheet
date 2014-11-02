//
//  VLDContextSheet.h
//
//  Created by Vladimir Angelov on 2/7/14.
//  Copyright (c) 2014 Vladimir Angelov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VLDContextSheet;
@class VLDContextSheetItem;

@protocol VLDContextSheetDelegate <NSObject>

- (void) contextSheet: (VLDContextSheet *) contextSheet didSelectItem: (VLDContextSheetItem *) item;

@end

@interface VLDContextSheet : UIView

@property (assign, nonatomic) NSInteger radius;
@property (assign, nonatomic) CGFloat rotation;
@property (assign, nonatomic) CGFloat rangeAngle;
@property (strong, nonatomic) NSArray *items;
@property (assign, nonatomic) id<VLDContextSheetDelegate> delegate;

- (id) initWithItems: (NSArray *) items;

- (void) startWithGestureRecognizer: (UIGestureRecognizer *) gestureRecognizer
                             inView: (UIView *) view;
- (void) end;

@end
