//
//  TrendsVC.m
//  RatingVoting
//
//  Created by c85 on 07/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "TrendsVC.h"
#import "PostVC.h"
#import "FollowersVC.h"
#import "CommentCell.h"
#import "BattleVC.h"
#import "TrendHeaderCell.h"
#import "WebServiceParser+HashTag.h"
#import "WebServiceParser+Post.h"
#import "HashTagDetail.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"
#import "UIButton+WebCache.h"
#import "WebServiceParser+VotePost.h"
#import "WebServiceParser+Comment.h"
#import "PostsCell.h"
#import "PostDetail.h"
#import "IQKeyboardManager.h"
#import "UIView+Genie.h"
#import "CommentDetail.h"
#import "UIImage+ImageEffects.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MediaPlayer/MPMoviePlayerViewController.h>

#define kCommentCellHeight 0.0

typedef enum
{
    PostNew,
    PostTrend,
    PostFollowing
}PostType;

typedef enum
{
    AddToFavorite,
    RemoveFromFavorite
} AddRemoveFavPost;

typedef enum
{
    UpVoteAnimation,
    DownVoteAnimation
}AnimationType;

static NSString *videoType = @"video";
static NSString *imageType = @"image";

@interface TrendsVC ()
{
    BOOL isVideoPlaying;
    UIView *tblFooterView, *tblHeaderView;
    NSMutableArray *comments, *likesForComment, *userNames;
    BOOL isCommentOpen, isLoadMore;
    AddRemoveFavPost favAddRemove;
    PostType curPostType;
    TrendHeaderCell *footerView;
    TrendHeaderCell *headerView;
    NSInteger nextFirstRecord, nextCommentFirstRecord;
    UISwipeGestureRecognizer *SwipeDown;
    UISwipeGestureRecognizer *SwipeUp;
    CGSize keyboardSize;
    PostDetail *visiblePostDetail;
    AnimationType *upDownAnim;
    NSMutableArray *postsDetailList;
    NSArray *filteredStampArr;
    NSIndexPath *selectedIndexPath;
    NSString *selectedMentionIDS;
    IBOutlet UIImageView *imgStarUpVoteAnimation;
    IBOutlet UIImageView *imgNotPost;
}
@end

@implementation TrendsVC

@synthesize selectedPost, isDefaultMode, colTrends, trendSegment;

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
    
    if (isDefaultMode)
    {
        postsDetailList = [NSMutableArray new];
    }
    
    
    
    [self setNavigationbarButton];
    [self addCollectionview];
    
    CGRect tblFrame = tblTrends.frame;
    tblFrame.origin.y = CGRectGetMinY(self.view.frame) - CGRectGetHeight(tblTrends.frame);
    tblTrends.frame = tblFrame;
    
    isLoadMore = YES;
    
    [self setTableView];
    
    [self addGestureRecognizers];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
#pragma mark - keyboard height
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    if (!isVideoPlaying) {
        isVideoPlaying = NO;
        if (isDefaultMode)
        {
            if (app.needToCallCenterWillApper) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    [self getPosts];
                });
                [GlobalHelper showActiviIndicatorOnView:imgNotPost
                                              withStyle:UIActivityIndicatorViewStyleWhiteLarge
                                               hideShow:hideIndicator];
            }
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self gethashtags];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self getAllUserName];
    });
    
    _suggestionView.hidden = YES;
    _suggestionView._delegate = self;
    userNames = [NSMutableArray new];
    
    [CacheData getcachedataArrayFor_:keyUserNames myMethod:^(BOOL finished, NSMutableArray *retrivedList)
                                          {
                                              if(finished){
                                                  [userNames addObjectsFromArray:retrivedList];
                                                  TRC_NRM(@"Finished");
                                              }
                                          }];
    
    
    self.navigationItem.hidesBackButton = YES;
    trendSegment.selectedSegmentIndex = 1;
}

- (void) viewDidAppear:(BOOL)animated {
    if (!isDefaultMode)
    {
        [colTrends reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)keyboardShown:(NSNotification *)notification
{
    // Get the size of the keyboard.
    keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    //your other code here..........
}

#pragma mark - add gestures
- (void) addGestureRecognizers
{
    SwipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRecognizer:)];
    SwipeDown.direction = UISwipeGestureRecognizerDirectionDown ;
    
    SwipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRecognizer:)];
    SwipeUp.direction = UISwipeGestureRecognizerDirectionUp ;
    
    [colTrends addGestureRecognizer:SwipeDown];
    [colTrends addGestureRecognizer:SwipeUp];
}


