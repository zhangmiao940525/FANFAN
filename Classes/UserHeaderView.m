//
//  UserHeaderView.m
//  Fanner
//
//  Created by ZHANGMIA on 8/9/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "UserHeaderView.h"
#import "CoreDataStack+User.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "User.h"

@implementation UserHeaderView
// xib被加载后执行
- (void)awakeFromNib
{
    [self configureView];
}
// 设置cell的显示内容
- (void)configureView
{
    // 取出用户模型
    User *user = [CoreDataStack sharedCoreDataStack].currentUser;
    // 下载头像
    NSURL *url = [NSURL URLWithString:user.iconURL];
    [_iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"BackgroundAvatar"] options:SDWebImageProgressiveDownload];
    // label显示的内容
    _nameLabel.text = user.name;
    _idLable.text = user.uid;
    // 文字显示的内容
    // 粉丝
    NSString *follower_count = [NSString stringWithFormat:@"%@粉丝",user.followers_count];
    [_followersBtn setTitle:follower_count forState:UIControlStateNormal];
    // 关注
    NSString *friends_count = [NSString stringWithFormat:@"%@关注",user.friends_count];
    [_followingBtn setTitle:friends_count forState:UIControlStateNormal];
    // 微博数
    NSString *statuses_count = [NSString stringWithFormat:@"%@消息",user.statuses_count];
    [_statusBtn setTitle:statuses_count forState:UIControlStateNormal];
    
    [_modifiedBtn setTitle:@"修改个人信息" forState:UIControlStateNormal];
}

@end
