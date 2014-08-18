//
//  UITableView+Placeholder.h
//  checklist
//
//  Created by pp on 06/02/14.
//  Copyright (c) 2014 pp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Placeholder)

#define kBOUNCE_DISTANCE  10.f
#define kWAVE_DURATION   .8f


typedef NS_ENUM(NSInteger,WaveAnimation) {
    LeftToRightWaveAnimation = -1,
    RightToLeftWaveAnimation = 1
};

- (void)reloadDataAnimateWithWave:(WaveAnimation)animation;

-(void)reloadDataWithPlaceholderString:(NSString *)placeholderString;
-(void)reloadDataWithPlaceholderString:(NSString *)placeholderString wihtUIColor:(UIColor *)placeholderColor;
-(void)reloadDataWithPlaceholderString:(NSString *)placeholderString lookupsection:(NSInteger)section;
-(void)reloadCellwithAnimation:(UITableViewCell *)cell;
@end
