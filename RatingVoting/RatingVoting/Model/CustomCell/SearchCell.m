//
//  SearchCell.m
//  RatingVoting
//
//  Created by c85 on 25/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#define kPadding 5

#import "SearchCell.h"

@implementation SearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
//        self.imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 60, 60)];
//        self.imgUser.backgroundColor = [UIColor lightGrayColor];
//        self.imgUser.layer.cornerRadius = CGRectGetWidth(self.imgUser.frame) / 2.0f;
//        self.imgUser.layer.masksToBounds = YES;
//        [self addSubview:self.imgUser];
//        
//        self.lblName = [[UILabel alloc] init];
//        self.lblName.textColor = [UIColor whiteColor];
//        self.lblName.textAlignment = NSTextAlignmentLeft;
//        self.lblName.font = [ThemeManger getThemeFontWithSize:16.0];
//        self.lblName.numberOfLines = 0;
//        self.lblName.frame = CGRectMake(CGRectGetMaxX(self.imgUser.frame) + kPadding, 25, CGRectGetWidth(self.frame) - (CGRectGetMaxX(self.imgUser.frame) + kPadding), 20);
//        [self addSubview:self.lblName];
        
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
