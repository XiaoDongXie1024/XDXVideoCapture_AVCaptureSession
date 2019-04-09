//
//  XDXAdjustFocusView.m
//  XDXAVCaptureSession
//
//  Created by 李承阳 on 2019/4/9.
//  Copyright © 2019 小东邪. All rights reserved.
//

#import "XDXAdjustFocusView.h"

@interface XDXAdjustFocusView ()

@property (nonatomic, assign) CGFloat originWidth;

@end

@implementation XDXAdjustFocusView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.originWidth = self.frame.size.width;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor clearColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextSetLineWidth(context, 2);
    CGContextAddRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    CGContextStrokePath(context);
}

- (void)setFrameByAnimateWithCenter:(CGPoint)center {
    self.hidden = NO;
    self.center = center;
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionOverrideInheritedOptions animations:^{
        self.bounds = CGRectMake(0, 0, self.originWidth-20, self.originWidth-20);
    } completion:^(BOOL finished) {
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.bounds.size.width != self.originWidth) {
            self.hidden = YES;
            self.bounds = CGRectMake(0, 0, self.originWidth, self.originWidth);
        }
    });
}

@end
