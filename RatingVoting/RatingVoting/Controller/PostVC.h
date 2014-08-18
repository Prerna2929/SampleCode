//
//  POSTVC.h
//  RatingVoting
//
//  Created by c85 on 09/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "BaseVC.h"
#import "SCRecorder.h"


@interface PostVC : BaseVC<SCRecorderDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIButton *recordButton;
    IBOutlet UIButton *stopButton;
    IBOutlet UIView *previewView;
    IBOutlet UILabel *timeRecordedLabel;
    IBOutlet UIView *downBar;
    IBOutlet UIButton *switchCameraModeButton;
    IBOutlet UIButton *capturePhotoButton;
    IBOutlet UIButton *btnGallery;
    IBOutlet UIButton *btnSearchUserForBattle;
    IBOutlet UIView *topView;
}

@end
