//
//  XDXResolutionVC.m
//  XDXAVCaptureSession
//
//  Created by 李承阳 on 2019/4/7.
//  Copyright © 2019 小东邪. All rights reserved.
//

#import "XDXResolutionVC.h"

@interface XDXResolutionVC ()

@property (nonatomic, strong) NSArray *resolutionArray;

@property (nonatomic, assign) int selectedResolutionHeight;

@end

@implementation XDXResolutionVC

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.resolutionArray = [self getArrayByResolutionHeight:self.maxResolutionHeight];
    
    self.selectedResolutionHeight = self.resolutionHeight;
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.selectedResolutionHeight != self.resolutionHeight) {
        NSDictionary *dic = @{kResolutionHeightChangedKey:[NSString stringWithFormat:@"%d",self.selectedResolutionHeight]};
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyResolutionChanged object:nil userInfo:dic];
    }
}

#pragma mark - Init

#pragma mark - UI
- (void)setupUI {
    self.title = NSLocalizedString(@"Resolution", nil);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
}

#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resolutionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.textLabel.text = self.resolutionArray[indexPath.row];
    
    NSRange rangeComma      = [cell.textLabel.text  rangeOfString:@"x"];
    int     resolutionHeight= [cell.textLabel.text  substringFromIndex:rangeComma.location+1].intValue;
    cell.tag                = resolutionHeight;
    cell.accessoryType      = self.selectedResolutionHeight == cell.tag ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
    
    switch (cell.tag) {
        case 480:
            self.selectedResolutionHeight = 480;
            break;
        case 720:
            self.selectedResolutionHeight = 720;
            break;
        case 1080:
            self.selectedResolutionHeight = 1080;
            break;
        case 2160:
            self.selectedResolutionHeight = 2160;
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark Other
- (NSMutableArray *)getArrayByResolutionHeight:(int)resolutionHeight {
    NSMutableArray *array = [NSMutableArray array];
    
    switch (resolutionHeight) {
        case 2160:
            array =  [NSMutableArray arrayWithArray:@[@"640x480",@"1280x720",@"1920x1080",@"3840x2160"]];
            break;
        case 1080:
            array =  [NSMutableArray arrayWithArray:@[@"640x480",@"1280x720",@"1920x1080"]];
            break;
        case 720:
            array =  [NSMutableArray arrayWithArray: @[@"640x480",@"1280x720"]];
            break;
        default:
            array =  [NSMutableArray arrayWithArray: @[@"640x480",@"1280x720"]];
            break;
    }
    
    return array;
}

@end
