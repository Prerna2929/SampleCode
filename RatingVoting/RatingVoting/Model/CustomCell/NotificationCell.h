//
//  NotificationCell.h
//  RatingVoting
//
//  Created by c85 on 21/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPPZLabel.h"

@interface NotificationCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgUser;
@property (nonatomic, strong) IBOutlet UILabel *lblMessage;
@property (nonatomic, strong) UIImageView *sepratorView;
@property (nonatomic, strong) IBOutlet UIButton *btnAcceptBattle;
@property (nonatomic, strong) IBOutlet UIButton *btnRejectBattle;
@property (nonatomic, strong) IBOutlet UIButton *RejectedBattle;
@property (nonatomic, strong) IBOutlet UIButton *btnMakePostForbattle;
@end
