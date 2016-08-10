//
//  UserHeaderView.h
//  Fanner
//
//  Created by ZHANGMIA on 8/9/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *idLable;

@property (weak, nonatomic) IBOutlet UIButton *modifiedBtn;

@property (weak, nonatomic) IBOutlet UIButton *followingBtn;

@property (weak, nonatomic) IBOutlet UIButton *followersBtn;

@property (weak, nonatomic) IBOutlet UIButton *statusBtn;







@end
