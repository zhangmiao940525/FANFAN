//
//  UserTableViewCell.m
//  Fanner
//
//  Created by ZHANGMIA on 7/26/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "UserTableViewCell.h"
#import "User.h"
#import <UIImageView+WebCache.h>

@implementation UserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithUser:(User *)user
{
    self.nameLabel.text = user.name;
    self.idLabel.text = user.uid;
    NSURL *url = [NSURL URLWithString:user.iconURL];
    // SDWebImageRefreshCached 已经下载过一次的就不需要再下载了
    [self.iconImageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRefreshCached];
    
}

@end
