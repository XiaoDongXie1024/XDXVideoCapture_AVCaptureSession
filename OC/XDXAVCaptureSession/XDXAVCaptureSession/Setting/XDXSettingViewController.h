//
//  XDXSettingViewController.h
//  XDXAVCaptureSession
//
//  Created by 李承阳 on 2019/4/7.
//  Copyright © 2019 小东邪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XDXCameraHandler;

@interface XDXSettingViewController : UITableViewController

@property (nonatomic, strong) XDXCameraHandler *cameraHandler;

@end

NS_ASSUME_NONNULL_END
