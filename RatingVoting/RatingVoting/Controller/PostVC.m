//
//  POSTVC.m
//  RatingVoting
//
//  Created by c85 on 09/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "PostVC.h"
#import "ImgFilterVC.h"
#import "PostDetailVC.h"
#import "MainTabBarVC.h"
#import "Base64.h"

#import "SCTouchDetector.h"
#import "SCAudioTools.h"
#import "SCRecorderFocusView.h"
#import "SCRecorder.h"

#import "SCCameraFocusTargetView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
    PhotoSessionMode,
    VideoSessionMode
}cameraSessionMode;

#define kVideoPreset AVCaptureSessionPresetHigh

@interface PostVC ()
{
    UIImage *newCapturedImage;
    AVAsset *newAsset;
    NSURL *recordedVideoURL;
    SCRecorder *_recorder;
    cameraSessionMode curSessionMode;
    
#pragma mark - For reset cam
    BOOL isGalleryOpened;
}
@property (strong, nonatomic) SCRecorderFocusView *focusView;

@end

@implementation PostVC

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0

- (UIStatusBarStyle) preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

#endif

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
    [self setAVCAptureView];
    [self setNavigationBarItems];
    curSessionMode = PhotoSessionMode;
    isGalleryOpened=NO;
    [downBar setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [topView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
    btnSearchUserForBattle.hidden = app.forBattleProcess ? YES : NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeCameraView:)
                                                 name:notificationCloseCameraView
                                               object:nil];
    
    [self retriveLastImageFromGallery];
 
    [previewView setFrame:app.window.frame];
    
    app.needToCallCenterWillApper = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    if (!isGalleryOpened)
    {
        timeRecordedLabel.text = @"0.0 Sec";
        [self setAVCAptureView];
    }
    self.view.frame = app.window.bounds;
    previewView.frame = self.view.frame;
    downBar.frame = (CGRect) {.origin = {downBar.frame.origin.x, CGRectGetMaxY(self.view.frame) - downBar.frame.size.height},.size = downBar.frame.size};
}

- (void) retriveLastImageFromGallery {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // Chooses the photo at the last index
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            
            // The end of the enumeration is signaled by asset == nil.
            if (alAsset) {
                ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                
                [btnGallery setImage:latestPhoto forState:UIControlStateNormal];
                btnGallery.imageView.contentMode = UIViewContentModeScaleAspectFit;
                latestPhoto = nil;
                
                // Stop the enumerations
                *stop = YES; *innerStop = YES;
                
                
            }
        }];
    } failureBlock: ^(NSError *error) {
        // Typically you should handle an error more gracefully than this.
        TRC_DBG(@"No groups");
    }];
}


#pragma mark - Others

-(void)setNavigationBarItems
{
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 2, 35, 35);
    btnLeft.backgroundColor = [UIColor clearColor];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(closeCamera:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 2, 60, 25);
    btnRight.backgroundColor = [UIColor clearColor];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"nextbtn"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = rightButton;
}

#pragma mark - create battle

- (IBAction)createBattle:(id)sender {
    
}


#pragma mark - User Action

-(IBAction)closeCamera:(id)sender
{
    if (app.forBattleProcess) {
        [self dismissViewControllerAnimated:YES completion:^{
            app.forBattleProcess = NO;
            app.globBattleID = @"";
            app.globNotificationID = @"";
        }];
    }
    else {
        MainTabBarVC *tabbarVC = [[app.leftNavController viewControllers] objectAtIndex:0];
        tabbarVC.selectedIndex = 0;
    }
}

-(IBAction)nextClick:(id)sender
{
    isGalleryOpened=NO;
    btnGallery.enabled = YES;
    capturePhotoButton.enabled = YES;
    if (curSessionMode == PhotoSessionMode) {
        ImgFilterVC *imgFilter = getVC(@"Post", @"idImgFilterVC");
        imgFilter.photo = newCapturedImage;
        [self.navigationController pushViewController:imgFilter animated:YES];
    }
    else {
        stopButton.hidden = YES;
        recordButton.hidden = NO;
        PostDetailVC *imgFilter = getVC(@"Post", @"idPostDetailVC");
        imgFilter.asset = newAsset;
        imgFilter.videoName = [recordedVideoURL lastPathComponent];
        [self.navigationController pushViewController:imgFilter animated:YES];
    }
}

#pragma mark - ImagePicker Methods

-(IBAction)chooseFromGallery:(id)sender
{
    isGalleryOpened=YES;
    curSessionMode = PhotoSessionMode;
    [self addNewPicFromViewController:self usingDelegate:self];
}

