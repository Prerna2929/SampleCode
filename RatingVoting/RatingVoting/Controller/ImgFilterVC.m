//
//  ImgFilterVC.m
//  RatingVoting
//
//  Created by c85 on 11/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "ImgFilterVC.h"
#import "FilterCell.h"
#import "PostDetailVC.h"

@interface ImgFilterVC ()
@property (nonatomic, strong) NSArray *filters;
@property (nonatomic, strong) NSMutableArray *filteredImages;
@end

@implementation ImgFilterVC

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
    [self setNavigationBarItems];
    _imgNewPost.image = _photo;
    
    self.filters = @[@"Original",
                     @"CILinearToSRGBToneCurve",
                     @"CIPhotoEffectChrome",
                     @"CIPhotoEffectFade",
                     @"CIPhotoEffectInstant",
                     @"CIPhotoEffectMono",
                     @"CIPhotoEffectNoir",
                     @"CIPhotoEffectProcess",
                     @"CIPhotoEffectTonal",
                     @"CIPhotoEffectTransfer",
                     @"CISRGBToneCurveToLinear",
                     @"CIVignetteEffect",
                     @"CISepiaTone",
                     @"CIColorInvert",
                     @"CIFalseColor",
                     @"CIMaskToAlpha",
                     @"CIColorPosterize",
                     @"CIColorMonochrome"];
    activity.hidden = YES;
    [activity stopAnimating];
    colFilters.hidden = NO;
    [colFilters reloadData];
    _filteredImages = [[NSMutableArray alloc]init];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"Memory warning in Filter");
}

#pragma mark - navigation bar

-(void)setNavigationBarItems
{
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 2, 35, 35);
    btnLeft.backgroundColor = [UIColor clearColor];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(closeFilter:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 2, 60, 25);
    btnRight.backgroundColor = [UIColor clearColor];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"nextbtn"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = rightButton;
    
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"Next  >" style:UIBarButtonItemStylePlain target:self action:@selector(nextClick:)];
//    [rightButton setTintColor:[UIColor blackColor]];
//    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void)applyFiltersToImage
{
    if (_imgNewPost.image != nil) {
        
        activity.hidden = false;
        [activity startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            for (NSString *filterName in _filters) {
                
                if ([filterName isEqualToString:@"Original"]) {
                    [_filteredImages addObject:[UIImage imageNamed:@"picture"]];
                }
                else {
                    @autoreleasepool
                    {
                        CIImage *ciImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"picture"]];
                        
                        CIFilter *filter = [CIFilter filterWithName:filterName
                                                      keysAndValues:kCIInputImageKey, ciImage, nil];
                        [filter setDefaults];
                        
                        CIContext *context = [CIContext contextWithOptions:nil];
                        CIImage *outputImage = [filter outputImage];
                        CGImageRef cgImage = [context createCGImage:outputImage
                                                           fromRect:[outputImage extent]];
                        
                        [_filteredImages addObject:[UIImage imageWithCGImage:cgImage]];
                        CGImageRelease(cgImage);
                        ciImage = nil;
                        filter = nil;
                        context = nil;
                        outputImage = nil;
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:0.4 animations:^{
                    colFilters.hidden = false;
                    [colFilters reloadData];
                } completion:^(BOOL finished) {
                    [activity stopAnimating];
                }];
            });
        });
    }
    else {
        activity.hidden = true;
        colFilters.hidden = true;
    }
}

#pragma mark - User Action

-(IBAction)closeFilter:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)nextClick:(id)sender
{
    PostDetailVC *imgFilter = getVC(@"Post", @"idPostDetailVC");
    imgFilter.photo = _imgNewPost.image;
    [self.navigationController pushViewController:imgFilter animated:YES];
}

#pragma mark - collectionview delegate methods

-(void)addCollectionview
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(95, 95)];
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:0];
    [flowLayout setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
    
    [colFilters setCollectionViewLayout:flowLayout];
    [colFilters setAllowsSelection:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.filters.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FilterCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"filterCell" forIndexPath:indexPath];
    NSString *imageName = [NSString stringWithFormat:@"%@.png", [self.filters objectAtIndex:indexPath.row]];
    
    [cell1.imgFilter setImage:[UIImage imageNamed:imageName]];
    
    cell1.imgFilter.userInteractionEnabled = NO;
    cell1.lblFilterName.userInteractionEnabled = NO;
    cell1.lblFilterName.text = [self.filters objectAtIndex:indexPath.row];
    [cell1 setAccessibilityIdentifier:[self.filters objectAtIndex:indexPath.row]];
    return cell1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![[self.filters objectAtIndex:indexPath.row] isEqualToString:@"Original"])
    {
        UIImage *fixedImage = [self scaleAndRotateImage:_photo];
        
        CIImage *ciImage = [CIImage imageWithCGImage:fixedImage.CGImage];
        
        CIFilter *filter = [CIFilter filterWithName:[self.filters objectAtIndex:indexPath.row]
                                      keysAndValues:kCIInputImageKey, ciImage, nil];
        [filter setDefaults];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *outputImage = [filter outputImage];
        CGImageRef cgImage = [context createCGImage:outputImage
                                           fromRect:[outputImage extent]];
        
        _imgNewPost.image = [UIImage imageWithCGImage:cgImage];
        
        CGImageRelease(cgImage);
        ciImage = nil;
        filter = nil;
        context = nil;
        outputImage = nil;
    }
    else
    {
        _imgNewPost.image = _photo;
    }
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

@end