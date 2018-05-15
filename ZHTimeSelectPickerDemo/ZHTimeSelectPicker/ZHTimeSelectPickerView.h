//
//  ZHTimeSelectPickerView.h
//  ZHTimeSelectPicker
//
//  Created by zhanghe on 2018/5/11.
//  Copyright © 2018年 1bu2bu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZHTimeSelectType) {
    ZHTimeSelectTypeYearMonthDay = 0,                   ///选择年月日
    ZHTimeSelectTypeYearMonth,                          ///选择年月
    ZHTimeSelectTypeYear,                               ///选择年
    ZHTimeSelectTypeHourMinute,                         ///选择时分   TODO
    ZHTimeSelectTypeYearMonthDayHourMinute              ///选择年月日时分   TODO
};

typedef NS_ENUM(NSUInteger, ZHTimeSlotType) {
    ZHTimeSlotTypeFuture = 0,                           ///选择未来时间 未来100年
    ZHTimeSlotTypePreviously,                           ///选择从前时间 以前100年
    ZHTimeSlotTypeFutureAndPreviously                   ///选择从前时间和未来时间 上下50年
};

@interface ZHTimeSelectPickerView : UIView

///初始化时间选择控件
- (instancetype)initWithFrame:(CGRect)frame TimeSelectType:(ZHTimeSelectType)timeSelectType TimeSlotType:(ZHTimeSlotType)timeSlotType;

@property (nonatomic) ZHTimeSelectType timeSelectType;

@property (nonatomic) ZHTimeSlotType timeSlotType;

///确认选择 返回所选时间的时间戳
@property (nonatomic, copy) void (^SureSelect) (NSString *timeStamp);

///弹出时间选择控件
- (void)ShowPickerView;

#pragma mark - appearance TODO 加入更多的自定义UI
///顶部条背景颜色
@property(nonatomic,copy) UIColor *topBarbackgroundColor;

@end
