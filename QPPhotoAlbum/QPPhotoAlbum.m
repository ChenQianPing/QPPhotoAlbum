//
//  QPPhotoAlbum.m
//  QPPhotoAlbumDemo
//
//  Created by ChenQianPing on 16/11/27.
//  Copyright © 2016年 ChenQianPing. All rights reserved.
//

#import "QPPhotoAlbum.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define ScreenF [UIScreen mainScreen].bounds
#define ScreenW ScreenF.size.width
#define ScreenH ScreenF.size.height
#define IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

@interface QPPhotoAlbum() <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, copy) PhotoBlock photoBlock;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIViewController        *viewController;

@end

@implementation QPPhotoAlbum

- (instancetype)init {
    self = [super init];
    if (self) {
        _picker = [[UIImagePickerController alloc] init];
    }
    return self;
}

- (void)getPhotoAlbumOrTakeAPhotoWithController:(UIViewController *)viewController andWithBlock:(PhotoBlock)photoBlock {
    self.photoBlock = photoBlock;
    self.viewController = viewController;
    
    /*!
     对系统判断,区分使用UIAlertController还是UIActionSheet进行提示选择.
     判断当前机型是否支持拍照功能。
     */
    
    if (IOS8) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择图像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *photoAlbumAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getAlertActionType:1];
        }];
        
        UIAlertAction *cemeraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getAlertActionType:2];
        }];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self getAlertActionType:0];
        }];
        
        /*!
         判断硬件是否支持拍照
         */
        if ([self imagePickerControlerIsAvailabelToCamera]) {
            [alertController addAction:cemeraAction];
        }
        
        [alertController addAction:photoAlbumAction];
        [alertController addAction:cancleAction];
        

        [self.viewController presentViewController:alertController animated:YES completion:nil];
        
    } else {
        UIActionSheet *actionSheet;
        if([self imagePickerControlerIsAvailabelToCamera]){
            actionSheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选取", nil];
        }else{
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取", nil];
        }
        [actionSheet showInView:self.viewController.view];
    }
}

/*!
 根据上面的判断创建UIImagePickerController
 */
- (void)getAlertActionType:(NSInteger)type {
    NSInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    switch (type) {
        case 1:
        {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
            break;
        case 2:
        {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
            break;
        case 0:
        {
            return;
        }
            break;
            
        default:
            break;
    }
    [self creatUIImagePickerControllerWithAlertActionType:sourceType];
    
}

#pragma mark - ActionSheet Delegte
- (void)actionSheet:(UIActionSheet *)actionSheetn clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if([self imagePickerControlerIsAvailabelToCamera]){
        switch (buttonIndex){
            case 0:
            {
                sourceType = UIImagePickerControllerSourceTypeCamera;
            }
                break;
            case 1:
            {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
            }
                break;
            case 2:
                return;
        }
    } else {
        switch (buttonIndex) {
            case 0:
            {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
                break;
                
            default:
                break;
        }
    }
    [self creatUIImagePickerControllerWithAlertActionType:sourceType];
}

#pragma mark -  创建ImagePickerController

/*!
 创建UIImagePickerController并对当前系统授权进行判断
 
 @param type sourceType  0 摄像头,1 相册
 
 */
- (void)creatUIImagePickerControllerWithAlertActionType:(NSInteger)type {
    NSInteger sourceType = type;
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        if (![self AVAuthorizationStatusIsGranted]) {
            if (IOS8) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"相机未授权" message:@"请到设置-隐私-相机中修改" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    return;
                }];
                [alertController addAction:comfirmAction];
                [self.viewController presentViewController:alertController animated:YES completion:nil];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"相机未授权" message:@"请到设置-隐私-相机中修改" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
    }
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;          // 设置代理
    self.picker.allowsEditing = YES;      // 允许编辑
    self.picker.sourceType = sourceType;  // 设置image picker的来源
    [self.viewController presentViewController:self.picker animated:YES completion:nil];
}

#pragma mark - 判断硬件是否支持拍照
- (BOOL)imagePickerControlerIsAvailabelToCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 照机授权判断
- (BOOL)AVAuthorizationStatusIsGranted  {
    __block BOOL isGranted = NO;
    // 判断是否授权相机
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    switch (authStatus) {
        case 0: { // 第一次使用,则会弹出是否打开权限
            [AVCaptureDevice requestAccessForMediaType : AVMediaTypeVideo completionHandler:^(BOOL granted) {
                // 授权成功
                if (granted) {
                    isGranted = YES;
                }
                else{
                    isGranted = NO;
                }
            }];
        }
            break;
        case 1:{
            // 还未授权
            isGranted = NO;
        }
            break;
        case 2:{
            // 主动拒绝授权
            isGranted = NO;
        }
            break;
        case 3: {
            // 已授权
            isGranted = YES;
        }
            break;
            
        default:
            break;
    }
    return isGranted;
}

#pragma mark - UIImagePickerControllerDelegate

/*!
 实现代理，将选中照片回调
 
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 获取编辑后的图片
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    NSLog(@"DELEGATE %@",image);
    if (self.photoBlock) {
        self.photoBlock(image);
    }
    [_picker dismissViewControllerAnimated:YES completion:nil];
}

// 取消选择照片:
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"取消图片选择");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

@end
