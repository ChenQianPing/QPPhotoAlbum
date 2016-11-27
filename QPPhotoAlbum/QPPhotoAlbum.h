//
//  QPPhotoAlbum.h
//  QPPhotoAlbumDemo
//
//  Created by ChenQianPing on 16/11/27.
//  Copyright © 2016年 ChenQianPing. All rights reserved.
//


/*!
 iOS中本地图片库封装、相机调用封装库
 封装相册选择器UIImagePickerController
 
 在iOS中选择图片这个任务是通过UIImagePickerController来实现的,
 通过设置sourceType来决定是从相册选取还是拍照,
 当前的视图控制器需要实现UIImagePickerControllerDelegate协议的方法.
 
 
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^PhotoBlock)(UIImage *image);

@interface QPPhotoAlbum : NSObject

- (void)getPhotoAlbumOrTakeAPhotoWithController:(UIViewController *)Controller
                                   andWithBlock:(PhotoBlock)photoBlock;

@end
