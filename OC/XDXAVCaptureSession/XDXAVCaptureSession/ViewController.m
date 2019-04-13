//
//  ViewController.m
//  XDXAVCaptureSession
//
//  Created by 李承阳 on 2019/4/2.
//  Copyright © 2019 小东邪. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "XDXCameraModel.h"
#import "XDXCameraHandler.h"
#import "XDXSettingViewController.h"
#import "XDXAdjustFocusView.h"

@interface ViewController ()<XDXCameraHandlerDelegate>

@property (nonatomic, strong) XDXCameraHandler              *cameraHandler;
@property (nonatomic, strong) XDXSettingViewController      *settingVC;

/************************ UI *********************************/
@property (nonatomic, strong) XDXAdjustFocusView            *focusView;
@property (weak, nonatomic) IBOutlet UISlider               *exposureSlider;
@property (weak, nonatomic) IBOutlet UIVisualEffectView     *exposureView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView     *whiteBalanceView;
@property (weak, nonatomic) IBOutlet UILabel                *resolutionLb;
@property (weak, nonatomic) IBOutlet UILabel                *fpsLb;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureCamera];
    [self configureData];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Init
- (void)configureCamera {
    XDXCameraModel *model = [[XDXCameraModel alloc] initWithPreviewView:self.view
                                                                 preset:AVCaptureSessionPreset1280x720
                                                              frameRate:30
                                                       resolutionHeight:720
                                                            videoFormat:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
                                                              torchMode:AVCaptureTorchModeOff
                                                              focusMode:AVCaptureFocusModeLocked
                                                           exposureMode:AVCaptureExposureModeContinuousAutoExposure
                                                              flashMode:AVCaptureFlashModeAuto
                                                       whiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance
                                                               position:AVCaptureDevicePositionBack
                                                           videoGravity:AVLayerVideoGravityResizeAspect
                                                       videoOrientation:AVCaptureVideoOrientationLandscapeRight
                                             isEnableVideoStabilization:YES];
    
    XDXCameraHandler *handler   = [[XDXCameraHandler alloc] init];
    self.cameraHandler          = handler;
    handler.delegate            = self;
    [handler configureCameraWithModel:model];
    [handler startRunning];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveResolutionChanged:)
                                                 name:kNotifyResolutionChanged
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveFrameRateChanged:)
                                                 name:kNotifyFrameRateChanged
                                               object:nil];
}

- (void)configureData {
    self.settingVC = [[XDXSettingViewController alloc] init];
}

#pragma mark - UI
- (void)setupUI {
    // Gesture
    UITapGestureRecognizer *singleClickGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(handleSingleClickGesture:)];
    [self.view addGestureRecognizer:singleClickGestureRecognizer];
    
    // Orientation
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    // Focus View
    XDXAdjustFocusView *focusView = [[XDXAdjustFocusView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.focusView                = focusView;
    focusView.hidden              = YES;
    [self.view addSubview:focusView];
    
    // Exposure slider
    [self.cameraHandler setExposureWithNewValue:0];
    self.exposureSlider.maximumValue = [self.cameraHandler getMaxExposureValue];
    self.exposureSlider.minimumValue = [self.cameraHandler getMinExposureValue];
    self.exposureSlider.value = 0;
    [self.exposureSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
//    NSLog(@"max:%f,min:%f",self.exposureSlider.maximumValue,self.exposureSlider.minimumValue);
    
    [self.view bringSubviewToFront:self.exposureView];
    [self.view bringSubviewToFront:self.whiteBalanceView];
    
    [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        self.fpsLb.text = [NSString stringWithFormat:@"%d",[self.cameraHandler getCaputreViedeoFPS]];
        self.resolutionLb.text = [NSString stringWithFormat:@"w:%d,h:%d",[self.cameraHandler getRealtimeResolutionWidth], [self.cameraHandler getRealtimeResolutionHeight]];
    }];
}

#pragma mark - Gesture
- (void)handleSingleClickGesture:(UITapGestureRecognizer *)recognizer  {
    CGPoint tapPoint = [recognizer locationInView:recognizer.view];

    [self.focusView setFrameByAnimateWithCenter:tapPoint];
    [self.cameraHandler setFocusPoint:tapPoint];
}

#pragma mark - Button Action
- (IBAction)switchCameraDidClicked:(id)sender {
    [self.cameraHandler switchCamera]; 
}

- (IBAction)settingBtnDidClicked:(id)sender {
    self.settingVC.cameraHandler = self.cameraHandler;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:self.settingVC] animated:YES completion:nil];
}

- (void)sliderValueChanged:(UISlider *)slider {
    [self.cameraHandler setExposureWithNewValue:slider.value];
}

- (IBAction)torchBtnDidClicked:(UIButton *)button {
    button.selected = !button.isSelected;
    [self.cameraHandler setTorchState:button.selected];
}

- (IBAction)videoGravityBtnDidClicked:(id)sender {
    static int i = 0;
    i++;
    switch (i) {
        case 1:
            [self.cameraHandler setVideoGravity:AVLayerVideoGravityResizeAspect];
            break;
        case 2:
            [self.cameraHandler setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            break;
        case 3:
            [self.cameraHandler setVideoGravity:AVLayerVideoGravityResize];
            break;
        default:
            break;
    }
    
    if (i == 3) {
        i = 0;
    }
    
}


- (IBAction)temperatureValueChanged:(UISlider *)sender {
    [self.cameraHandler setWhiteBlanceValueByTemperature:sender.value];
}

- (IBAction)tintValueChanged:(UISlider *)sender {
    [self.cameraHandler setWhiteBlanceValueByTint:sender.value];
}

#pragma mark - Delegate
- (void)xdxCaptureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
}

- (void)xdxCaptureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
}

#pragma mark - Notification
- (void)receiveResolutionChanged:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    int newHeight = [[dic objectForKey:kResolutionHeightChangedKey] intValue];
    [self.cameraHandler setCameraResolutionByActiveFormatWithHeight:newHeight];
}

- (void)receiveFrameRateChanged:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    int newFrameRate = [[dic objectForKey:kFrameRateChangedKey] intValue];
    [self.cameraHandler setCameraForHFRWithFrameRate:newFrameRate];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    //Obtaining the current device orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
//    NSLog(@"Curent UIInterfaceOrientation is %ld",(long)orientation);
    
    if(orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        NSLog(@"Device Left");
        [self.cameraHandler adjustVideoOrientationByScreenOrientation:orientation];
    }else {
        NSLog(@"App not support");
    }
}
@end