- (void) SwipeRecognizer:(UISwipeGestureRecognizer *)sender
{
    if ( sender.direction == UISwipeGestureRecognizerDirectionDown )
    {
        [self showAnimation:DownVoteAnimation];
        
        WebServiceParser *service = [WebServiceParser sharedMediaServer];
        [service VotePostRequest:DirectionDOWN parameters:[NSString stringWithFormat:@"user_id=%@&downvote_post_ids=%@", [[SessionDetail currentSession].userDetail userId],visiblePostDetail.postId] customeobject:nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
            if (error) {
                [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
            }
            else {
                [GlobalHelper dispToastMessage:@"Down-voted Successfully!"];
            }
        }];
    }
    
    else if ( sender.direction == UISwipeGestureRecognizerDirectionUp )
    {
        [self showAnimation:UpVoteAnimation];
        WebServiceParser *service = [WebServiceParser sharedMediaServer];
        [service VotePostRequest:DirectionUP parameters:[NSString stringWithFormat:@"user_id=%@&upvote_post_ids=%@", [[SessionDetail currentSession].userDetail userId],visiblePostDetail.postId] customeobject:nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
            if (error) {
                [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
            }
            else {
                [GlobalHelper dispToastMessage:@"Up-voted Successfully!"];
            }
        }];
    }
}

#pragma mark - show animation

- (void) showAnimation : (AnimationType) anim {
    
    switch (anim) {
        case DownVoteAnimation:
        {
            /***** Animation for move to trash if user downvote *****/
            UIImageView *animImg=[[UIImageView alloc]initWithFrame:colTrends.frame];
            [animImg setImageWithURL:[NSURL URLWithString:visiblePostDetail.postImage] placeholderImage:[UIImage imageNamed:@"sample"]];
            [self.view addSubview:animImg];
            
            UIImageView * dustbinAnim = [[UIImageView alloc] initWithFrame:CGRectMake(130, (CGRectGetHeight(self.view.bounds)-56), 60, 60)];
            dustbinAnim.animationImages = DownVoteImageArray;
            dustbinAnim.animationDuration = 2.0;
            dustbinAnim.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:dustbinAnim];
            [dustbinAnim startAnimating];
            
            [animImg genieInTransitionWithDuration:2.0
                                   destinationRect:CGRectMake(160, CGRectGetHeight(self.view.bounds), 2, 2)
                                   destinationEdge:BCRectEdgeTop
                                        completion:^{
                                            [animImg removeFromSuperview];
                                            [dustbinAnim stopAnimating];
                                            [dustbinAnim removeFromSuperview];
                                        }];
            /***** end animation *****/
        }
            break;
        case UpVoteAnimation:
        {
            [self performSelector:@selector(hideStartAnim) withObject:nil afterDelay:1.0];
            imgStarUpVoteAnimation.hidden = NO;
            imgStarUpVoteAnimation.animationImages = UpVoteImageArray;
            imgStarUpVoteAnimation.animationDuration = 1.0;
            imgStarUpVoteAnimation.contentMode = UIViewContentModeScaleAspectFit;
            imgStarUpVoteAnimation.animationRepeatCount = 1;
            [imgStarUpVoteAnimation startAnimating];
        }
            break;
        default:
            break;
    }
}

#pragma mark - hideStartAnim

- (void) hideStartAnim {
    imgStarUpVoteAnimation.hidden = YES;
}

#pragma mark -  NavigationBar

-(void)setNavigationbarButton
{
    [self.navigationItem setTitleView:trendSegment];
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 2, 35, 35);
    btnLeft.backgroundColor = [UIColor clearColor];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"menuIcon"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
    if (IOS_NEWER_OR_EQUAL_TO_X(7.0))
        [btnLeft setFrame:CGRectMake(0, 0, 35, 35)];
    else {
        [btnLeft setFrame:CGRectMake(0, 0, 35, 35)];
        btnLeft.contentEdgeInsets = (UIEdgeInsets){.left=10};
    }
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 2, 35, 35);
    btnRight.backgroundColor = [UIColor clearColor];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"vsIcon"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(battleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = rightButton;
}

#pragma mark - User Action

-(IBAction)menuClick:(id)sender
{
    [self openLeftView];
}

-(IBAction)battleClick:(id)sender
{
    [self openRightView];
}

-(IBAction)segmentValueChanged:(id)sender
{
    [UIView animateWithDuration:0.8 animations:^() {
        imgNotPost.hidden = NO;
        imgNotPost.image = nil;
        [colTrends setBackgroundView:nil];
    }];
    [GlobalHelper showActiviIndicatorOnView:imgNotPost
                                  withStyle:UIActivityIndicatorViewStyleWhiteLarge
                                   hideShow:hideIndicator];
    [GlobalHelper showActiviIndicatorOnView:imgNotPost
                                  withStyle:UIActivityIndicatorViewStyleWhiteLarge
                                   hideShow:showIndicator];
    switch (trendSegment.selectedSegmentIndex) {
        case 0:
        {
            filteredStampArr = [NSArray new];
            curPostType = PostNew;
            
            [postsDetailList removeAllObjects];
            [colTrends reloadData];
            [self getPosts];
        }
            break;
            
        case 1:
        {
            filteredStampArr = [NSArray new];
            curPostType = PostTrend;
            [postsDetailList removeAllObjects];
            [self getPosts];
            [colTrends reloadData];
        }
            break;
            
        case 2:
        {
            filteredStampArr = [NSArray new];
            curPostType = PostFollowing;
            [postsDetailList removeAllObjects];
            [self getFollowingPosts];
            [colTrends reloadData];
        }
            break;
        default:
            break;
    }
}

