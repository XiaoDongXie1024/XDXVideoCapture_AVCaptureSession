
//
//  XDXFrameRateVC.m
//  XDXAVCaptureSession
//
//  Created by 李承阳 on 2019/4/7.
//  Copyright © 2019 小东邪. All rights reserved.
//

#import "XDXFrameRateVC.h"

@interface XDXFrameRateVC ()

@property (nonatomic, strong) NSArray *frameRateArray;

@property (nonatomic, assign) int selectedFrameRate;

@end

@implementation XDXFrameRateVC

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.selectedFrameRate = self.frameRate;
    
    if (self.maxFrameRate > 60) {
        self.maxFrameRate = 60;
    }
    
    self.frameRateArray = [self updateArrayByMaxFrameRate:self.maxFrameRate];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.selectedFrameRate != self.frameRate) {
        NSDictionary *dic = @{kFrameRateChangedKey:[NSString stringWithFormat:@"%d",self.selectedFrameRate]};
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyFrameRateChanged object:nil userInfo:dic];
    }
    
}

#pragma mark - Main Func
- (void)setupUI {
    self.title = NSLocalizedString(@"Frame Rate", nil);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
}

- (void)initData {
    self.frameRateArray = [NSArray array];
}

- (NSArray *)updateArrayByMaxFrameRate:(int)maxFrameRate {
    NSArray *array = [NSArray array];
    switch (maxFrameRate) {
        case 60:
            array = @[@"60P",@"50P",@"30P",@"25P"];
            break;
        case 50:
            array = @[@"50P",@"30P",@"25P"];
            break;
        case 30:
            array = @[@"30P",@"25P"];
            break;
        case 25:
            array = @[@"25P"];
            break;
        default:
            array = @[@"30P",@"25P"];
            break;
    }

    return array;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.frameRateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }

    cell.textLabel.text = self.frameRateArray[indexPath.row];

    NSRange rangeComma      = [cell.textLabel.text  rangeOfString:@"P"];
    int     frameRate       = [cell.textLabel.text  substringToIndex:rangeComma.location].intValue;
    cell.tag                = frameRate;
    cell.accessoryType      = self.selectedFrameRate == cell.tag ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
    self.selectedFrameRate = (int)cell.tag;
    [self.tableView reloadData];
}

@end
