//
//  MessageViewController.m
//  Fanner
//
//  Created by ZHANGMIA on 8/8/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "MessageViewController.h"
#import "Service+Conversation.h"
#import "CoreDataStack+Message.h"
#import <JSQMessagesViewController/JSQMessagesBubbleImageFactory.h>
#import <JSQMessagesViewController/UIColor+JSQMessages.h>
#import <JSQMessagesViewController/JSQMessagesBubbleImage.h>
#import "Message.h"
#import "CoreDataStack+User.h"
#import "User.h"
#import <JSQMessagesViewController/JSQMessage.h>

@interface MessageViewController ()

@property (nonatomic,strong)NSArray *messages;

@property (nonatomic,strong)JSQMessagesBubbleImage *incomingBubble;
@property (nonatomic,strong)JSQMessagesBubbleImage *outgoingBubble;

@property (nonatomic,strong)User *currentUser;
@end

@implementation MessageViewController
// 初始化数据，请求所有的messages
- (void)refreshData
{
    [[Service sharedInstance]conversationsWithUserID:_otherID success:^(id result) {
        // 把message模型插入到数据库（内存）
        [[CoreDataStack sharedCoreDataStack] addMessagesWitArray:result];
        // 查找所有当前会话的Messages 并赋值给_messages
        self.messages = [[CoreDataStack sharedCoreDataStack] fetchMessagesWithUserID:_otherID];
        // 重新加载继承自父类的collectionview方法
        [self.collectionView  reloadData];
        // 把scrollview移动到底部
        [self scrollToBottomAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentUser = [CoreDataStack sharedCoreDataStack].currentUser;
    //
    JSQMessagesBubbleImageFactory *factory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubble = [factory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubble = [factory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    
    //
    [self refreshData];
}

#pragma mark - JSQMessagesCollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    Message *msg = [_messages objectAtIndex:indexPath.item];
    
    
    if ([msg.sender_id isEqualToString:self.senderId]) {
        cell.textView.textColor = [UIColor blackColor];
    }
    else {
        cell.textView.textColor = [UIColor whiteColor];
    }
    
    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    
    
    return cell;

}

// 删除
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath;
{
    return;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Message *msg = [_messages objectAtIndex:indexPath.item];
    JSQMessage *jsm = [[JSQMessage alloc] initWithSenderId:msg.sender_id senderDisplayName:self.senderDisplayName date:msg.created_at text:msg.text];
    return jsm;
}

- (NSString *)senderId
{
    return self.currentUser.uid;
}
// 发消息的人的名字
- (NSString *)senderDisplayName
{
    return self.currentUser.name;
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 判断是接受者还是发送者
    Message *msg = [_messages objectAtIndex:indexPath.item];
    if ([msg.sender_id isEqualToString:_currentUser.uid]) {
        return self.outgoingBubble;
    } else {
        return self.incomingBubble;
    }
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    Message *msg = [_messages objectAtIndex:indexPath.item];
    return [[NSAttributedString alloc] initWithString:[msg.created_at ]];
    
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    return  20;
}


//
//- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
//    Message *mg = [_messages lastObject];
//    [[Service sharedInstance] postMessageWithUserID:_userID text:text sucess:^(NSArray *result) {
//        [[CoreDataStack sharedCoreDataStack] insertOrUpdateMessageWithProfile:result];
//        _messages = [[CoreDataStack sharedCoreDataStack] fetchMessagesWithUserID:_userID];
//        [self.collectionView reloadData];
//        [self finishSendingMessageAnimated:YES];
//        
//    } inReplyID:mg.mid failure:^(NSError *error) {
//        
//    }];
//    
}

@end
