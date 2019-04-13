//
//  XDXCameraHandler.h
//  XDXAVCaptureSession
//
//  Created by 李承阳 on 2019/4/6.
//  Copyright © 2019 小东邪. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XDXCameraHandlerDelegate <NSObject>

- (void)xdxCaptureOutput:(AVCaptureOutput *)output
   didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
          fromConnection:(AVCaptureConnection *)connection;

- (void)xdxCaptureOutput:(AVCaptureOutput *)output
     didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer
          fromConnection:(AVCaptureConnection *)connection;

@end

@class XDXCameraModel;

@interface XDXCameraHandler : NSObject

@property (nonatomic, assign) id<XDXCameraHandlerDelegate> delegate;
@property (nonatomic, strong) XDXCameraModel *cameraModel;

/**
 *  Please congiure camera param to use it at the first time.
 *  Then you could start / stop camera.
 */
- (void)startRunning;
- (void)stopRunning;
- (void)configureCameraWithModel:(XDXCameraModel *)model;

/**
 * Switch front / back camera
 * Note: If the device is not support current resolution / framerat after switching, we will auto reduce it's level.
 * For example :  Device: (iPhone X, Resolution: back camera max: 3840, back camera max: 1920), switch camera from back to front if the resolution is 4K, we should reset the device resolution to 2K.
 */
- (void)switchCamera;

/**
 * Set camera resolution (Support high frame rate)
 * @param height : height of the resolution
 */
- (void)setCameraResolutionByActiveFormatWithHeight:(int)height;

/**
 * Get camera max support resolution by current frame rate
 */
- (int)getMaxSupportResolutionByActiveFormat;

/**
 * Set camera frame rate (support high frame rate)
 * Note: the max support frame rate is different by different resolution.
 */
- (void)setCameraForHFRWithFrameRate:(int)frameRate;

/**
 * Get max support frame rate by current resolution
 */
- (int)getMaxFrameRateByCurrentResolution;


/**
 * Get camera ouput real time width and height
 */
- (int)getRealtimeResolutionHeight;
- (int)getRealtimeResolutionWidth;

/**
 * Get video fps for real time
 */
- (int)getCaputreViedeoFPS;

/**
 * Set focus point
 * @param point : coordinate of your view
 */
- (void)setFocusPoint:(CGPoint)point;

/**
 * Get max/min exposure value for camera.(-8 ~ 8)
 */
- (CGFloat)getMaxExposureValue;
- (CGFloat)getMinExposureValue;

/**
 * Set camera exposure value (-8 ~ 8)
 */
- (void)setExposureWithNewValue:(CGFloat)newExposureValue;

/**
 * Set open / close torch
 */
- (void)setTorchState:(BOOL)isOpen;

/**
 * Set video orientation by screen orientation
 */
- (void)adjustVideoOrientationByScreenOrientation:(UIDeviceOrientation)orientation;

/**
 * Set video gravity.
 * Note: If your video resolution == your screen resolution, the effect is the same.
 */
- (void)setVideoGravity:(AVLayerVideoGravity)videoGravity;

/**
 * Set white balance value by temperature or tint
 * temperature:-150~250 , tint: -150~150
 */
- (void)setWhiteBlanceValueByTint:(float)tint;
- (void)setWhiteBlanceValueByTemperature:(float)temperature;

@end

NS_ASSUME_NONNULL_END
