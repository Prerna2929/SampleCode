//
//  NotificationCell.m
//  RatingVoting
//
//  Created by c85 on 21/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#define kPadding 5

#import "NotificationCell.h"

@implementation NotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingNone;
        
//        self.btnAcceptRejectBattle = [[UIButton alloc] initWithFrame:CGRectMake(254, 13, 53, 46)];
//        self.btnAcceptRejectBattle.backgroundColor = [UIColor clearColor];
//        self.btnAcceptRejectBattle.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue_Light" size:10.0];
//        self.btnAcceptRejectBattle.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        self.btnAcceptRejectBattle.autoresizingMask = UIViewAutoresizingNone;
//        [self addSubview:self.btnAcceptRejectBattle];
//        
//        self.imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(3, 5, 60, 60)];
//        self.imgUser.backgroundColor = [UIColor lightGrayColor];
//        self.imgUser.layer.cornerRadius = CGRectGetWidth(self.imgUser.frame) / 2.0f;
//        self.imgUser.layer.masksToBounds = YES;
//        [self addSubview:self.imgUser];
//        
//        self.lblMessage = [[UILabel alloc] init];
//        self.lblMessage.textColor = [UIColor whiteColor];
//        self.lblMessage.textAlignment = NSTextAlignmentLeft;
//        self.lblMessage.font = [ThemeManger getThemeFontWithSize:13.0];
//        self.lblMessage.numberOfLines = 0;
//        self.lblMessage.frame = CGRectMake(CGRectGetMaxX(self.imgUser.frame) + kPadding, 10, CGRectGetWidth(self.frame) - (CGRectGetMaxX(self.imgUser.frame) + kPadding), 20);
//        [self addSubview:self.lblMessage];
//        
//        self.sepratorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 1)];
//        self.sepratorView.backgroundColor = [UIColor clearColor];
//        self.sepratorView.image = [UIImage imageNamed:@"divider"];
//        [self addSubview:self.sepratorView];
    }
    return self;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
