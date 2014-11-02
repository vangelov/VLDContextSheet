//
//  VLDContextSheetItem.h
//
//  Created by Vladimir Angelov on 2/10/14.
//  Copyright (c) 2014 Vladimir Angelov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLDContextSheetItem : NSObject

- (id) initWithTitle: (NSString *) title
               image: (UIImage *) image
    highlightedImage: (UIImage *) highlightedImage;

@property (strong, readonly) NSString *title;
@property (strong, readonly) UIImage *image;
@property (strong, readonly) UIImage *highlightedImage;

@property (assign, readwrite, getter = isEnabled) BOOL enabled;

@end