#pragma mark - collectionview delegate methods

-(void)addCollectionview
{
    [colTrends registerNib:[UINib nibWithNibName:@"CollectionItemCell" bundle:nil] forCellWithReuseIdentifier:@"collectionViewCell"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(CGRectGetWidth(colTrends.frame),CGRectGetHeight(colTrends.frame))];
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:0];
    [flowLayout setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
    [colTrends setCollectionViewLayout:flowLayout];
    [colTrends setAllowsSelection:YES];
}

- (void) getPosts
{
    nextFirstRecord = (!isLoadMore) ? 0 : nextFirstRecord;
    
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    [service PostRequest:WSGetAllPosts
              parameters:[NSString stringWithFormat:@"user_id=%@&start_record=%ld",[SessionDetail currentSession].userDetail.userId, (long)nextFirstRecord]
           customeobject:nil
                   block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
                       [GlobalHelper showActiviIndicatorOnView:imgNotPost
                                                     withStyle:UIActivityIndicatorViewStyleWhiteLarge
                                                      hideShow:hideIndicator];
                       if (error) {
                           [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                       }
                       else {
                           
                           if ([objects count] == 0) {
                               [colTrends removeGestureRecognizer:SwipeDown];
                               [colTrends removeGestureRecognizer:SwipeUp];
                               [postsDetailList removeAllObjects];
                               filteredStampArr = postsDetailList;
                               [colTrends reloadData];
                               
                               [GlobalHelper dispToastMessage:@"No posts available!"];
                               
                               [UIView animateWithDuration:0.8 animations:^() {
                                   [colTrends setBackgroundView:imgNotPost];
                                   imgNotPost.image = [UIImage imageNamed:@"noPost"];
                                   imgNotPost.hidden = NO;
                               }];
                               
                           }
                           else {
                               [UIView animateWithDuration:0.8 animations:^() {
                                   imgNotPost.hidden = YES;
                                   [colTrends setBackgroundView:nil];
                               }];

                               [colTrends addGestureRecognizer:SwipeDown];
                               [colTrends addGestureRecognizer:SwipeUp];
                               postsDetailList = (NSMutableArray*)objects;
                               
                               [CacheData setCacheToUserDefaults:postsDetailList ForKey:keyAllPosts];
                               
                               filteredStampArr = postsDetailList;
                               
                               if (nextUrl != nil)
                                   nextFirstRecord = [nextUrl integerValue];
                               else
                                   isLoadMore = YES;
                               [colTrends reloadData];
                               [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                           }
                       }
                   }];
}

- (void) getFollowingPosts
{
    nextFirstRecord = (!isLoadMore) ? 0 : nextFirstRecord;
    
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    [service PostRequest:WSGetFollowingPosts
              parameters:[NSString stringWithFormat:@"user_id=%@&start_record=%ld",[SessionDetail currentSession].userDetail.userId, (long)nextFirstRecord]
           customeobject:nil
                   block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
                       [GlobalHelper showActiviIndicatorOnView:imgNotPost
                                                     withStyle:UIActivityIndicatorViewStyleWhiteLarge
                                                      hideShow:hideIndicator];
                       if (error) {
                           [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                       }
                       else {
                           if ([objects isKindOfClass:[NSString class]]) {
                               [colTrends removeGestureRecognizer:SwipeDown];
                               [colTrends removeGestureRecognizer:SwipeUp];
                               [postsDetailList removeAllObjects];
                               filteredStampArr = postsDetailList;
                               
                               [GlobalHelper dispToastMessage:@"No posts available!"];
                               
                               [colTrends reloadData];
                               [UIView animateWithDuration:0.8 animations:^() {
                                   imgNotPost.hidden = NO;
                                   imgNotPost.image = [UIImage imageNamed:@"noPost"];
                                   [colTrends setBackgroundView:imgNotPost];
                               }];
                           }
                           else {
                               [UIView animateWithDuration:0.8 animations:^() {
                                   imgNotPost.hidden = YES;
                                   [colTrends setBackgroundView:nil];
                               }];
                               [colTrends addGestureRecognizer:SwipeDown];
                               [colTrends addGestureRecognizer:SwipeUp];
                               postsDetailList = (NSMutableArray*)objects;
                               
                               [CacheData setCacheToUserDefaults:postsDetailList ForKey:keyFollowingPosts];
                               
                               filteredStampArr = postsDetailList;
                               
                               if (nextUrl != nil)
                                   nextFirstRecord = [nextUrl integerValue];
                               else
                                   isLoadMore = YES;
                               [colTrends reloadData];
                               [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                           }
                       }
                   }];
}

- (void) getNewPosts
{
    nextFirstRecord = (!isLoadMore) ? 0 : nextFirstRecord;
    
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    [service PostRequest:WSGetNewPost
              parameters:[NSString stringWithFormat:@"user_id=%@&start_record=%ld",[SessionDetail currentSession].userDetail.userId, (long)nextFirstRecord]
           customeobject:nil
                   block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
                       [GlobalHelper showActiviIndicatorOnView:imgNotPost
                                                     withStyle:UIActivityIndicatorViewStyleWhiteLarge
                                                      hideShow:hideIndicator];
                       if (error) {
                           [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                       }
                       else {
                           if ([objects count] == 0) {
                               [colTrends removeGestureRecognizer:SwipeDown];
                               [colTrends removeGestureRecognizer:SwipeUp];
                               [postsDetailList removeAllObjects];
                               filteredStampArr = postsDetailList;
                               
                               [GlobalHelper dispToastMessage:@"No posts available!"];
                               
                               [colTrends reloadData];
                               [UIView animateWithDuration:0.8 animations:^() {
                                   imgNotPost.hidden = NO;
                                   imgNotPost.image = [UIImage imageNamed:@"noPost"];
                                   [colTrends setBackgroundView:imgNotPost];
                               }];
                           }
                           else {
                               [UIView animateWithDuration:0.8 animations:^() {
                                   imgNotPost.hidden = YES;
                                   [colTrends setBackgroundView:nil];
                               }];
                               [colTrends addGestureRecognizer:SwipeDown];
                               [colTrends addGestureRecognizer:SwipeUp];
                               postsDetailList = (NSMutableArray*)objects;
                               
                               [CacheData setCacheToUserDefaults:postsDetailList ForKey:keyNewPosts];
                               
                               filteredStampArr = postsDetailList;
                               
                               if (nextUrl != nil)
                                   nextFirstRecord = [nextUrl integerValue];
                               else
                                   isLoadMore = YES;
                               [colTrends reloadData];
                               [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                           }
                       }
                   }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (isDefaultMode)
        return filteredStampArr.count;
    return 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PostDetail *detail;
    
    if (isDefaultMode)
        detail = [filteredStampArr objectAtIndex:indexPath.row];
    else
    {
        [UIView animateWithDuration:0.8 animations:^() {
            imgNotPost.hidden = YES;
            [colTrends setBackgroundView:nil];
        }];
        [colTrends addGestureRecognizer:SwipeDown];
        [colTrends addGestureRecognizer:SwipeUp];
        detail = selectedPost;
    }
    
    visiblePostDetail = nil;
    
    visiblePostDetail = detail;
    
    comments = [NSMutableArray new];
    
    likesForComment = [NSMutableArray new];
    
    comments = visiblePostDetail.commentDetailArray;
    
    likesForComment = visiblePostDetail.commentLikeDetailArray;

    nextCommentFirstRecord =0;

    nextCommentFirstRecord = comments.count+1;
    
    PostsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"trendCell" forIndexPath:indexPath];
    
    [cell.imgPost setContentMode:UIViewContentModeScaleAspectFit];
    
    [cell.imgBlurPost setContentMode:UIViewContentModeScaleToFill];
    
    __block UIImageView *weakImgBlur = cell.imgBlurPost;
    
    if ([detail.postType isEqualToString:videoType])
    {
        [cell.imgPost setImageWithURL:[NSURL URLWithString:detail.videoFrame] placeholderImage:[GlobalHelper setPlaceholder:BigPostPlaceHolder]];
        
        [cell.imgBlurPost setImageWithURL:[NSURL URLWithString:detail.videoFrame] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            weakImgBlur.image = [image applyDarkEffect];
        }];
        
        [cell.btnPlayVideo setHidden:NO];
        [cell.btnPlayVideo setAccessibilityLabel:detail.postVideo];
        [cell.btnPlayVideo addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        
        [cell.imgPost setImageWithURL:[NSURL URLWithString:detail.postImage] placeholderImage:[GlobalHelper setPlaceholder:BigPostPlaceHolder]];
        
        [cell.imgBlurPost setImageWithURL:[NSURL URLWithString:detail.postImage] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            weakImgBlur.image = [image applyDarkEffect];
        }];
        
        [cell.btnPlayVideo setHidden:YES];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath = indexPath;
    selectedMentionIDS = @"";
    [self setCommentView];
}

#pragma mark - Comment View

-(void)setCommentView
{
    if(isCommentOpen) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect colFrame = colTrends.frame;
            colFrame.size.width = CGRectGetWidth(colTrends.frame);
            colFrame.size.height = CGRectGetHeight(colTrends.frame);
            colTrends.frame = colFrame;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
                
                
                [colTrends setScrollEnabled:YES];
                
                self.navigationController.navigationBarHidden = NO;
                
                [self setDDListHidden:YES forTextView:nil withFilteredArray : nil];
                
                CGRect frame = tblTrends.frame;
           
                frame.origin.y = CGRectGetMinY(self.view.frame) - CGRectGetHeight(tblTrends.frame) - CGRectGetHeight(tblHeaderView.frame) - CGRectGetHeight(tblFooterView.frame) - 45;

                tblTrends.frame = frame;
                
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect colFrame = colTrends.frame;
            colFrame.size.width = CGRectGetWidth(colTrends.frame);
            colFrame.size.height = CGRectGetHeight(colTrends.frame);
            colTrends.frame = colFrame;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.3 animations:^{
                [colTrends setScrollEnabled:NO];
                [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
                
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                [tblTrends reloadData];
                
                [headerView.imgProfilePic setImageWithURL:[NSURL URLWithString:visiblePostDetail.profilePic]  placeholderImage:[GlobalHelper setPlaceholder:ProfilePlaceHolder]];
                
                [headerView.lblUserName setText:visiblePostDetail.postByUserName];
                [headerView.btnVote setTitle:visiblePostDetail.totalUpVotes forState:UIControlStateNormal];
                
                [headerView.btnAddToFav setAccessibilityIdentifier:visiblePostDetail.postId];
                [headerView.lblPostDescription setText:visiblePostDetail.postText];
                
                if (visiblePostDetail.isFavourite) {
                    favAddRemove = RemoveFromFavorite;
                    headerView.imgAddToFavorite.image = [UIImage imageNamed:@"favorite"];
                }
                else {
                    favAddRemove = AddToFavorite;
                    headerView.imgAddToFavorite.image = [UIImage imageNamed:@"nonFavorite"];
                }
                [headerView.btnAddToFav addTarget:self action:@selector(addToFavorite:) forControlEvents:UIControlEventTouchUpInside];

                CGRect frame = tblTrends.frame;
                frame.origin.y = CGRectGetHeight(self.view.frame) - ((tblTrends.frame.size.height + CGRectGetHeight(tblHeaderView.frame) + CGRectGetHeight(tblFooterView.frame)));
                tblTrends.frame = frame;
                
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
    isCommentOpen = !isCommentOpen;
}

#pragma mark - TableView Methods

-(void)setTableView
{
    [tblTrends setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
    [tblTrends setSeparatorColor:[UIColor lightTextColor]];
}

-(void)setTableHeaderView
{
    headerView = [[TrendHeaderCell alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tblTrends.frame),50) withType:TableHeaderType];
    headerView.lblUserName.text = [[SessionDetail currentSession].userDetail username];
    headerView.btnUserImg.layer.cornerRadius = CGRectGetWidth(headerView.btnUserImg.frame) /2;
    headerView.btnUserImg.layer.masksToBounds = YES;
    headerView.btnUserImg.imageView.contentMode = UIViewContentModeScaleAspectFill;

    headerView.imgProfilePic.layer.cornerRadius = headerView.imgProfilePic.frame.size.height/2;
    headerView.imgProfilePic.layer.masksToBounds = YES;
    
    [headerView setBackgroundColor:[UIColor clearColor]];
    [tblTrends setTableHeaderView:headerView];
}

-(void)setTableFooterView
{
    footerView = [[TrendHeaderCell alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tblTrends.frame),50) withType:TableFooterType];
    footerView.delegateGetCommentText = self;
    [tblTrends setTableFooterView:footerView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return comments.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 78;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (footerView == nil) {
        footerView = [[TrendHeaderCell alloc]initWithFrame:CGRectMake(0, 30, CGRectGetWidth(tblTrends.frame),78) withType:TableFooterType];
        footerView.delegateGetCommentText = self;
    }
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (headerView == nil) {
        
        
        headerView = [[TrendHeaderCell alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tblTrends.frame),100) withType:TableHeaderType];
        headerView.lblUserName.text = visiblePostDetail.postByUserName;
        
        headerView.lblComments.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"commentbg"]];
        
        headerView.btnUserImg.layer.cornerRadius = CGRectGetWidth(headerView.btnUserImg.frame) /2;
        headerView.btnUserImg.layer.masksToBounds = YES;
        headerView.btnUserImg.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        headerView.imgProfilePic.layer.cornerRadius = headerView.imgProfilePic.frame.size.height/2;
        headerView.imgProfilePic.layer.masksToBounds = YES;
        
        [headerView.btnSharePost addTarget:self action:@selector(sharePost:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView setBackgroundColor:[UIColor clearColor]];
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getHeightForRowAtIndexPath:indexPath];
}

#pragma mark - TableView Data source Custom methods

-(CGFloat)getHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((UITableViewCell*)[self getCellForRowAtIndexPath:indexPath]).contentView.frame.size.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setCommentView];
}

-(UITableViewCell*)getCellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CommentCell *cell = [tblTrends dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell %@", ((CommentDetail *) [comments objectAtIndex:indexPath.row]).commentId]];
    if (!cell) {
        
        cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"Cell %@", ((CommentDetail *) [comments objectAtIndex:indexPath.row]).commentId]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.countChangeDelegate = self;
        
        cell.commentLabel.frame = (CGRect) {.origin = cell.commentLabel.frame.origin, .size = {CGRectGetMinX(cell.likeButton.frame) - CGRectGetMaxY(cell.iconView.frame) - kCommentPaddingFromLeft - kCommentPaddingFromRight - kCommentCellHeight}};
        
        cell.commentLabel.text = ((CommentDetail *) [comments objectAtIndex:indexPath.row]).commentText;
        
        [cell.commentLabel sizeToFit];
        
        [cell.iconView setImageWithURL:[NSURL URLWithString:((CommentDetail *) [comments objectAtIndex:indexPath.row]).commentedProfilePicture] placeholderImage:[GlobalHelper setPlaceholder:ProfilePlaceHolder]];
        
        cell.timeLabel.frame = (CGRect) {.origin = {CGRectGetMinX(cell.commentLabel.frame), CGRectGetMaxY(cell.commentLabel.frame)}};
        
        cell.timeLabel.text = [GlobalHelper convertToPrettyDateFrormat:[GlobalHelper getDateFromString:((CommentDetail *) [comments objectAtIndex:indexPath.row]).commentCreatedOn]];
        [cell.timeLabel sizeToFit];
        
        
        [cell.likeButton setAccessibilityIdentifier:((CommentDetail *) [comments objectAtIndex:indexPath.row]).commentId];
        [cell.disLikeButton setAccessibilityIdentifier:((CommentDetail *) [comments objectAtIndex:indexPath.row]).commentId];
        
        [cell.likeButton setTag:indexPath.row];
        [cell.disLikeButton setTag:indexPath.row];
        
        if ([((CommentDetail *) [comments objectAtIndex:indexPath.row]).ownLikeDisLikeStatus isEqualToString:@"1"])
        {
            [cell.disLikeButton setEnabled:NO];
            [cell.likeButton setEnabled:YES];
            
            [cell.likeButton setImage:[UIImage imageNamed:@"selfLiked"] forState:UIControlStateNormal];
            [cell.disLikeButton setImage:[UIImage imageNamed:@"disLike"] forState:UIControlStateNormal];
        }
        
        else if ([((CommentDetail *) [comments objectAtIndex:indexPath.row]).ownLikeDisLikeStatus isEqualToString:@"-1"])
        {
            [cell.disLikeButton setEnabled:YES];
            [cell.likeButton setEnabled:NO];
            
            [cell.disLikeButton setImage:[UIImage imageNamed:@"selfDisliked"] forState:UIControlStateNormal];
            [cell.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];

        }
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        if (cell.commentLabel.frame.size.height > 30) {
            cell.contentView.frame = (CGRect) {.origin = cell.contentView.frame.origin, .size = {cell.contentView.frame.size.width, (cell.contentView.frame.size.height) + CGRectGetMinY(cell.timeLabel.frame)-20}};
        }
        else {
            cell.contentView.frame = (CGRect) {.origin = cell.contentView.frame.origin, .size = {cell.contentView.frame.size.width, 65}};
        }
    }
    
    if ([((CommentDetail *) [comments objectAtIndex:indexPath.row]).ownLikeDisLikeStatus isEqualToString:@"0"] || ((CommentDetail *) [comments objectAtIndex:indexPath.row]).ownLikeDisLikeStatus.length == 0)
    {
        [cell.disLikeButton setImage:[UIImage imageNamed:@"disLike"] forState:UIControlStateNormal];
        [cell.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        
        [cell.disLikeButton setEnabled:YES];
        [cell.likeButton setEnabled:YES];
    }
    
    cell.usernameLabel.text = [NSString stringWithFormat:@"%@ :", ((CommentDetail *) [comments objectAtIndex:indexPath.row]).commentByUserName];
    
    [cell.totalDisLikes setText:[NSString stringWithFormat:@"%ld", (long)[((CommentDetail *) [comments objectAtIndex:indexPath.row]).commentDisLike integerValue]]];
    
    [cell.totalLikes setText:[NSString stringWithFormat:@"%ld", (long)[((CommentDetail *) [comments objectAtIndex:indexPath.row]).totalLike integerValue]]];
    
    return cell;
}

#pragma mark - getHash tag for Universal Use
- (void) gethashtags
{
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    [service HastTagRequest:WSGetAllhashTag
                 parameters:nil
              customeobject:nil
                      block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
                          if (error) {
                          }
                          else {
                              if (objects != nil)
                              {
                                  NSMutableArray * hashTagArrayList = [NSMutableArray new];
                                  for (HashTagDetail *tag in objects)
                                  {
                                      [hashTagArrayList addObject:tag.hashtag];
                                  }
                                  [CacheData setCacheToUserDefaults:hashTagArrayList ForKey:keyHashTagCache];
                              }
                          }
                      }];
}


