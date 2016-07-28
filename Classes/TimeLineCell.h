//
//  TimeLineCell.h
//  Fanner
//
//  Created by ZHANGMIA on 7/28/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
