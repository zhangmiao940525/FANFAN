//
//  ComposeViewController.m
//  Fanner
//
//  Created by ZHANGMIA on 8/3/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "ComposeViewController.h"
#import "Service.h"

@interface ComposeViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ComposeViewController

- (IBAction)close:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)takePhoto:(id)sender {
    // 创建pickerController
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    // set delegate
    picker.delegate = self;
    // present
    [self presentViewController:picker animated:YES completion:nil];
}


- (IBAction)postContent:(id)sender {
    
    NSData *data = UIImageJPEGRepresentation(_pickerImageView.image, 0.5);
   [[Service sharedInstance] postData:@"test" imageData:data replyToStatusID:nil repostStatusID:nil success:^(NSArray *result) {
        //NSLog(@"%@",result);
   } failure:^(NSError *error) {
       NSLog(@"%@",error.description);
   }];
    
}

#pragma mark - picker 代理
// 照片选择完成后调用这个方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
   self.pickerImageView.image = info[UIImagePickerControllerOriginalImage];
    // 选中后取消当前controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // 取消后退出当前controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