#pragma mark - get comment detail for Post ID
- (void) getCommentsForPost
{
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    [service CommentService:WSGetAllComment parameters:[NSString stringWithFormat:@"post_id=%@&start_record=%ld&user_id=%@", visiblePostDetail.postId,(long)nextCommentFirstRecord, [SessionDetail currentSession].userDetail.userId] customeobject:nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
        isLoadMore = YES;
        if (error) {
        }
        else {
            if (objects != nil)
            {
                [comments addObjectsFromArray:objects];
                
                if (nextUrl != nil)
                    nextCommentFirstRecord = [nextUrl integerValue];
                
                [tblTrends reloadData];
            }
        }
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isLoadMore = YES;
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge >= scrollView.contentSize.height) {
            if (isLoadMore) {
                isLoadMore = NO;
                if (nextCommentFirstRecord > 0) {
                    if (comments.count < nextCommentFirstRecord)
                        [self getCommentsForPost];
                }
            }
        }
    }
    else
    {
        
    }
}

#pragma mark - Add to favorite
- (IBAction)addToFavorite:(id)sender {
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    ShowNetworkIndicator(YES);
    switch (favAddRemove) {
        case AddToFavorite:
        {
            [service PostRequest:WSMarkAsFavorite parameters:[NSString stringWithFormat:@"user_id=%@&favourite_post_ids=%@", [SessionDetail currentSession].userDetail.userId,visiblePostDetail.postId] customeobject:nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
                if (error) {
                    [GlobalHelper dispToastMessage:[error.userInfo objectForKey:@"msg"]];
                }
                else {
                    if ([responseString isEqualToString:@"success"])
                    {
                        [GlobalHelper showNotification:notifySuccess
                                               message:@"Marked as favorite!"
                                                 forVC:self];
                        
                        headerView.imgAddToFavorite.image = [UIImage imageNamed:@"favorite"];
                        PostDetail *post;
                        if (isDefaultMode) {
                            post = [postsDetailList objectAtIndex:selectedIndexPath.row];
                        }
                        else {
                            post = selectedPost;
                        }
                        post.isFavourite = YES;
                        
                        if (isDefaultMode) {
                            [postsDetailList replaceObjectAtIndex:selectedIndexPath.row withObject:post];
                            filteredStampArr = postsDetailList;
                        }
                        else
                            visiblePostDetail = selectedPost;
                        [colTrends reloadData];
                        favAddRemove = RemoveFromFavorite;
                    }
                }
            }];
        }
            break;
        case RemoveFromFavorite:
        {
            [service PostRequest:WSMarkAsFavorite parameters:[NSString stringWithFormat:@"user_id=%@&unfavourite_post_ids=%@", [SessionDetail currentSession].userDetail.userId,visiblePostDetail.postId] customeobject:nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
                if (error) {
                    [GlobalHelper dispToastMessage:[error.userInfo objectForKey:@"msg"]];
                }
                else {
                    if ([responseString isEqualToString:@"success"])
                    {
                        [GlobalHelper showNotification:notifyError
                                               message:@"Removed from favorite!"
                                                 forVC:self];
                        
                        headerView.imgAddToFavorite.image = [UIImage imageNamed:@"nonFavorite"];
                        PostDetail *post;
                        if (isDefaultMode) {
                            post = [postsDetailList objectAtIndex:selectedIndexPath.row];
                        }
                        else {
                            post = selectedPost;
                        }
                        post.isFavourite = NO;
                        
                        if (isDefaultMode) {
                            [postsDetailList replaceObjectAtIndex:selectedIndexPath.row withObject:post];
                            filteredStampArr = postsDetailList;
                        }
                        else
                            visiblePostDetail = selectedPost;
                        [colTrends reloadData];
                        favAddRemove = AddToFavorite;
                    }
                }
            }];
        }
            break;
        default:
            break;
    }
}


