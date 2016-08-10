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
#import "NSDate+Extension.h"
#import "Service.h"
#import "CoreDataStack.h"

@interface MessageViewController ()

@property (nonatomic,strong)NSArray *messages;

@property (nonatomic,strong)JSQMessagesBubbleImage *incomingBubble;
@property (nonatomic,strong)JSQMessagesBubbleImage *outgoingBubble;

@property (nonatomic,strong)User *currentUser;

@property (nonatomic,strong)NSTimer *timer;
@end

@implementation MessageViewController

- (void)addTimer
{
    NSLog(@"%s",__func__);
    _timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:10.0 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

// 初始化数据，请求所有的messages
- (void)refreshData
{
    [[Service sharedInstance]conversationsWithUserID:_otherID success:^(id result) {
        // 把message模型插入到数据库（内存）
        [[CoreDataStack sharedCoreDataStack] addMessagesWitArray:result];
        // 查找所有当前会话的Messages 并赋值给_messages
        _messages = nil;
        _messages = [[CoreDataStack sharedCoreDataStack] fetchMessagesWithUserID:_otherID];
        // 重新加载继承自父类的collectionview方法
        
        [self.collectionView  reloadData];
        // 把scrollview移动到底部
        [self scrollToBottomAnimated:YES];
        
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentUser = [CoreDataStack sharedCoreDataStack].currentUser;
    //
    JSQMessagesBubbleImageFactory *factory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubble = [factory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubble = [factory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    //
    [self addTimer];
    //
  //  [self refreshData];
}

#pragma mark - JSQMessagesCollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%lu,%lu",self.messages.count,_messages.count);
    return self.messages.count;
}
// 返回Item的内容对应CollectionViewCell
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

// 删除一条私信
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
// 对话框的背景颜色 一定不能为nil
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
// 返回头像
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
// TopLable 的内容 具体显示的什么
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    Message *msg = [_messages objectAtIndex:indexPath.item];
    // 把data改成string
    
    return [[NSAttributedString alloc] initWithString:[msg.created_at defaultDateString]];
    
}
// bub
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    return  20;
}


// 代理方法
- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
    Message *msg = [_messages lastObject];
    // 请求new的接口（发送私信的接口）
    [[Service sharedInstance] postMessageWithUserID:_otherID text:text sucess:^(id result) {
        // 插入到数据库Message
        [[CoreDataStack sharedCoreDataStack] insertOrUpdateMessageProfile:result];
        // 重新获取数据
        _messages = [[CoreDataStack sharedCoreDataStack] fetchMessagesWithUserID:_otherID];
        // 刷新collectionView
        [self.collectionView reloadData];
        [self finishSendingMessageAnimated:YES];
        
    } inReplyID:msg.mid
                                            failure:^(NSError *error) {
                                                NSLog(@"%@",error);
                                            }];
}

@end
