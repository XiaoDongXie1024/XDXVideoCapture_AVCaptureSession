//
//  XDXSettingViewController.m
//  XDXAVCaptureSession
//
//  Created by 李承阳 on 2019/4/7.
//  Copyright © 2019 小东邪. All rights reserved.
//

#import "XDXSettingViewController.h"
#import "XDXResolutionVC.h"
#import "XDXFrameRateVC.h"

#import "XDXSettingModel.h"
#import "YYModel.h"
#import "XDXCameraModel.h"

#import "XDXCameraHandler.h"

@interface XDXSettingViewController ()

@property (nonatomic, strong) NSArray<XDXSettingGroupModel *> *dataSourceArray;

@property (nonatomic, strong) XDXResolutionVC *resolutionVC;
@property (nonatomic, strong) XDXFrameRateVC  *frameRateVC;

@end

@implementation XDXSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureData];
    [self setupUI];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];    
}

- (void)configureData {
    NSArray *array = [NSArray yy_modelArrayWithClass:XDXSettingGroupModel.class json:[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSStringFromClass(self.class) ofType:@"plist"]]];
    self.dataSourceArray = [NSMutableArray arrayWithArray:array];
}

- (void)setupUI {
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    self.title = @"Setting";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray[section].cells.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = 44;
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.dataSourceArray[section].iconName]];
    imageV.frame = CGRectMake(20, (height-17)/2, 10, 17);
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:14]];
    label.frame = CGRectMake(imageV.frame.origin.x + imageV.frame.size.width + 10, 0, 200, height);
    label.text = self.dataSourceArray[section].groupName;
    [label setTextColor:XDXColor(49, 152, 153)];
    
    [view addSubview:imageV];
    [view addSubview:label];
    view.backgroundColor = XDXColor(242, 242, 242);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

#pragma mark - TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"XDXCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font          = [UIFont systemFontOfSize:12.f];
        cell.textLabel.textColor     = [UIColor blackColor];
        cell.selectionStyle          = UITableViewCellSelectionStyleNone;
        cell.accessoryType           = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = (self.dataSourceArray[indexPath.section].cells)[indexPath.row].name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            self.resolutionVC.resolutionHeight = self.cameraHandler.cameraModel.resolutionHeight;
            self.resolutionVC.maxResolutionHeight = [self.cameraHandler getMaxSupportResolutionByActiveFormat];
            [self.navigationController pushViewController:self.resolutionVC animated:YES];
            break;
        case 1:
            self.frameRateVC.frameRate = self.cameraHandler.cameraModel.frameRate;
            self.frameRateVC.maxFrameRate = [self.cameraHandler getMaxFrameRateByCurrentResolution];
            [self.navigationController pushViewController:self.frameRateVC animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark - Getter
- (XDXResolutionVC *)resolutionVC {
    if (!_resolutionVC) {
        _resolutionVC = [[XDXResolutionVC alloc] init];
    }
    return _resolutionVC;
}

- (XDXFrameRateVC *)frameRateVC {
    if (!_frameRateVC) {
        _frameRateVC = [[XDXFrameRateVC alloc] init];
    }
    return _frameRateVC;
}


@end
