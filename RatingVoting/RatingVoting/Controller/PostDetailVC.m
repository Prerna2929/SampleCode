//
//  PostDetailVC.m
//  RatingVoting
//
//  Created by c85 on 11/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "PostDetailVC.h"
#import "UIPlaceHolderTextView.h"
#import "SCPlayer.h"
#import "WebServiceParser.h"
#import "WebServiceParser+Post.h"
#import "AutoCompleteTableView.h"
#import "WebServiceParser+HashTag.h"
#import "WebServiceParser+Battle.h"
#import "UIViewController+MMDrawerController.h"
#import "TrendsVC.h"
#import "UIImage+ImageEffects.h"
#import "HashTagDetail.h"
#import "Base64.h"


@interface PostDetailVC ()<SCPlayerDelegate>
{
    SCPlayer *_player;
    BOOL isSharedAsAnonymous;
    NSMutableArray *hashTagArrayList ;
    
    IBOutlet UIPlaceHolderTextView *txtTag;
    IBOutlet UIPlaceHolderTextView *txtDescription;
    IBOutlet UIImageView *postImage;
    CGSize keyboardSize;
#pragma mark - TIToken
    TITokenFieldView * _tokenFieldView;
	UITextView * _messageView;
	NSString* anonymousCheck;
	CGFloat _keyboardHeight;
}

@end

@implementation PostDetailVC

