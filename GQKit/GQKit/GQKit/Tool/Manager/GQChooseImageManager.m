//
//  GQChooseImageManager.m
//  GQKit
//
//  Created by Apple on 3/10/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "GQChooseImageManager.h"
#import "TZImagePickerController.h"
#import <AVFoundation/AVFoundation.h>
#import <TOCropViewController.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "GQActionSheetView.h"
#import "GQKit.h"
@interface GQChooseImageManager()<TZImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,TOCropViewControllerDelegate>
@property(nonatomic, weak) UIViewController *showVc; // 此处要用weak

@property(nonatomic, strong) UIImagePickerController *ipc;

@end
@implementation GQChooseImageManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gq_needPicture = YES;
    }
    return self;
}
- (void)gq_chooseImageShowInViewController:(UIViewController *)vc {
    NSMutableArray *actionArr = [NSMutableArray new];
    if (self.gq_needPicture) {
        [actionArr addObject:@"照相"];
    }
    if (self.gq_needVideo) {
        [actionArr addObject:@"录视频"];
    }
    [actionArr addObject:@"打开相册"];
    GQActionSheetView *action = [[GQActionSheetView alloc] gq_initWithTitles:actionArr withCancleTitle:@"取消" cancelColor:GQ_BlueColor];
    action.gq_exampleView = self.gq_exampleView;
    action.gq_exampleViewH = self.gq_exampleViewH;
    __weak __typeof(self) weakSelf = self;
    action.gq_chooseBlock = ^(NSString *text, NSInteger idx) {
        if (idx== 0) {
            [weakSelf openCamera:YES];
        } else if (idx == 1) {
            [weakSelf openCamera:NO];
        } else if (idx== 2){
            [weakSelf openAlbum];
        }
    };
    [action gq_show];
    self.showVc = vc;
}

- (void)openCamera:(BOOL)takePhone {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied) {
            GQAlertController *ale = [GQAlertController gq_alertWithMessage:@"请在设备的\"设置-隐私-相机\"中允许访问相机。" buttonTitle:nil buttonsColor:nil completion:^(NSInteger clickedButtonTag) {
                if (clickedButtonTag == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
            [ale gq_showInController:self.showVc];
            return;
        }
        if (takePhone == NO) {
            self.ipc.mediaTypes = @[(NSString *)kUTTypeMovie];
            self.ipc.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
        self.ipc.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
        }  else {
            self.ipc.mediaTypes = @[(NSString *)kUTTypeImage];
        }
        [self.showVc presentViewController:self.ipc animated:YES completion:nil];
        
    } else {
    }
}

- (void)openAlbum {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [self.showVc presentViewController:imagePickerVc animated:YES completion:nil];
    } else {
        GQAlertController *ale = [GQAlertController gq_alertWithMessage:@"请在设备的\"设置-隐私-照片\"中允许访问相册。" buttonTitle:nil buttonsColor:nil completion:^(NSInteger clickedButtonTag) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [ale gq_show];
    }
}

#pragma mark - UIImagePickerControllerDelegate
//相机选的图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *urlStr = [url path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
//            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
        }
        [self.showVc dismissViewControllerAnimated:YES completion:^{
            if (self.gq_chooseVideoBlock) {
                self.gq_chooseVideoBlock(nil, url, [NSData dataWithContentsOfURL:url]);
            }
        }];
    } else {
        if (self.gq_needCrop) {
            [picker presentViewController:[self showCropControllerWithImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]] animated:YES completion:nil];
        } else {
            [self.showVc dismissViewControllerAnimated:YES completion:^{
                if (self.gq_chooseImageBlock) {
                    self.gq_chooseImageBlock([info objectForKey:@"UIImagePickerControllerOriginalImage"]);
                }
            }];
        }
    }
}
//取消按钮
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picke {
    [self.showVc dismissViewControllerAnimated:YES completion:nil];
}
// 相册选的图片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if (self.gq_needPicture == NO) {
        [GQ_Hud gq_showMessage:@"不支持选择相片"];
        return;
    }
    if (self.gq_needCrop) {
        if (photos.count > 0) {
            [self.showVc presentViewController:[self showCropControllerWithImage:photos.firstObject] animated:YES completion:nil];
        }
    } else {
        if (self.gq_chooseImageBlock) {
            self.gq_chooseImageBlock(photos.firstObject);
        }
        [self.showVc dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingVideo:(UIImage *)coverImage
                sourceAssets:(PHAsset *)asset{
    if (self.gq_needVideo == NO) {
        [GQ_Hud gq_showMessage:@"不支持选择视频"];
        return;
    }
    if (self.gq_chooseVideoBlock) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset1, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset1;
            
            NSURL *url = urlAsset.URL;
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            self.gq_chooseVideoBlock(asset, url, data);
        }];
        
    }
}


- (UIImagePickerController *)ipc {
    if (_ipc == nil) {
        _ipc = [[UIImagePickerController alloc] init];
        _ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        _ipc.delegate = self;
    }
    return _ipc;
}

#pragma mark - TOCropViewController
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    if (self.gq_chooseImageBlock) {
        self.gq_chooseImageBlock(image);
    }
    [self.showVc dismissViewControllerAnimated:YES completion:nil];
}
- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [_ipc dismissViewControllerAnimated:YES completion:nil];
    [self.showVc dismissViewControllerAnimated:YES completion:nil];
}
- (TOCropViewController *)showCropControllerWithImage:(UIImage *)img {
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:img];
    cropController.doneButtonTitle = @"确定";
    cropController.cancelButtonTitle = @"取消";
    cropController.aspectRatioPickerButtonHidden = YES;
    cropController.delegate = self;
    cropController.customAspectRatio = CGSizeMake(1, 1);
    if (self.gq_customAspectRatio.width > 0 && self.gq_customAspectRatio.height > 0) {
        cropController.customAspectRatio = self.gq_customAspectRatio;
    }
    return cropController;
}
@end