-(BOOL)addNewPicFromViewController:(UIViewController*)controller usingDelegate:(id )delegate {
    
    app.needToCallCenterWillApper = NO;
    
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = delegate;
    
    [controller presentViewController:mediaUI animated:YES completion:nil];
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    newCapturedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self nextClick:nil];
}

#pragma mark - Custom Camera

-(void)setAVCAptureView
{
    _recorder = [SCRecorder recorder];
    _recorder.sessionPreset = AVCaptureSessionPreset1280x720;
    _recorder.audioEnabled = YES;
    _recorder.delegate = self;
    
    _recorder.previewView = previewView;
    
    self.focusView = [[SCRecorderFocusView alloc] initWithFrame:previewView.bounds];
    self.focusView.recorder = _recorder;
    [previewView addSubview:self.focusView];
    
    self.focusView.outsideFocusTargetImage = [UIImage imageNamed:@"capture_flip"];
    self.focusView.insideFocusTargetImage = [UIImage imageNamed:@"capture_flip"];
    
    [_recorder openSession:^(NSError *sessionError, NSError *audioError, NSError *videoError, NSError *photoError) {
        NSLog(@"==== Opened session ====");
        NSLog(@"Session error: %@", sessionError.description);
        NSLog(@"Audio error : %@", audioError.description);
        NSLog(@"Video error: %@", videoError.description);
        NSLog(@"Photo error: %@", photoError.description);
        NSLog(@"=======================");
        [self prepareCamera];
    }];
}


- (void)recorder:(SCRecorder *)recorder didReconfigureAudioInput:(NSError *)audioInputError {
    NSLog(@"Reconfigured audio input: %@", audioInputError);
}

