//
//  TimeLineCell.h
//  Fanner
//
//  Created by ZHANGMIA on 7/28/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Status;
@class TimeLineCell;
@class DTAttributedLabel;
@class CellToolbarView;

typedef void(^DidSelectPhotoBlock)(TimeLineCell *cell);

@interface TimeLineCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;

@property (weak, nonatomic) IBOutlet DTAttributedLabel *contentsLabel;


@property (strong, nonatomic) DidSelectPhotoBlock didSelectPhotoBlock;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLableHeight;

@property (weak, nonatomic) IBOutlet CellToolbarView *toolbar;

@property (weak, nonatomic) CellToolbarView *cellToolbar;

- (void)configureWithStatus:(Status *)status;

@end
