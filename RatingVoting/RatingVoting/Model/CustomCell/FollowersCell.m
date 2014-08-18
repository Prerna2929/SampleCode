//
//  FollowersCell.m
//  RatingVoting
//
//  Created by c32 on 08/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "FollowersCell.h"

@implementation FollowersCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.imgFollowerProfile = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 40, 40)];
        self.imgFollowerProfile.backgroundColor = [UIColor lightGrayColor];
        self.imgFollowerProfile.layer.cornerRadius = CGRectGetWidth(self.imgFollowerProfile.frame) / 2.0f;
        self.imgFollowerProfile.layer.masksToBounds = YES;
        [self addSubview:self.imgFollowerProfile];
        
        self.lblFollowerUserName = [[UILabel alloc] initWithFrame:CGRectMake(65, 16, 240, 35)];
        self.lblFollowerUserName.textColor = [UIColor whiteColor];
        self.lblFollowerUserName.textAlignment = NSTextAlignmentLeft;
        self.lblFollowerUserName.font = [UIFont systemFontOfSize:16.f];
        self.lblFollowerUserName.numberOfLines = 0;
        [self addSubview:self.lblFollowerUserName];
        
        self.sepratorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 1)];
        self.sepratorView.backgroundColor = [UIColor clearColor];
        self.sepratorView.image = [UIImage imageNamed:@"divider"];
        [self addSubview:self.sepratorView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
