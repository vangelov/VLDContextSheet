//
//  VLDExampleViewController.m
//  VLDContextSheetExample
//
//  Created by Vladimir Angelov on 11/2/14.
//  Copyright (c) 2014 Vladimir Angelov. All rights reserved.
//

#import "VLDExampleViewController.h"
#import "VLDContextSheetItem.h"


@implementation VLDExampleViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self createContextSheet];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    UIGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget: self
                                                                                    action: @selector(longPressed:)];
    [self.view addGestureRecognizer: gestureRecognizer];
}

- (void) createContextSheet {
    VLDContextSheetItem *item1 = [[VLDContextSheetItem alloc] initWithTitle: @"Gift"
                                                                image: [UIImage imageNamed: @"gift"]
                                                     highlightedImage: [UIImage imageNamed: @"gift_highlighted"]];

    
    VLDContextSheetItem *item2 = [[VLDContextSheetItem alloc] initWithTitle: @"Add to"
                                                                image: [UIImage imageNamed: @"add"]
                                                     highlightedImage: [UIImage imageNamed: @"add_highlighted"]];
    
    VLDContextSheetItem *item3 = [[VLDContextSheetItem alloc] initWithTitle: @"Share"
                                                                image: [UIImage imageNamed: @"share"]
                                                     highlightedImage: [UIImage imageNamed: @"share_highlighted"]];
    
    self.contextSheet = [[VLDContextSheet alloc] initWithItems: @[ item1, item2, item3 ]];
    self.contextSheet.delegate = self;
}

- (void) contextSheet: (VLDContextSheet *) contextSheet didSelectItem: (VLDContextSheetItem *) item {
    NSLog(@"Selected item: %@", item.title);
}

- (void) longPressed: (UIGestureRecognizer *) gestureRecognizer {
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {

        [self.contextSheet startWithGestureRecognizer: gestureRecognizer
                                               inView: self.view];
    }
}

- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation
                                 duration: (NSTimeInterval) duration {
    
    [super willRotateToInterfaceOrientation: toInterfaceOrientation duration: duration];

    [self.contextSheet end];
}

@end
