# VLDContextSheet

A clone of the Pinterest iOS app context menu.

![BackgroundImage](https://github.com/vangelov/VLDContextSheet/blob/master/Screenshot.png)

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
### Delegate method

```objective-c
- (void) contextSheet: (VLDContextSheet *) contextSheet didSelectItem: (VLDContextSheetItem *) item {
    NSLog(@"Selected item: %@", item.title);
}
```

### Hide

```objective-c
[self.contextSheet end];
```

For more info check the Example project.

       