- (void)recorder:(SCRecorder *)recorder didReconfigureVideoInput:(NSError *)videoInputError {
    NSLog(@"Reconfigured video input: %@", videoInputError);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_recorder.isCaptureSessionOpened) {
        [_recorder startRunningSession:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    
    [_recorder endRunningSession];
}

- (void)updateLabelForSecond:(Float64)totalRecorded {
    timeRecordedLabel.text = [NSString stringWithFormat:@"%.2f Sec", totalRecorded];
}

// Focus
- (void)recorderDidStartFocus:(SCRecorder *)recorder {
    [self.focusView showFocusAnimation];
}

- (void)recorderDidEndFocus:(SCRecorder *)recorder {
    [self.focusView hideFocusAnimation];
}

- (void)recorderWillStartFocus:(SCRecorder *)recorder {
    [self.focusView showFocusAnimation];
}

#pragma mark - Handle

- (void)showAlertViewWithTitle:(NSString*)title message:(NSString*) message {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (void)showVideo:(AVAsset*)asset assetUrl : (NSURL *) url
{
    newAsset = asset;
    if (newAsset)
    {
        recordedVideoURL = url;
        [self nextClick:nil];
    }
}

- (void)showPhoto:(UIImage *)photo
{
    newCapturedImage = photo;
    [self nextClick:nil];
}

- (void) handleReverseCameraTapped:(id)sender
{
	[_recorder switchCaptureDevices];
}

- (void) handleStopButtonTapped:(id)sender
{
    SCRecordSession *recordSession = _recorder.recordSession;
    
    if (recordSession != nil) {
        [self finishSession:recordSession];
    }
}

- (void)finishSession:(SCRecordSession *)recordSession
{
    _recorder.recordSession = nil;
    [recordSession endRecordSegment:^(NSInteger segmentIndex, NSError *error) {
        //        [recordSession saveToCameraRoll];
        [self showVideo:recordSession.assetRepresentingRecordSegments assetUrl:recordSession.outputUrl];
//        [self prepareCamera];
    }];
}

- (void) handleRetakeButtonTapped:(id)sender
{
    SCRecordSession *recordSession = _recorder.recordSession;
    
    if (recordSession != nil) {
        _recorder.recordSession = nil;
        [recordSession cancelSession:nil];
    }
    
	[self prepareCamera];
    [self updateLabelForSecond:0];
}


- (IBAction)switchFlash:(id)sender
{
    NSString *flashModeString = nil;
    if ([_recorder.sessionPreset isEqualToString:AVCaptureSessionPresetPhoto]) {
        switch (_recorder.flashMode) {
            case SCFlashModeAuto:
                flashModeString = @"Flash : Off";
                _recorder.flashMode = SCFlashModeOff;
                break;
            case SCFlashModeOff:
                flashModeString = @"Flash : On";
                _recorder.flashMode = SCFlashModeOn;
                break;
            case SCFlashModeOn:
                flashModeString = @"Flash : Light";
                _recorder.flashMode = SCFlashModeLight;
                break;
            case SCFlashModeLight:
                flashModeString = @"Flash : Auto";
                _recorder.flashMode = SCFlashModeAuto;
                break;
            default:
                break;
        }
    } else {
        switch (_recorder.flashMode) {
            case SCFlashModeOff:
                flashModeString = @"Flash : On";
                _recorder.flashMode = SCFlashModeLight;
                break;
            case SCFlashModeLight:
                flashModeString = @"Flash : Off";
                _recorder.flashMode = SCFlashModeOff;
                break;
            default:
                break;
        }
    }
}

- (void) prepareCamera {
    if (_recorder.recordSession == nil) {
        
        SCRecordSession *session = [SCRecordSession recordSession];
        session.suggestedMaxRecordDuration = CMTimeMakeWithSeconds(10, 10000);
        
        _recorder.recordSession = session;
    }
}

- (void)recorder:(SCRecorder *)recorder didCompleteRecordSession:(SCRecordSession *)recordSession {
    [self finishSession:recordSession];
}

- (void)recorder:(SCRecorder *)recorder didInitializeAudioInRecordSession:(SCRecordSession *)recordSession error:(NSError *)error {
    if (error == nil) {
        NSLog(@"Initialized audio in record session");
    } else {
        NSLog(@"Failed to initialize audio in record session: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didInitializeVideoInRecordSession:(SCRecordSession *)recordSession error:(NSError *)error {
    if (error == nil) {
        NSLog(@"Initialized video in record session");
    } else {
        NSLog(@"Failed to initialize video in record session: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didBeginRecordSegment:(SCRecordSession *)recordSession error:(NSError *)error {
    NSLog(@"Began record segment: %@", error);
}

- (void)recorder:(SCRecorder *)recorder didEndRecordSegment:(SCRecordSession *)recordSession segmentIndex:(NSInteger)segmentIndex error:(NSError *)error {
    NSLog(@"End record segment %d: %@", (int)segmentIndex, error);
}

- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBuffer:(SCRecordSession *)recordSession {
    timeRecordedLabel.text = [NSString stringWithFormat:@"%.2f Sec", CMTimeGetSeconds(recordSession.currentRecordDuration)];
}

- (void)handleTouchDetected:(SCTouchDetector*)touchDetector
{
    if (touchDetector.state == UIGestureRecognizerStateBegan) {
        [_recorder record];
    } else if (touchDetector.state == UIGestureRecognizerStateEnded) {
        [_recorder pause];
    }
}

#pragma mark - User Action

- (IBAction)capturePhoto:(id)sender
{
    curSessionMode = PhotoSessionMode;
    [_recorder capturePhoto:^(NSError *error, UIImage *image) {
        if (image != nil) {
            [self showPhoto:image];
        } else {
            [self showAlertViewWithTitle:@"Failed to capture photo" message:error.localizedDescription];
        }
    }];
}

- (IBAction)startVideoRecordMode:(id)sender
{
    curSessionMode = VideoSessionMode;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        stopButton.hidden = false;
        recordButton.hidden = true;
        capturePhotoButton.enabled = NO;
        btnGallery.enabled = NO;
    } completion:^(BOOL finished) {
        _recorder.sessionPreset = kVideoPreset;
        _recorder.flashMode = SCFlashModeOff;
        
        [self performSelector:@selector(recordVideo) withObject:nil afterDelay:0.2];
    }];
}

-(void)recordVideo
{
    [_recorder record];
}

- (IBAction)startPhotoCaptureMode:(id)sender
{
    curSessionMode = PhotoSessionMode;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        capturePhotoButton.hidden = false;
//        switchCameraModeButton.hidden = true;
        stopButton.hidden = true;
        recordButton.hidden = false;
//        self.recordButton.alpha = 0.0;
//        self.retakeButton.alpha = 0.0;
//        self.stopButton.alpha = 0.0;
//        self.capturePhotoButton.alpha = 1.0;
    } completion:^(BOOL finished) {
        _recorder.sessionPreset = AVCaptureSessionPresetPhoto;
        _recorder.flashMode = SCFlashModeAuto;
    }];
}

-(IBAction)stopRecordClick:(id)sender
{
    stopButton.hidden = YES;
    recordButton.hidden = NO;
    [self handleStopButtonTapped:sender];
}

- (IBAction)handleReverseCamera{
	[_recorder switchCaptureDevices];
}

#pragma mark - received notification to close camera
- (void) closeCameraView:(NSNotification *) notification {
    app.needToCallCenterWillApper = NO;
    [self dismissViewControllerAnimated:YES completion:^{
        app.forBattleProcess = NO;
        app.globBattleID = @"";
        app.globNotificationID = @"";
    }];
}


@end
