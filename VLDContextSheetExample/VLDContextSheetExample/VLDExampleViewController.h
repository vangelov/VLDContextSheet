//
//  VLDExampleViewController.h
//  VLDContextSheetExample
//
//  Created by Vladimir Angelov on 11/2/14.
//  Copyright (c) 2014 Vladimir Angelov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLDContextSheet.h"

@interface VLDExampleViewController : UIViewController <VLDContextSheetDelegate>

@property (strong, nonatomic) VLDContextSheet *contextSheet;

@end
