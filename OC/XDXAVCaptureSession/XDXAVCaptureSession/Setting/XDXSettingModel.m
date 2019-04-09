//
//  XDXSettingModel.m
//  XDXAVCaptureSession
//
//  Created by 李承阳 on 2019/4/7.
//  Copyright © 2019 小东邪. All rights reserved.
//

#import "XDXSettingModel.h"

@implementation XDXSettingGroupModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"cells" : [XDXSettingModel class],
             };
}

@end


@implementation XDXSettingModel


@end
