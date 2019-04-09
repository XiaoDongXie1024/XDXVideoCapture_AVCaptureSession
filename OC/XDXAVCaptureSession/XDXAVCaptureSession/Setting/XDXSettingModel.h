//
//  XDXSettingModel.h
//  XDXAVCaptureSession
//
//  Created by 李承阳 on 2019/4/7.
//  Copyright © 2019 小东邪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XDXSettingModel;

@interface XDXSettingGroupModel : NSObject

@property (copy  , nonatomic) NSString *groupName;
@property (nonatomic, copy  ) NSString *iconName;
@property (strong, nonatomic) NSMutableArray<XDXSettingModel *> *cells;

@end

@interface XDXSettingModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *type;

@end

NS_ASSUME_NONNULL_END
