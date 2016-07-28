//
//  UserTableViewCell.h
//  Fanner
//
//  Created by ZHANGMIA on 7/26/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

@interface UserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *idLabel;

- (void)configureWithUser:(User *)user;

@end
