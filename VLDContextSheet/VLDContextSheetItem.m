//
//  VLDContextSheetItem.m
//
//  Created by Vladimir Angelov on 2/10/14.
//  Copyright (c) 2014 Vladimir Angelov. All rights reserved.
//

#import "VLDContextSheetItem.h"

@implementation VLDContextSheetItem

- (id) initWithTitle: (NSString *) title
               image: (UIImage *) image
    highlightedImage: (UIImage *) highlightedImage {
    
    self = [super init];
    
    if(self) {
        _title = title;
        _image = image;
        _highlightedImage = highlightedImage;
        _enabled = YES;
    }
    
    return self;
}

@end
