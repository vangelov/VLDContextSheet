//
//  VLDContextSheetItem.h
//
//  Created by Vladimir Angelov on 2/9/14.
//  Copyright (c) 2014 Vladimir Angelov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VLDContextSheetItem;

@interface VLDContextSheetItemView : UIView

@property (strong, nonatomic) VLDContextSheetItem *item;
@property (readonly) BOOL isHighlighted;

- (void) setHighlighted: (BOOL) highlighted animated: (BOOL) animated;

@end
