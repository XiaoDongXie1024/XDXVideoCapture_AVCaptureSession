//
//  XDXCameraHandler.h
//  XDXAVCaptureSession
//
//  Created by 李承阳 on 2019/4/6.
//  Copyright © 2019 小东邪. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XDXCameraHandlerDelegate <NSObject>

- (void)xdxCaptureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;
- (void)xdxCaptureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;

@end

@class XDXCameraModel;

@interface XDXCameraHandler : NSObject

@property (nonatomic, assign) id<XDXCameraHandlerDelegate> delegate;
@property (nonatomic, strong) XDXCameraModel *cameraModel;

- (void)configureCameraWithModel:(XDXCameraModel *)model;

- (void)startRunning;
- (void)stopRunning;


/**
 * Switch front / back camera
 */
- (void)switchCamera;


/**
 * Set camera resolution (Support high frame rate)
 */
- (void)setCameraResolutionByActiveFormatWithHeight:(int)height;


/**
 * Get camera max support resolution by current frame rate
 */
- (int)getMaxSupportResolutionByActiveFormat;


/**
 * Suport high frame rate
 */
- (void)setCameraForHFRWithFrameRate:(int)frameRate;


/**
 * Get max support frame rate by current resolution
 */
- (int)getMaxFrameRateByCurrentResolution;


/**
 * Get video fps for real time
 */
- (int)getCaputreViedeoFPS;


/**
 * Set focus point
 */
- (void)setFocusPoint:(CGPoint)point;


/**
 * Get max/min exposure value for camera.
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
@end

NS_ASSUME_NONNULL_END
