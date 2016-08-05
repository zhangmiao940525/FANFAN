//
//  CellToolbarView.m
//  Fanner
//
//  Created by ZHANGMIA on 8/2/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "CellToolbarView.h"

@implementation CellToolbarView

- (IBAction)reply:(id)sender forEvent:(UIEvent *)event {
    
}
/** 收藏 */
- (IBAction)star:(id)sender forEvent:(UIEvent *)event {
    
    [_delegate starWithCellToolbar:self sender:sender forEvent:event];
    //
    
    
}

- (IBAction)repost:(id)sender forEvent:(UIEvent *)event {
}

- (void)setupStarButtonWithBOOL:(Boolean)favorited
{
    if (favorited) {
        [_starBtn setTitle:@"已收藏" forState:UIControlStateNormal];
    } else {
        [_starBtn setTitle:@"收藏" forState:UIControlStateNormal];
    }
}


@end
