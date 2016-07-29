//
//  TimeLineCell.m
//  Fanner
//
//  Created by ZHANGMIA on 7/28/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "TimeLineCell.h"
#import "Status.h"
#import "User+CoreDataProperties.h"
#import <UIImageView+WebCache.h>

@implementation TimeLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithStatus:(Status *)status
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSFormattingUnitStyleShort;
    formatter.timeStyle = NSFormattingUnitStyleShort;
    
    self.dateCreatedLabel.text = [formatter stringFromDate:status.created_at];
    
    self.nameLabel.text = status.user.name;
    
    self.contentLabel.text = status.text;
    
    NSURL *url = [NSURL URLWithString:status.user.iconURL];
    // SDWebImageRefreshCached 已经下载过一次的就不需要再下载了
    [self.iconImageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRefreshCached];
    
}

@end