#pragma mark - Class Methods

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
    [self setTableFooterView];
    self.title = @"Post";
    self.filterSwitcherView.filterGroups = @[
                                             [NSNull null],
                                             [SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CIPhotoEffectNoir"]],
                                             [SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CIPhotoEffectChrome"]],
                                             [SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CIPhotoEffectInstant"]],
                                             [SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CIPhotoEffectTonal"]],
                                             [SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CIPhotoEffectFade"]]
                                             ];
    
    _suggestionView.hidden = YES;
    _suggestionView._delegate = self;
    hashTagArrayList = [NSMutableArray new];
    
    [CacheData getcachedataArrayFor_:keyHashTagCache myMethod:^(BOOL finished, NSMutableArray *retrivedList)
                                         {
                                             if(finished){
                                                 [hashTagArrayList addObjectsFromArray:retrivedList];
                                             }
                                         }];
    
    
#pragma mark - keyboard height
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [self addbackButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - add back button

- (void) addbackButton
{
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 2, 35, 35);
    btnLeft.backgroundColor = [UIColor clearColor];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setTableFooterView
{
//    [tblDetail setTableFooterView:btnPost];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    txtTag.placeholder = @"#Tag";
    txtTag.delegate = self;
    
    txtDescription.placeholder = @"Description";
    
    if (_asset == nil)
    {
        postImage.hidden = NO;
        postImage.image = _photo;
        _filterSwitcherView.hidden = YES;
    }
    else
    {
        postImage.hidden = YES;
        _filterSwitcherView.hidden = NO;
        _filterSwitcherView.disabled = NO;
        _player = [SCPlayer player];
        _filterSwitcherView.player = _player;
        [_player setItemByAsset:self.asset];
        _player.shouldLoop = NO;
        [_player play];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    _player = nil;
    _filterSwitcherView.player = nil;
    [_player setItem:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    [service HastTagRequest:WSGetAllhashTag
                 parameters:nil
              customeobject:nil
                      block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
                       if (error) {
//                           [UIAlertView showWithTitle:AppName message:[error.userInfo objectForKey:@"msg"] cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                           }];
                       }
                       else {
                           if (objects != nil)
                           {
                               hashTagArrayList = [NSMutableArray new];
                               for (HashTagDetail *tag in objects)
                               {
                                   [hashTagArrayList addObject:tag.hashtag];
                               }
                               [CacheData setCacheToUserDefaults:hashTagArrayList ForKey:keyHashTagCache];
                           }
                       }
                   }];
}

#pragma mark - User Action

-(IBAction)postClick:(id)sender
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [GlobalHelper showHUDLoaderwithType:blackMask message:@"Please wait..."];
    }];
    
    if (_asset != nil)
    {
        [GlobalHelper convertVideoToLowQuailtyWithAsset:_asset outputURL:_videoName handler:^(AVAssetExportSession *export) {
            
            if (!export.error)
            {
                
                AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [DefaultsValues getStringValueFromUserDefaults_ForKey:VideoPath] ,_videoName]]];
                AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
                CMTime time = CMTimeMake(1, 1);
                CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
                UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
                
                CGImageRelease(imageRef);
                
                [self createPost : txtTag.text desctext:txtDescription.text mediaType:VideoType thumbNail:thumbnail];
            }
            else
            {
                [GlobalHelper showHUDLoaderwithType:errorMessage message:export.error.localizedDescription];
            }
        }];
    }
    else
    {
        [self createPost : txtTag.text desctext:txtDescription.text mediaType:ImageType thumbNail:nil];
    }
}

- (void) createHashtag : (NSString *) tags
{
    tags = [tags stringByReplacingOccurrencesOfString:@"#" withString:@","];
    
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    [service PostRequest:WSCreateHashtag
              parameters:[NSString stringWithFormat:@"user_id=%@&hashtag=%@",[SessionDetail currentSession].userDetail.userId, tags]
           customeobject:nil
                   block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
                       
                       if (error) {
                           [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
//                           [UIAlertView showWithTitle:AppName message:[error.userInfo objectForKey:@"msg"] cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                           }];
                       }
                       else {
                           [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                       }
                   }];
}

- (void) createPost : (NSString *) tags
           desctext : (NSString *) DesrtiptionText
          mediaType : (postMediaType) type
          thumbNail : (UIImage *) thumbImage
{
    [Base64 initialize];
    NSString *encodedMedia = nil;
    tags = [tags stringByReplacingOccurrencesOfString:@"#" withString:@","];
    
    NSMutableDictionary *setPostDict=[[NSMutableDictionary alloc]init];
    [setPostDict setValue:[SessionDetail currentSession].userDetail.userId forKey:@"user_id"];

    switch (type) {
        case ImageType:
        {
            NSData *imageData = [GlobalHelper imageComrassionFor:postImage.image];
            encodedMedia = [Base64 encode:imageData];
            [setPostDict setValue:encodedMedia forKey:@"post_image"];
        }
            break;
        case VideoType:
        {
            encodedMedia = [Base64 encode:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [DefaultsValues getStringValueFromUserDefaults_ForKey:VideoPath], _videoName]]]];
            
            NSData *thumbNailData = [GlobalHelper imageComrassionFor:thumbImage];
            NSString *encodedThumbNail = [Base64 encode:thumbNailData];
            
            [setPostDict setValue:encodedMedia forKey:@"post_video"];
            [setPostDict setValue:encodedThumbNail forKey:@"post_video_thumbnail"];
        }
            break;
        default:
            break;
    }
    
    [setPostDict setValue:DesrtiptionText forKey:@"post_text"];
    [setPostDict setValue:anonymousCheck forKey:@"anonymous"];
    [setPostDict setValue:tags forKey:@"hashtags"];
    
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    [service PostRequest:WSCreatePost
              parameters:nil
           customeobject:setPostDict
                   block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
                       ;
                       if (error) {
                           TRC_DBG(@"fail to post ");
                           [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                           [UIAlertView showWithTitle:AppName message:[error.userInfo objectForKey:@"msg"] cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                           }];
                       }
                       else
                       {
                           if (app.forBattleProcess)
                           {
                               [self createBattleForbattleID:app.globBattleID withPostID:responseString];
                           }
                           else
                           {
                               [SessionDetail currentSession].userDetail.totalPosting = [NSString stringWithFormat:@"%ld", [[SessionDetail currentSession].userDetail.totalPosting integerValue]+1];
                               
                               [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
                               
                               [self setDrawerController];
                           }
     
                           
                           
                           
                       }
                   }];
}

-(IBAction)anonymousClick:(id)sender
{
    UIButton *btnShare = (UIButton*)sender;
    
    if (isSharedAsAnonymous) {
        anonymousCheck = @"0";
        [btnShare setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }
    else {
        anonymousCheck = @"1";
        [btnShare setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    isSharedAsAnonymous = !isSharedAsAnonymous;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    return YES;
}

- (void) textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0)
    {
        if ([textView isKindOfClass:[UIPlaceHolderTextView class]])
        {
            NSArray *textToSearch = [textView.text componentsSeparatedByString:@" "];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",[textToSearch lastObject]];
            
            NSMutableArray *filteredArray = [NSMutableArray new];
            
            filteredArray   = [NSMutableArray arrayWithArray:[hashTagArrayList filteredArrayUsingPredicate:predicate]];
            
            if (filteredArray.count > 0)
            {
                [self setDDListHidden:NO forTextView:textView withFilteredArray:filteredArray];
            }
            else
            {
                [self setDDListHidden:YES forTextView:textView withFilteredArray:nil];
            }
        }
    }
    else
    {
        if ([textView isKindOfClass:[UIPlaceHolderTextView class]])
        {
            [self setDDListHidden:YES forTextView:textView withFilteredArray:nil];
        }
    }
}

- (void)keyboardShown:(NSNotification *)notification
{
    keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
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
        [_suggestionView setFrame:CGRectMake(0, CGRectGetMaxY(textVW.frame)-130, 320, CGRectGetHeight(self.view.frame)-(keyboardSize.height+90))];
        [UIView commitAnimations];
    }
}

