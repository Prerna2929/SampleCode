//
//  BattleVC.m
//  RatingVoting
//
//  Created by c85 on 09/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "BattleVC.h"
#import "UIImage+ZigZag.h"
#import "UIImageView+WebCache.h"
#import "WebServiceParser+Battle.h"
#import "BattlePostCell.h"
#import "PostDetail.h"
#import "OperationHelper.h"


typedef enum {
    ASC,
    DESC
} ArraySortOrder;

@interface BattleVC ()
{
    NSMutableArray *battleDetails;
    NSMutableArray *fromPostArray, *toPostArray;
    ArraySortOrder sortingOrder;
}

@property (nonatomic, strong) OperationHelper *operationHelperInstance;

@end

static NSString *kCellReuseIdentifier = @"BattleDetailCell";

@implementation BattleVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    battleDetails = [NSMutableArray new];
    [self getBattleForUser];
    
	self.title = @"Battle";
    [self setNavigationbarButton];
    [self.battleCollection setBackgroundColor:[UIColor clearColor]];
    [self setColloectionView];
}

- (void) setColloectionView{
    [self.battleCollection registerNib:[UINib nibWithNibName:@"BattlePostCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifier];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(320,viewHeight(self.view) - 60 )];
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:0];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.battleCollection setCollectionViewLayout:flowLayout];
    self.battleCollection.pagingEnabled = YES;
    [self.battleCollection setAllowsSelection:YES];
    self.battleCollection.pagingEnabled = YES;
    self.battleCollection.delegate=self;
    self.battleCollection.clipsToBounds = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -  NavigationBar

-(void)setNavigationbarButton
{
    app.leftNavController.navigationBarHidden = YES;
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 2, 35, 35);
    btnRight.backgroundColor = [UIColor clearColor];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(closeDrawer) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:btnRight];
    self.navigationItem.leftBarButtonItem = rightButton;
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 2, 35, 35);
    btnLeft.backgroundColor = [UIColor clearColor];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"createbattle"] forState:UIControlStateNormal];
//    [btnLeft addTarget:self action:@selector(createbattle) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.navigationItem.rightBarButtonItem = leftButton;
}

- (void) getBattleForUser {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(BattleImageDownloaded:)
                                                 name:@"BattleImageDownloaded"
                                               object:nil];
    
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    
    [service BattleService:WSGetBattlebyUser parameters:[NSString stringWithFormat:@"user_id=%@&start_record=0", [SessionDetail currentSession].userDetail.userId] customeobject:Nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
        if (error) {
            [UIAlertView showWithTitle:AppName message:[error.userInfo objectForKey:@"msg"] cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        }
        else {
            fromPostArray = NSMutableArray.new;
            toPostArray = NSMutableArray.new;
            
//            [CacheData getcachedataArrayFor_:keyBattleFromPostDetail myMethod:^(BOOL finished, NSMutableArray *resultArray) {
//                if (finished) {
//                    if (resultArray.count > 0) {
//                        fromPostArray = NSMutableArray.new;
//                        [fromPostArray addObjectsFromArray:[self sortArray:resultArray withOrder:DESC]];
//                    }
//                }
//            }];
//            
//            [CacheData getcachedataArrayFor_:keyBattleToPostDetail myMethod:^(BOOL finished, NSMutableArray *resultArray) {
//                if (finished) {
//                    if (resultArray.count > 0) {
//                        toPostArray = NSMutableArray.new;
//                        [toPostArray addObjectsFromArray:[self sortArray:resultArray withOrder:DESC]];
//                    }
//                }
//            }];
            
            
            _operationHelperInstance = [OperationHelper sharedOperationObject];
            [_operationHelperInstance setOperationForFromPostDownload];
            
            _operationHelperInstance = [OperationHelper sharedOperationObject];
            [_operationHelperInstance setOperationForToPostDownload];
            
//            NSLog(@"EXIT");
//            [self.battleCollection reloadData];
            
        }
    }];
}

#pragma mark - Reload Battle Image

