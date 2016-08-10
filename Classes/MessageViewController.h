//
//  MessageViewController.h
//  Fanner
//
//  Created by ZHANGMIA on 8/8/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSQMessagesViewController/JSQMessagesViewController.h>

@interface MessageViewController : JSQMessagesViewController
// 对应展示这个控制器的Conversation传进来的other_id
// @property (nonatomic,strong)NSString *userID;
// 其实就是userID
@property (nonatomic,strong)NSString *otherID;

@end
