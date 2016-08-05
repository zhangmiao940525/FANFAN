//
//  CellToolbarView.h
//  Fanner
//
//  Created by ZHANGMIA on 8/2/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CellToolbarView;

@protocol CellToolbarDelegate

@required

- (void)starWithCellToolbar:(CellToolbarView *)toolbar sender:(id)sender forEvent:(UIEvent *)event;

@end


@interface CellToolbarView : UIView

@property (nonatomic,weak)id<CellToolbarDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *starBtn;

- (void)setupStarButtonWithBOOL:(Boolean)favorited;

@end


