//
//  ConversationListViewController.m
//  Fanner
//
//  Created by ZHANGMIA on 8/5/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "ConversationListViewController.h"
#import "Service+Conversation.h"
#import "CoreDataStack+Conversation.h"
#import "EntityNameConstant.h"
#import "CoreDataStack+Message.h"
#import "UserTableViewCell.h"
#import "MessageViewController.h"
#import "Conversation.h"

@implementation ConversationListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 向服务器请求用户列表 （和你聊过天的）
    // conversation list API
    [[Service sharedInstance] conversationListWithSuccess:^(NSArray *result) {
        [[CoreDataStack sharedCoreDataStack] addConversationsWithProfile:result];
        // 当数据请求成功 并插入到数据库成功
        [self configureFetch];
        // 执行
        [self performFetch];
        //NSLog(@"result = %@", result);
    } failure:^(NSError *error) {
        
    }];
}

// 设置请求
- (void)configureFetch
{
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:CONVERSATION_ENTITY];
    
    // 设置排序
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"message.created_at" ascending:NO];
    
    NSArray *descriptors = @[descriptor];
    fr.sortDescriptors = descriptors;
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fr managedObjectContext:[CoreDataStack sharedCoreDataStack].context sectionNameKeyPath:nil cacheName:nil];
    
    // 设置代理
    self.frc.delegate = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConversationCell"];
    
    Conversation *conversation = [self.frc objectAtIndexPath:indexPath];
    
    [cell configureWithConversation:conversation];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    MessageViewController *messageViewController = segue.destinationViewController;
    messageViewController.hidesBottomBarWhenPushed = YES;
    Conversation *ct =  [self.frc objectAtIndexPath:indexPath];
    messageViewController.otherID = ct.otherid;
}


@end