#pragma mark - get comment delegate
- (void) CommentText:(NSString *)comment withID:(NSString *)uID
{
    [self addComment : comment mentionedIDS:uID];
}

- (void) addComment : (NSString *) commentText mentionedIDS : (NSString *) userIDS
{
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    ShowNetworkIndicator(YES);
    [service CommentService:WSAddCommentToPost parameters:[NSString stringWithFormat:@"post_id=%@&user_id=%@&comment_text=%@&notification_ids=%@", visiblePostDetail.postId,[SessionDetail currentSession].userDetail.userId, commentText, selectedMentionIDS] customeobject:nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
        if (error) {
            selectedMentionIDS = @"";
            [GlobalHelper dispToastMessage:[error.userInfo objectForKey:@"msg"]];
        }
        else {
            if ([responseString isEqualToString:@"success"])
            {
                selectedMentionIDS = @"";
                CommentDetail *recentPosted = [CommentDetail new];
                recentPosted.commentId = [NSString stringWithFormat:@"%@", objects];
                recentPosted.commentText = commentText;
                recentPosted.commentByUserName = [SessionDetail currentSession].userDetail.username;
                recentPosted.commentBy = [SessionDetail currentSession].userDetail.userId;
                recentPosted.commentParentPostID = visiblePostDetail.postId;
                recentPosted.commentedProfilePicture = [SessionDetail currentSession].userDetail.profilePicture;
                recentPosted.ownLikeDisLikeStatus = @"0";
                recentPosted.commentCreatedOn = [NSString stringWithFormat:@"%@", [NSDate date]];
                PostDetail *post ;
                if (isDefaultMode)
                {
                    post = [postsDetailList objectAtIndex:selectedIndexPath.row];
                }
                else
                {
                    post = selectedPost;
                }
                
                if (post.commentDetailArray == nil)
                {
                    post.commentDetailArray = [NSMutableArray new];
                    post.commentsCount = 1;
                }
                else {
                    post.commentsCount = comments.count+1;
                }
                
                [post.commentDetailArray addObject:recentPosted];
                
                if (isDefaultMode)
                {
                    [postsDetailList replaceObjectAtIndex:selectedIndexPath.row withObject:post];
                    filteredStampArr = postsDetailList;
                }
                
                
                if (comments == nil || comments.count <= 5)
                {
                    comments = [NSMutableArray new];
                    [comments addObjectsFromArray:post.commentDetailArray];
                }
                
                [GlobalHelper dispToastMessage:@"Comment posted!"];
                
                [tblTrends reloadData];
            }
        }
    }];
}