- (void) BattleImageDownloaded : (NSNotification *) notification
{
    if ([notification.name isEqualToString:@"BattleImageDownloaded"])
    {
        PostDetail* battlePost = (PostDetail *) notification.object;
        if ([battlePost.to_userPost isEqualToString:@"1"]) {
            [toPostArray addObject:battlePost];
        }
        else {
            [fromPostArray addObject:battlePost];
        }
        
//        [CacheData getcachedataArrayFor_:keyAllbattlePostDetail myMethod:^(BOOL finished, NSMutableArray *resultArray) {
//            if (finished) {
//                for (PostDetail *postObj in resultArray) {
//                    if (postObj.toPostImage != nil && postObj.fromPostImage != nil) {
//                        NSPredicate *filter ;
//                        
//                        filter= filter= [NSPredicate predicateWithFormat:@"SELF.toPostImage ==[c] %@ && SELF.BattleID ==[c] %@", @"1", postObj.battleID];
//                        NSArray *FilteredToBattleArray = [resultArray filteredArrayUsingPredicate:filter];
//                        [toPostArray addObjectsFromArray:FilteredToBattleArray];
//                        
//                        
//                        filter= [NSPredicate predicateWithFormat:@"SELF.toPostImage ==[c] %@ && SELF.BattleID ==[c] %@", @"0", postObj.battleID];
//                        FilteredToBattleArray = [resultArray filteredArrayUsingPredicate:filter];
//                        [fromPostArray addObjectsFromArray:FilteredToBattleArray];
//                    }
//                }
//                
////                NSPredicate *filter ;
////                filter= [NSPredicate predicateWithFormat:@"SELF.battleID ==[c] %@", battlePost.battleID];
////                NSArray *FilteredToBattleArray = [resultArray filteredArrayUsingPredicate:filter];
////                if (FilteredToBattleArray.count == 2)
////                {
////                    FilteredToBattleArray = [NSArray new];
////                    
////                    filter= [NSPredicate predicateWithFormat:@"SELF.toPostImage ==[c] %@", @"1"];
////                    FilteredToBattleArray = [resultArray filteredArrayUsingPredicate:filter];
////                    [toPostArray addObjectsFromArray:FilteredToBattleArray];
////                    
////                    filter= [NSPredicate predicateWithFormat:@"SELF.toPostImage ==[c] %@", @"0"];
////                    FilteredToBattleArray = [resultArray filteredArrayUsingPredicate:filter];
////                    [fromPostArray addObjectsFromArray:FilteredToBattleArray];
////                }
//            }
//        }];
        
//        NSPredicate *filter ;
//        
//        filter= [NSPredicate predicateWithFormat:@"SELF.BattleID ==[c] %@", battlePost.battleID];
//        NSArray *FilteredToBattleArray = [toPostArray filteredArrayUsingPredicate:filter];
//        NSArray *FilteredFromBattleArray = [fromPostArray filteredArrayUsingPredicate:filter];
//        
//        if (FilteredFromBattleArray.count == 1 && FilteredToBattleArray.count == 1)
//        {
//            [fromPostArray addObjectsFromArray:[self sortArray:[FilteredFromBattleArray mutableCopy] withOrder:DESC]];
//            [toPostArray addObjectsFromArray:[self sortArray:[FilteredFromBattleArray mutableCopy] withOrder:DESC]];
//        }
    }
}
#pragma mark - collectio view delegate methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return toPostArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = kCellReuseIdentifier;
    
    BattlePostCell *cell;
    
    cell = (BattlePostCell *)[self.battleCollection dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.row <= toPostArray.count) {
    
        PostDetail *postFrom = [fromPostArray objectAtIndex:indexPath.row];
        PostDetail *postTo = [toPostArray objectAtIndex:indexPath.row];
    
        cell.imgBattleView_posts.image = [GlobalHelper setPlaceholder:BigPostPlaceHolder];
        
        __block UIImage *fromImage;
        __block UIImage *toImage;
        
        UIImageView *imgTempFrom = [UIImageView new];
        UIImageView *imgTempTo = [UIImageView new];
        
        [imgTempFrom setImageWithURL:[NSURL URLWithString:postFrom.postImage] placeholderImage:[GlobalHelper setPlaceholder:BigPostPlaceHolder] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            fromImage = image;
            if (toImage != nil) {
                cell.imgBattleView_posts.image = [UIImage zigZagImageFrom:fromImage secondImage:toImage];
            }
        }];
        
        
        [imgTempTo setImageWithURL:[NSURL URLWithString:postTo.postImage] placeholderImage:[GlobalHelper setPlaceholder:BigPostPlaceHolder] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            toImage = image;
            if (fromImage != nil) {
                cell.imgBattleView_posts.image = [UIImage zigZagImageFrom:fromImage secondImage:toImage];
            }
        }];
        
//        cell.imgBattleView_posts.image = [UIImage zigZagImageFrom:[UIImage imageNamed:@"img2"] secondImage:[UIImage imageNamed:@"img1"]];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.battleCollection.contentOffset.y < 0) {
        self.battleCollection.contentOffset = CGPointMake(self.battleCollection.contentOffset.x, 0.0);
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - sort battle arrat

- (NSMutableArray *) sortArray : (NSMutableArray *) array
                     withOrder : (ArraySortOrder) order
{
    NSArray *sortedArrayFinalArray;
    
    sortedArrayFinalArray = [[NSArray arrayWithArray:array] sortedArrayUsingComparator:^NSComparisonResult(PostDetail * a, PostDetail * b) {
        switch (order) {
            case ASC:
            {
                if ([[a battleID] integerValue] < [[b battleID] integerValue])
                    return NSOrderedAscending;
                else if ([[a battleID] integerValue] > [[b battleID] integerValue])
                    return NSOrderedDescending;
                else
                    return NSOrderedSame;
            }
                break;
            case DESC:
            {
                if ([[a battleID] integerValue] > [[b battleID] integerValue])
                    return NSOrderedAscending;
                else if ([[a battleID] integerValue] < [[b battleID] integerValue])
                    return NSOrderedDescending;
                else
                    return NSOrderedSame;
            }
                break;
            default:
                break;
        }
    }];
    return [sortedArrayFinalArray mutableCopy];
}

@end