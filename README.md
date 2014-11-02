## VLDContextSheet

A clone of the Pinterest context menu.

## Example Usage
```objective-c
 VLDContextSheetItem *item1 = [[VLDContextSheetItem alloc] initWithTitle: @"Gift"
                                                                image: [UIImage imageNamed: @"gift"]
                                                     highlightedImage: [UIImage imageNamed: @"gift_highlighted"]];

VLDContextSheetItem *item2 = ...
    
VLDContextSheetItem *item3 = ...
    
self.contextSheet = [[VLDContextSheet alloc] initWithItems: @[ item1, item2, item3 ]];
self.contextSheet.delegate = self;
```

### Show

```objective-c
- (void) longPressed: (UIGestureRecognizer *) gestureRecognizer {
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {

        [self.contextSheet startWithGestureRecognizer: gestureRecognizer
                                               inView: self.view];
    }
}
```

### Hide

```objective-c
[self.contextSheet end];
```

For more info check the Example project.

       