- (void)setDDListHidden:(BOOL)hidden
           forTextView : (UITextView *) textVW
     withFilteredArray : (NSMutableArray *) filteredList
{
    _suggestionView.hidden = hidden;
    
	if (!hidden)
    {
        [_suggestionView setBackgroundColor:[UIColor whiteColor]];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [_suggestionView setAutoCompleteList:filteredList];
        if (filteredList.count >= 4) {
            [_suggestionView setFrame:CGRectMake(0, CGRectGetMinY(textVW.frame)+10, 320, CGRectGetHeight(self.view.frame)-(keyboardSize.height+118))];
        }
        else {
            [_suggestionView setFrame:CGRectMake(0, 60, 320, CGRectGetHeight(self.view.frame)-((keyboardSize.height+118)+15*filteredList.count))];
        }
        [UIView commitAnimations];
    }
}

#pragma mark -
#pragma mark PassValue protocol
- (void)passValue:(NSString *)value wilthAssociateID:(NSString *)userId{
	if (value)
    {
        if (selectedMentionIDS.length == 0) {
            selectedMentionIDS = userId;
        }
        else {
            selectedMentionIDS = [selectedMentionIDS stringByAppendingString:[NSString stringWithFormat:@",%@", userId]];
        }
        
        value = [NSString stringWithFormat:@"@%@", value];
        NSMutableArray *tags = [[footerView.txtComment.text componentsSeparatedByString:@" "] mutableCopy];
        [tags replaceObjectAtIndex:[tags count]-1 withObject:value];
        footerView.txtComment.text = [tags componentsJoinedByString:@" "];
        tags = nil;
        [self setDDListHidden:YES forTextView:nil withFilteredArray : nil];
	}
	else {
		
	}
}

