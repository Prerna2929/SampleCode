//
//  UITableView+Placeholder.m
//  checklist
//
//  Created by pp on 06/02/14.
//  Copyright (c) 2014 pp. All rights reserved.
//

#import "UITableView+Placeholder.h"

@implementation UITableView (Placeholder)

-(void)reloadDataWithPlaceholderString:(NSString *)placeholderString
{
    [self setBackgroundView:nil];
    if ([self numberOfSections]==0 || ([self numberOfRowsInSection:0]==0 || [self numberOfRowsInSection:0]==NSNotFound))
    {
        if (placeholderString.length>0)
        {
            UILabel *lblEmpty=[[UILabel alloc]initWithFrame:self.frame];
            [lblEmpty setText:placeholderString];
            lblEmpty.numberOfLines=2;
            lblEmpty.textAlignment=NSTextAlignmentCenter;
            [lblEmpty setLineBreakMode:NSLineBreakByWordWrapping];
            lblEmpty.textColor = [UIColor grayColor]; // [ThemeManger getSlideBarBgcolor];
//            [lblEmpty setFont:ThemeManger getThemeFontWithSize:12]];
            [lblEmpty sizeThatFits:self.frame.size];
            [self setBackgroundView:lblEmpty];
        }
    }
    else{
         [self setBackgroundView:nil];
    }
    [self reloadData];

}

-(void)reloadDataWithPlaceholderString:(NSString *)placeholderString lookupsection:(NSInteger)section
{
    [self setBackgroundView:nil];
    if ([self numberOfSections]==0 && ([self numberOfRowsInSection:section]==0 || [self numberOfRowsInSection:section]==NSNotFound))
    {
        if (placeholderString.length>0)
        {
            UILabel *lblEmpty=[[UILabel alloc]initWithFrame:self.frame];
            [lblEmpty setText:placeholderString];
            lblEmpty.numberOfLines=2;
            lblEmpty.textAlignment=NSTextAlignmentCenter;
            [lblEmpty setLineBreakMode:NSLineBreakByWordWrapping];
//            lblEmpty.textColor =[ThemeManger getSlideBarBgcolor];
//            [lblEmpty setFont:[ThemeManger getThemeFontWithSize:12]];
            [lblEmpty sizeThatFits:self.frame.size];
            [self setBackgroundView:lblEmpty];
        }
    }
    else{
         [self setBackgroundView:nil];
    }
    [self reloadData];
    
}

-(void)reloadDataWithPlaceholderString:(NSString *)placeholderString wihtUIColor:(UIColor *)placeholderColor
{
    [self setBackgroundView:nil];
   
    if ([self numberOfSections]==0 && ([self numberOfRowsInSection:0]==0 || [self numberOfRowsInSection:0]==NSNotFound))
    {
        if (placeholderString.length>0)
        {
            UILabel *lblEmpty=[[UILabel alloc]initWithFrame:self.frame];
            [lblEmpty setText:placeholderString];
            lblEmpty.numberOfLines=2;
            lblEmpty.textAlignment=NSTextAlignmentCenter;
            [lblEmpty setLineBreakMode:NSLineBreakByWordWrapping];
            lblEmpty.textColor =placeholderColor;
//            [lblEmpty setFont:[ThemeManger getThemeFontWithSize:12]];
            [lblEmpty sizeThatFits:self.frame.size];
            [self setBackgroundView:lblEmpty];
        }
    }
    else{
        [self setBackgroundView:nil];
    }
    [self reloadData];
    
}

- (void)reloadDataAnimateWithWave:(WaveAnimation)animation;
{
    
    [self setContentOffset:self.contentOffset animated:NO];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [UIView transitionWithView:self
                      duration:.1
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^(void) {
                        [self setHidden:YES];
                        [self reloadData];
                    } completion:^(BOOL finished) {
                        if(finished){
                            [self setHidden:NO];
                            [self visibleRowsBeginAnimation:animation];
                        }
                    }
     ];
}


- (void)visibleRowsBeginAnimation:(WaveAnimation)animation
{
    NSArray *array = [self indexPathsForVisibleRows];
    for (int i=0 ; i < [array count]; i++) {
        NSIndexPath *path = [array objectAtIndex:i];
        UITableViewCell *cell = [self cellForRowAtIndexPath:path];
        cell.frame = [self rectForRowAtIndexPath:path];
        cell.hidden = YES;
        [cell.layer removeAllAnimations];
        NSArray *array = @[path,[NSNumber numberWithInt:animation]];
        [self performSelector:@selector(animationStart:) withObject:array afterDelay:.08*i];
    }
}


- (void)animationStart:(NSArray *)array
{
    NSIndexPath *path = [array objectAtIndex:0];
    float i = [((NSNumber*)[array objectAtIndex:1]) floatValue] ;
    UITableViewCell *cell = [self cellForRowAtIndexPath:path];
    CGPoint originPoint = cell.center;
    CGPoint beginPoint = CGPointMake(cell.frame.size.width*i, originPoint.y);
    CGPoint endBounce1Point = CGPointMake(originPoint.x-i*2*kBOUNCE_DISTANCE, originPoint.y);
    CGPoint endBounce2Point  = CGPointMake(originPoint.x+i*kBOUNCE_DISTANCE, originPoint.y);
    cell.hidden = NO ;
    
    CAKeyframeAnimation *move = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    move.keyTimes=@[[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.8],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:1.]];
    move.values=@[[NSValue valueWithCGPoint:beginPoint],[NSValue valueWithCGPoint:endBounce1Point],[NSValue valueWithCGPoint:endBounce2Point],[NSValue valueWithCGPoint:originPoint]];
    move.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    CABasicAnimation *opaAnimation = [CABasicAnimation animationWithKeyPath: @"opacity"];
    opaAnimation.fromValue = @(0.f);
    opaAnimation.toValue = @(1.f);
    opaAnimation.autoreverses = NO;
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[move,opaAnimation];
    group.duration = kWAVE_DURATION;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    [cell.layer addAnimation:group forKey:nil];
    
}
-(void)reloadCellwithAnimation:(UITableViewCell *)cell
{
    CGPoint originPoint = cell.center;
    CGPoint beginPoint = CGPointMake(cell.frame.size.width*1, originPoint.y);
    CGPoint endBounce1Point = CGPointMake(originPoint.x*2*kBOUNCE_DISTANCE, originPoint.y);
    CGPoint endBounce2Point  = CGPointMake(originPoint.x*kBOUNCE_DISTANCE, originPoint.y);
    cell.hidden = NO ;
    
    CAKeyframeAnimation *move = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    move.keyTimes=@[[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.8],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:1.]];
    move.values=@[[NSValue valueWithCGPoint:beginPoint],[NSValue valueWithCGPoint:endBounce1Point],[NSValue valueWithCGPoint:endBounce2Point],[NSValue valueWithCGPoint:originPoint]];
    move.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    CABasicAnimation *opaAnimation = [CABasicAnimation animationWithKeyPath: @"opacity"];
    opaAnimation.fromValue = @(0.f);
    opaAnimation.toValue = @(1.f);
    opaAnimation.autoreverses = NO;
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[move,opaAnimation];
    group.duration = kWAVE_DURATION;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    [cell.layer addAnimation:group forKey:nil];
}


@end
