//
//  SearchCell.h
//  RatingVoting
//
//  Created by c85 on 25/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgUser;
@property (nonatomic, strong) IBOutlet UILabel *lblUserName, *lblPostDescription;
@property (nonatomic, strong) UIImageView *sepratorView;
@property (nonatomic, strong) IBOutlet UIButton *inviteForBattle;
@end
