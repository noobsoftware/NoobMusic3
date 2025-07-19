//
//  RootContentLayout.m
//  noobtest
//
//  Created by siggi jokull on 4.12.2022.
//


#import "RootLayoutBox.h"

@implementation RootLayoutBox

- (double) getWidth: (bool) return_set_width {
    //////////////NSLog(@"return width: %f", [[self rootContainer] frame].size.width);
    return [[self rootContainer] frame].size.width;
}
- (double) getHeight: (bool) return_set_height forScroll: (bool) forScroll {
    //////////////NSLog(@"return height: %f", [[self rootContainer] frame].size.height);
    return [[self rootContainer] frame].size.height;
}

- (double) getHorizontalPosition {
    return 0;
}
- (double) getVerticalPosition {
    return 0;
}

@end

