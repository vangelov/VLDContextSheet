//
//  VLDContextSheetItemView.m,
//
//  Created by Vladimir Angelov on 2/9/14.
//  Copyright (c) 2014 Vladimir Angelov. All rights reserved.
//

#import "VLDContextSheetItemView.h"
#import "VLDContextSheetItem.h"

#import <CoreImage/CoreImage.h>


static const NSInteger VLDTextPadding = 5;

@interface VLDContextSheetItemView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *highlightedImageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSInteger labelWidth;

@end

@implementation VLDContextSheetItemView

@synthesize item = _item;

- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: CGRectMake(0, 0, 50, 83)];
    
    if(self) {
        [self createSubviews];
    }
    
    return self;
}

- (void) createSubviews {
    _imageView = [[UIImageView alloc] init];
    [self addSubview: _imageView];
    
    _highlightedImageView = [[UIImageView alloc] init];
    _highlightedImageView.alpha = 0.0;
    [self addSubview: _highlightedImageView];
    
    _label = [[UILabel alloc] init];
    _label.clipsToBounds = YES;
    _label.font = [UIFont systemFontOfSize: 10];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.layer.cornerRadius = 7;
    _label.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.4];
    _label.textColor = [UIColor whiteColor];
    _label.alpha = 0.0;
    [self addSubview: _label];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, (self.frame.size.height - self.frame.size.width) / 2, self.frame.size.width, self.frame.size.width);
    self.highlightedImageView.frame = self.imageView.frame;
    self.label.frame = CGRectMake((self.frame.size.width - self.labelWidth) / 2.0, 0, self.labelWidth, 14);
}

- (void) setItem:(VLDContextSheetItem *)item {
    _item = item;
    
    [self updateImages];
    [self updateLabelText];
}

- (void) updateImages {
    self.imageView.image = self.item.image;
    self.highlightedImageView.image = self.item.highlightedImage;
    
    self.imageView.alpha = self.item.isEnabled ? 1.0 : 0.3;
}

- (void) updateLabelText {
    self.label.text = self.item.title;
    self.labelWidth = 2 * VLDTextPadding + ceil([self.label.text sizeWithAttributes: @{ NSFontAttributeName: self.label.font }].width);
    [self setNeedsDisplay];
}

- (void) setHighlighted: (BOOL) highlighted animated: (BOOL) animated {
    if (!self.item.isEnabled) {
        return;
    }

    _isHighlighted = highlighted;
    
    [UIView animateWithDuration: animated ? 0.3 : 0.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.highlightedImageView.alpha = (highlighted ? 1.0 : 0.0);
                         self.imageView.alpha = 1 - self.highlightedImageView.alpha;
                         self.label.alpha = self.highlightedImageView.alpha;
                         
                     }
                     completion: nil];
    
    
    
}

@end