#pragma mark - change like/dislike count management

-(void) changeCountForLikeComment:(BOOL)forLike
                       forComment:(NSString *)commentID
                       parentPost:(NSString *)postID
                     objectIndex : (int) index
                  forRemoveStatus:(BOOL)removeStatus
{
    CommentDetail *comment;
    comment = [comments objectAtIndex:index];
    CommentCell *cell = (CommentCell *) [tblTrends cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (removeStatus) {
        [cell.disLikeButton setEnabled:YES];
        [cell.likeButton setEnabled:YES];
        if (forLike) {
            comment.totalLike = [NSString stringWithFormat:@"%d", [comment.totalLike integerValue]-1];
            [cell.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            comment.ownLikeDisLikeStatus = @"0";
            cell.totalLikes.text = comment.totalLike;
        }
        else {
            comment.commentDisLike = [NSString stringWithFormat:@"%d", [comment.commentDisLike integerValue]-1];
            comment.ownLikeDisLikeStatus = @"0";
            [cell.disLikeButton setImage:[UIImage imageNamed:@"disLike"] forState:UIControlStateNormal];
            cell.totalDisLikes.text = comment.commentDisLike;
        }
    }
    else {
        if (forLike) {
            comment.totalLike = [NSString stringWithFormat:@"%d", [comment.totalLike integerValue]+1];
            [cell.likeButton setImage:[UIImage imageNamed:@"selfLiked"] forState:UIControlStateNormal];
            comment.ownLikeDisLikeStatus = @"1";
            cell.totalLikes.text = comment.totalLike;
            [cell.disLikeButton setEnabled:NO];
            [cell.likeButton setEnabled:YES];
        }
        else {
            comment.commentDisLike = [NSString stringWithFormat:@"%d", [comment.commentDisLike integerValue]+1];
            comment.ownLikeDisLikeStatus = @"-1";
            [cell.disLikeButton setImage:[UIImage imageNamed:@"selfDisliked"] forState:UIControlStateNormal];
            cell.totalDisLikes.text = comment.commentDisLike;
            [cell.disLikeButton setEnabled:YES];
            [cell.likeButton setEnabled:NO];
        }
    }
    [comments replaceObjectAtIndex:index withObject:comment];
    visiblePostDetail.commentDetailArray = comments;
}

#pragma mark - play video
- (IBAction)playVideo:(id)sender {
    isVideoPlaying = YES;
    MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL: [NSURL URLWithString: ((UIButton*)sender).accessibilityLabel ]];
    [self presentMoviePlayerViewControllerAnimated: moviePlayerViewController];
    [moviePlayerViewController.moviePlayer play];
}


#pragma mark - share post

- (IBAction)sharePost:(id)sender
{
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    ShowNetworkIndicator(YES);
    [service PostRequest:WSSHarePost parameters:[NSString stringWithFormat:@"post_id=%@&user_id=%@", visiblePostDetail.postId,[SessionDetail currentSession].userDetail.userId] customeobject:nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
        if (error) {
            [GlobalHelper dispToastMessage:[error.userInfo objectForKey:@"msg"]];
        }
        else {
            [GlobalHelper dispToastMessage:@"Post shared successfully!"];
        }
    }];
}

@end