#pragma mark -
#pragma mark PassValue protocol
- (void)passValue:(NSString *)value  wilthAssociateID:(NSString *)userId{
	if (value)
    {
        NSMutableArray *tags = [[txtTag.text componentsSeparatedByString:@" "] mutableCopy];
        [tags replaceObjectAtIndex:[tags count]-1 withObject:value];
        txtTag.text = [tags componentsJoinedByString:@" "];
        tags = nil;
        [self setDDListHidden:YES forTextView:nil withFilteredArray : nil];
	}
	else {
		
	}
}

- (void)getSelectedTag : (NSString *) value
{
    NSMutableArray *tags = [[txtTag.text componentsSeparatedByString:@" "] mutableCopy];
    [tags replaceObjectAtIndex:[tags count]-1 withObject:value];
    txtTag.text = [tags componentsJoinedByString:@" "];
    tags = nil;
    [self setDDListHidden:YES forTextView:nil withFilteredArray : nil];
}

- (void)tokenFieldFrameDidChange:(TITokenField *)tokenField {
	[self textViewDidChange:_messageView];
}

- (void)showContactsPicker:(id)sender {
	
	NSArray * names = hashTagArrayList;
	
	TIToken * token = [_tokenFieldView.tokenField addTokenWithTitle:[names objectAtIndex:(arc4random() % names.count)]];
	[token setAccessoryType:TITokenAccessoryTypeDisclosureIndicator];
	// If the size of the token might change, it's a good idea to layout again.
	[_tokenFieldView.tokenField layoutTokensAnimated:YES];
	
	NSUInteger tokenCount = _tokenFieldView.tokenField.tokens.count;
	[token setTintColor:((tokenCount % 3) == 0 ? [TIToken redTintColor] : ((tokenCount % 2) == 0 ? [TIToken greenTintColor] : [TIToken blueTintColor]))];
}

- (void)tokenFieldChangedEditing:(TITokenField *)tokenField {
	// There's some kind of annoying bug where UITextFieldViewModeWhile/UnlessEditing doesn't do anything.
	[tokenField setRightViewMode:(tokenField.editing ? UITextFieldViewModeAlways : UITextFieldViewModeNever)];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	
	CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	_keyboardHeight = keyboardRect.size.height > keyboardRect.size.width ? keyboardRect.size.width : keyboardRect.size.height;
	[self resizeViews];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	_keyboardHeight = 0;
	[self resizeViews];
}

- (void)resizeViews {
    int tabBarOffset = self.tabBarController == nil ?  0 : self.tabBarController.tabBar.frame.size.height;
	[_tokenFieldView setFrame:((CGRect){_tokenFieldView.frame.origin, {self.view.bounds.size.width, self.view.bounds.size.height + tabBarOffset - _keyboardHeight}})];
	[_messageView setFrame:_tokenFieldView.contentView.bounds];
}

- (BOOL)tokenField:(TITokenField *)tokenField willRemoveToken:(TIToken *)token {
	
	if ([token.title isEqualToString:@"Tom Irving"]){
		return NO;
	}
	
	return YES;
}

#pragma mark - create battle WS

-(void) createBattleForbattleID : (NSString *) battle_id
                     withPostID : (NSString *) post_id
{
    WebServiceParser *service = [WebServiceParser sharedMediaServer];
    
    [service BattleService:WSCreateBattle parameters:[NSString stringWithFormat:@"user_id=%@&post_id=%@&battle_id=%@&notification_id=%@", [SessionDetail currentSession].userDetail.userId, post_id, battle_id, app.globNotificationID] customeobject:Nil block:^(NSError *error, id objects, NSString *responseString, NSString *nextUrl) {
        if (error) {
            [UIAlertView showWithTitle:AppName message:[error.userInfo objectForKey:@"msg"] cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        }
        else
        {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:notificationReloadNotificationTable
             object:self];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:notificationCloseCameraView
             object:self];
            
            [GlobalHelper showHUDLoaderwithType:hideLoader message:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}
@end