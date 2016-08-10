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
#import "Conversation.h"
#import "CoreDataStack+User.h"

@implementation UserTableViewCell

- (void)configureWithUser:(User *)user
{
    self.nameLabel.text = user.name;
    self.idLabel.text = user.uid;
    NSURL *url = [NSURL URLWithString:user.iconURL];
    // SDWebImageRefreshCached 已经下载过一次的就不需要再下载了
    [self.iconImageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRefreshCached];
    
}
// 当你和别人会话时 可以作为发送者 也可以作为接收者

/**
 conversation.otherid  对话的人的id
 */
- (void)configureWithConversation:(Conversation *)conversation
{
//    if ([conversation.otherid isEqualToString:conversation.message.sender_id]) {
//        self.nameLabel.text = conversation.message.sender_screen_name;
//    } else {
//        self.nameLabel.text = conversation.message.recipient_screen_name;
//    }
    
    User *user = [[CoreDataStack sharedCoreDataStack]findUserWithId:conversation.otherid];
    self.idLabel.text = conversation.otherid;
    self.nameLabel.text = user.name;
    
        NSURL *url = [NSURL URLWithString:user.iconURL];
        // SDWebImageRefreshCached 已经下载过一次的就不需要再下载了
        [self.iconImageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRefreshCached];
    
}

@end
