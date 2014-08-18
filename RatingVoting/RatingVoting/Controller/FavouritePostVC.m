//
//  FavouritePost.m
//  RatingVoting
//
//  Created by c85 on 28/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "FavouritePostVC.h"
#import "PostDetail.h"
#import "OwnPostCell.h"
#import "WebServiceParser+FavouritePost.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "TrendsVC.h"
#import "UIViewController+MMDrawerController.h"

@interface FavouritePostVC ()
{
    BOOL isPullToRefresh, isLoadMoreCalled;
    NSInteger nextStartRecord;
    
    NSString *currentUserId;
}

@property (readwrite, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation FavouritePostVC
@synthesize favPostList;

#pragma mark - Class Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addCollectionview];
    defaultFavorite.contentMode = UIViewContentModeScaleAspectFit;
    favPostList = [[NSMutableArray alloc]init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refresFavPostList)
                  forControlEvents:UIControlEventValueChanged];
    [colFavourite addSubview:self.refreshControl];
    colFavourite.alwaysBounceVertical = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)getFavouritePostforuserID : (NSString *) userID
{
    currentUserId = userID;
    if (favPostList.count == 0)
        [self callGetFavouritePostWebService];
}

-(void)callGetFavouritePostWebService
{
//    if (favPostList.count == 0)
//        [GlobalHelper dispToastMessage:@"Fetching Favorite Posts.."];
    
    [GlobalHelper showActiviIndicatorOnView:defaultFavorite
                                  withStyle:UIActivityIndicatorViewStyleWhite
                                   hideShow:showIndicator
     ];
    
    nextStartRecord = isPullToRefresh ? 0 : nextStartRecord;
    
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    [service getFavouritePostRequest:WSGetFavouritePost
                          parameters:[NSString stringWithFormat:@"user_id=%@&start_record=%ld",currentUserId,(long)nextStartRecord]
                       customeobject:nil
                               block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
                                   [GlobalHelper showActiviIndicatorOnView:defaultFavorite
                                                                 withStyle:UIActivityIndicatorViewStyleWhite
                                                                  hideShow:hideIndicator
                                    ];
                                   if (isPullToRefresh) {
                                       [favPostList removeAllObjects];
                                   }
                                   isPullToRefresh = NO;
                                   isLoadMoreCalled = YES;
                                   if (error) {
                                       TRC_DBG(@"fail to Load achivements ");
                                       [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                                   }
                                   else {
                                       [favPostList addObjectsFromArray:objects];
                                       
                                       if (favPostList.count > 0) {
                                           [UIView animateWithDuration:0.8 animations:^() {
                                               defaultFavorite.hidden = YES;
                                               [colFavourite setBackgroundView:nil];
                                           }];
                                       }
                                       else {
                                           [UIView animateWithDuration:0.8 animations:^() {
                                               [colFavourite setBackgroundView:defaultFavorite];
                                               defaultFavorite.image = [UIImage imageNamed:@"nofavoritepost"];
                                               defaultFavorite.hidden = NO;
                                           }];
                                       }
                                       
                                       if (favPostList.count <= [objects count]) {
                                           [CacheData setCacheToUserDefaults:favPostList ForKey:keyFavPost];
                                       }
                                       
                                       if (nextUrl != nil) nextStartRecord = [nextUrl integerValue];
                                       [self.refreshControl endRefreshing];
                                       [colFavourite reloadData];
                                       [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                                   }
                               }];
}

-(void)refresFavPostList
{
    if (self.refreshControl!=nil)
    {
        if (colFavourite.contentOffset.y <=0) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
                    
                    colFavourite.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
                    
                } completion:^(BOOL finished){
                    
                    [self.refreshControl beginRefreshing];
                    isPullToRefresh = YES;
                    [self callGetFavouritePostWebService];
                }];
            }];
        }
    }
    else
    {
        isPullToRefresh = YES;
        [self callGetFavouritePostWebService];
    }
}

#pragma mark - collectionview delegate methods

-(void)addCollectionview
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(94, 94)];
    [flowLayout setMinimumInteritemSpacing:4];
    [flowLayout setMinimumLineSpacing:8];
    [flowLayout setScrollDirection:(UICollectionViewScrollDirectionVertical)];
    
    [colFavourite setCollectionViewLayout:flowLayout];
    [colFavourite setAllowsSelection:YES];
    [colFavourite setContentInset:UIEdgeInsetsMake(10, 10, 0, 10)];
    [colFavourite setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (collectionView == colFavourite) {
    return favPostList.count;
//    }
//    else {
//        return 12;
//    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OwnPostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FavPostCell" forIndexPath:indexPath];
    
    PostDetail *detail = [favPostList objectAtIndex:indexPath.row];

    [cell.btnPostImage.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    cell.btnPostImage.layer.cornerRadius = 5;
    cell.btnPostImage.layer.masksToBounds = YES;
    
    if ([detail.postType isEqualToString:@"video"]) {
        [cell.btnPostImage setImageWithURL:[NSURL URLWithString:detail.videoFrame] forState:UIControlStateNormal placeholderImage:[GlobalHelper setPlaceholder:SmallPostPlaceHolder]];
        [cell.imgIndicator setImage:[UIImage imageNamed:@"videoindecator"]];
    }
    else {
        [cell.btnPostImage setImageWithURL:[NSURL URLWithString:detail.postImage] forState:UIControlStateNormal placeholderImage:[GlobalHelper setPlaceholder:SmallPostPlaceHolder]];
        [cell.imgIndicator setImage:[UIImage imageNamed:@"imageindicator"]];
    }
    [cell.btnPostImage addTarget:self action:@selector(selectPost:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnPostImage setTag:indexPath.row];
    
    [cell.btnTotalVotes setTitle:detail.totalUpVotes forState:UIControlStateNormal];
    
    [cell.btnTotalVotes setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        TrendsVC *trendsVC = (TrendsVC *)[[app.centralNavController viewControllers] firstObject];
        trendsVC.isDefaultMode = NO;
        trendsVC.selectedPost = [favPostList objectAtIndex:indexPath.row];
        trendsVC.trendSegment.hidden = YES;
        [trendsVC.colTrends reloadData];
    }];
}

- (IBAction)selectPost:(id)sender {
//    [self closeDrawer];
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        TrendsVC *trendsVC = (TrendsVC *)[[app.centralNavController viewControllers] firstObject];
        trendsVC.isDefaultMode = NO;
        trendsVC.selectedPost = [favPostList objectAtIndex:[sender tag]];
        trendsVC.trendSegment.hidden = YES;
        [trendsVC.colTrends reloadData];
    }];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height) {
        if (isLoadMoreCalled) {
            isLoadMoreCalled = NO;
            if (favPostList.count < nextStartRecord)
                [self getFavouritePostforuserID:currentUserId];
        }
    }
}

@end
