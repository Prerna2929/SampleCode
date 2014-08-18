//
//  BattleVC.h
//  RatingVoting
//
//  Created by c85 on 09/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "BaseVC.h"

@interface BattleVC : BaseVC <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) IBOutlet UIImageView *imgTemp;
@property (nonatomic, strong) IBOutlet UICollectionView *battleCollection;
@end