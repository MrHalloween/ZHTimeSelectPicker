//
//  ZHTimeSelectPickerView.m
//  ZHTimeSelectPicker
//
//  Created by zhanghe on 2018/5/11.
//  Copyright © 2018年 1bu2bu. All rights reserved.
//

#import "ZHTimeSelectPickerView.h"

#define kWidth self.bounds.size.width
#define kheight self.bounds.size.height
#define kContentViewheight 300

@interface ZHTimeSelectPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIView *m_pContentView;
    UIPickerView *m_pPickerView;
    NSMutableArray *m_arrComponents;            ///picker 有几列
    
    NSMutableArray *m_arrYear;         ///年
    NSMutableArray *m_arrMonth;        ///月
    NSMutableArray *m_arrDay;          ///日
    
    NSInteger m_iCurrentYear;          ///当前年份
    NSInteger m_iCurrentMonth;         ///当前月份
    NSInteger m_iCurrentDay;           ///当前天
    
    NSInteger m_iTempYear;             ///临时年份
    NSInteger m_iTempMonth;            ///临时月份
    NSInteger m_iTempDay;              ///临时天
}
@end

@implementation ZHTimeSelectPickerView

- (instancetype)initWithFrame:(CGRect)frame TimeSelectType:(ZHTimeSelectType)timeSelectType TimeSlotType:(ZHTimeSlotType)timeSlotType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];
        self.alpha = 0;
        m_arrComponents = [NSMutableArray array];
        [self CreatePickerView];
        self.timeSlotType = timeSlotType;
        self.timeSelectType = timeSelectType;
    }
    return self;
}

- (void)CreatePickerView
{
    UIButton *pClosePicker = [UIButton buttonWithType:UIButtonTypeCustom];
    pClosePicker.frame = CGRectMake(0, 0, kWidth, kheight - kContentViewheight);
    [pClosePicker addTarget:self action:@selector(ClosePickerView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pClosePicker];
    
    m_pContentView = [[UIView alloc]initWithFrame:CGRectMake(0, kheight, kWidth, kContentViewheight)];
    m_pContentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:m_pContentView];
    
    m_pPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, kWidth, kContentViewheight - 40)];
    m_pPickerView.backgroundColor = [UIColor whiteColor];
    m_pPickerView.delegate = self;
    m_pPickerView.dataSource = self;
    [m_pContentView addSubview:m_pPickerView];
    
    UIButton *pCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0 , 60, 40)];
    [pCloseButton setTitle:@"关闭" forState:UIControlStateNormal];
    [pCloseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pCloseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [pCloseButton addTarget:self action:@selector(ClosePickerView) forControlEvents:UIControlEventTouchUpInside];
    [m_pContentView addSubview:pCloseButton];
    
    UIButton *pTureButton = [[UIButton alloc] initWithFrame:CGRectMake(kWidth - 60, 0 , 60, 40)];
    [pTureButton setTitle:@"确定" forState:UIControlStateNormal];
    [pTureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pTureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [pTureButton addTarget:self action:@selector(SureSelectedTime) forControlEvents:UIControlEventTouchUpInside];
    [m_pContentView addSubview:pTureButton];
}

- (void)CreateLable
{
    CGFloat width = (m_pPickerView.bounds.size.width - 50) / 3;
    CGFloat centerX = 0.0;
    switch (self.timeSelectType) {
        case ZHTimeSelectTypeYearMonthDay:
        {
            centerX = kWidth / 3 - 10;
        }
            break;
        case ZHTimeSelectTypeYearMonth:
        {
            centerX = kWidth * 0.5 - 10;
        }
            break;
        case ZHTimeSelectTypeYear:
        {
            centerX = kWidth * 0.5 + width * 0.5 - 10;
        }
            break;
            
        default:
            break;
    }
    
    for (NSInteger i = 0; i < m_arrComponents.count; i ++)
    {
        UILabel *pFlag = [[UILabel alloc] init];
        pFlag.bounds = CGRectMake(0, 0, 20, 40.0f);
        pFlag.center = CGPointMake(centerX + width * i, m_pPickerView.frame.size.height * 0.5);
        pFlag.textColor = [UIColor grayColor];
        pFlag.font = [UIFont systemFontOfSize:16];
        pFlag.textAlignment = NSTextAlignmentCenter;
        pFlag.text = m_arrComponents[i];
        [m_pPickerView addSubview:pFlag];
    }
}

- (void)InitializeYearArr
{
    NSDate *pCurrentDate = [NSDate date];
    NSCalendar *pCalendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
    NSDateComponents *pDateComponents = [pCalendar components:unitFlags fromDate:pCurrentDate];
    m_iTempYear =  m_iCurrentYear =  [pDateComponents year];
    m_iTempMonth = m_iCurrentMonth = [pDateComponents month];
    m_iTempDay = m_iCurrentDay = [pDateComponents day];
    
    NSInteger iStartYear;
    NSInteger iEndYear;

    switch (self.timeSlotType) {
        case ZHTimeSlotTypeFuture:
        {
            iStartYear = m_iCurrentYear;
            iEndYear = iStartYear + 100;
        }
            break;
        case ZHTimeSlotTypePreviously:
        {
            iStartYear = m_iCurrentYear - 100;
            iEndYear = m_iCurrentYear;
        }
            break;
        case ZHTimeSlotTypeFutureAndPreviously:
        {
            iStartYear = m_iCurrentYear - 50;
            iEndYear = m_iCurrentYear + 50;
        }
            break;
            
        default:
            break;
    }
    for (NSInteger i = iStartYear; i<= iEndYear; i++)
    {
        [m_arrYear addObject:[NSString stringWithFormat:@"%li",i]];
    }
}

- (void)InitializeMonthArr
{
    [m_arrMonth removeAllObjects];
    NSInteger iStartMonth = 1;
    NSInteger iEndMonth = 12;
    switch (self.timeSlotType) {
        case ZHTimeSlotTypeFuture:
        {
            iStartMonth = m_iTempYear == m_iCurrentYear ? m_iCurrentMonth : 1;
        }
            break;
        case ZHTimeSlotTypePreviously:
        {
            iEndMonth = m_iTempYear == m_iCurrentYear ? m_iCurrentMonth : 12;
        }
            break;
        case ZHTimeSlotTypeFutureAndPreviously:
        {

        }
            break;
            
        default:
            break;
    }
    

    for (NSInteger i = iStartMonth; i <= iEndMonth; i++) {
        [m_arrMonth addObject:[NSString stringWithFormat:@"%02ld",i]];
    }
}


//根据当前年月刷新self.dayArr数据源
- (void)InitializeDayArr
{
    [m_arrDay removeAllObjects];
    NSInteger iStartDay = 1;
    NSInteger iEndDay = 30;
    
    if(m_iTempMonth == 1 || m_iTempMonth == 3 || m_iTempMonth == 5 || m_iTempMonth == 7 || m_iTempMonth == 8 || m_iTempMonth == 10 || m_iTempMonth == 12)
    {
        iEndDay = 31;
    }
    else if(m_iTempMonth == 2)
    {
        if(((m_iTempYear%4 == 0) && (m_iTempYear%100 != 0)) || (m_iTempYear%400 == 0))
        {
            ///闰年
            iEndDay = 29;
        }
        else
        {
            ///平年
            iEndDay = 28;
        }
    }
    else
    {
        iEndDay = 30;
    }
    
    switch (self.timeSlotType) {
        case ZHTimeSlotTypeFuture:
        {
            if (m_iTempYear == m_iCurrentYear && m_iTempMonth == m_iCurrentMonth) {
                iStartDay = m_iCurrentDay;
            }
        }
            break;
        case ZHTimeSlotTypePreviously:
        {
            if (m_iTempYear == m_iCurrentYear && m_iTempMonth == m_iCurrentMonth) {
                iEndDay = m_iCurrentDay;
            }
        }
            break;
        case ZHTimeSlotTypeFutureAndPreviously:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    for (NSInteger i = iStartDay; i <= iEndDay; i++) {
        [m_arrDay addObject:[NSString stringWithFormat:@"%02ld",i]];
    }
}

#pragma mark - UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return m_arrComponents.count;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSString *strTitle = m_arrComponents[component];
    if ([strTitle isEqualToString:@"年"]) {
        return m_arrYear.count;
    }else if ([strTitle isEqualToString:@"月"]){
        return m_arrMonth.count;
    }else if ([strTitle isEqualToString:@"日"]){
        return m_arrDay.count;
    }else{
        return 0;
    }
}


#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    NSString *strTitle = m_arrComponents[component];
    if ([strTitle isEqualToString:@"年"]) {
        return [m_arrYear objectAtIndex:row];
    }else if ([strTitle isEqualToString:@"月"]){
        return [m_arrMonth objectAtIndex:row];
    }else if ([strTitle isEqualToString:@"日"]){
        return [m_arrDay objectAtIndex:row];
    }else{
        return @"";
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setFont:[UIFont systemFontOfSize:20]];
    }
    // Fill the label text here
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    [self Spearator];
    return pickerLabel;
}

#pragma mark - 改变分割线的颜色
- (void)Spearator
{
    for(UIView *speartorView in m_pPickerView.subviews)
    {
        if (speartorView.frame.size.height < 1)
        {
            speartorView.backgroundColor = [UIColor colorWithRed:225 green:225 blue:225 alpha:1];
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat width = (m_pPickerView.bounds.size.width - 50) / 3;
    return width;
}

- (void)setTimeSelectType:(ZHTimeSelectType)timeSelectType
{
    _timeSelectType = timeSelectType;
    switch (timeSelectType) {
        case ZHTimeSelectTypeYearMonthDay:
        {
            [m_arrComponents addObject:@"年"];
            [m_arrComponents addObject:@"月"];
            [m_arrComponents addObject:@"日"];
            m_arrYear = [[NSMutableArray alloc] init];
            m_arrMonth = [[NSMutableArray alloc] init];
            m_arrDay = [[NSMutableArray alloc] init];
            [self InitializeYearArr];
            [self InitializeMonthArr];
            [self InitializeDayArr];
        }
            break;
        case ZHTimeSelectTypeYearMonth:
        {
            [m_arrComponents addObject:@"年"];
            [m_arrComponents addObject:@"月"];
            m_arrYear = [[NSMutableArray alloc] init];
            m_arrMonth = [[NSMutableArray alloc] init];
            [self InitializeYearArr];
            [self InitializeMonthArr];
        }
            break;
        case ZHTimeSelectTypeYear:
        {
            [m_arrComponents addObject:@"年"];
            m_arrYear = [[NSMutableArray alloc] init];
            [self InitializeYearArr];
        }
            break;
            
        default:
            break;
    }
    [self CreateLable];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *strTitle = m_arrComponents[component];
    if ([strTitle isEqualToString:@"年"]) {
        m_iTempYear = [[m_arrYear objectAtIndex:row] integerValue];
    }else if ([strTitle isEqualToString:@"月"]){
        m_iTempMonth = [[m_arrMonth objectAtIndex:row] integerValue];
    }else if ([strTitle isEqualToString:@"日"]){
        m_iTempDay = [[m_arrDay objectAtIndex:row] integerValue];
    }else{

    }
    
    switch (self.timeSelectType) {
        case ZHTimeSelectTypeYearMonthDay:
        {
            [self InitializeMonthArr];
            [pickerView reloadComponent:1];
            NSInteger iRow1 = [pickerView selectedRowInComponent:1];
            m_iTempMonth = [[m_arrMonth objectAtIndex:iRow1] integerValue];
            [self InitializeDayArr];
            [m_pPickerView reloadComponent:2];
            NSInteger iRow2 = [pickerView selectedRowInComponent:2];
            m_iTempDay = [[m_arrDay objectAtIndex:iRow2] integerValue];
        }
            break;
        case ZHTimeSelectTypeYearMonth:
        {
            [self InitializeMonthArr];
            [pickerView reloadComponent:1];
            NSInteger iRow1 = [pickerView selectedRowInComponent:1];
            m_iTempMonth = [[m_arrMonth objectAtIndex:iRow1] integerValue];
        }
            break;
        case ZHTimeSelectTypeYear:
        {

        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark -
///关闭picker
- (void)ClosePickerView
{
    __weak typeof(self) weakSelf = self;
    __weak typeof(m_pContentView) weakContentView = m_pContentView;
    [UIView animateWithDuration:0.35f animations:^{
        weakContentView.transform = CGAffineTransformMakeTranslation(0, weakContentView.bounds.size.height);
        weakSelf.alpha = 0;
    }];
}

#pragma mark - public methods
- (void)ShowPickerView
{
    __weak typeof(self) weakSelf = self;
    __weak typeof(m_pContentView) weakContentView = m_pContentView;
    [UIView animateWithDuration:0.35f animations:^{
        weakContentView.transform = CGAffineTransformMakeTranslation(0, - weakContentView.bounds.size.height);
        weakSelf.alpha = 1.0;
    }];
    
    switch (self.timeSelectType) {
        case ZHTimeSelectTypeYearMonthDay:
        {
            NSInteger iYearRow = [m_arrYear indexOfObject:[NSString stringWithFormat:@"%04li",m_iTempYear]];
            NSInteger iMonthRow = [m_arrMonth indexOfObject:[NSString stringWithFormat:@"%02li",m_iTempMonth]];
            NSInteger iDayRow = [m_arrDay indexOfObject:[NSString stringWithFormat:@"%02li",m_iTempDay]];
            [m_pPickerView selectRow:iYearRow inComponent:0 animated:NO];
            [m_pPickerView selectRow:iMonthRow inComponent:1 animated:NO];
            [m_pPickerView selectRow:iDayRow inComponent:2 animated:NO];
        }
            break;
        case ZHTimeSelectTypeYearMonth:
        {
            NSInteger iYearRow = [m_arrYear indexOfObject:[NSString stringWithFormat:@"%04li",m_iTempYear]];
            NSInteger iMonthRow = [m_arrMonth indexOfObject:[NSString stringWithFormat:@"%02li",m_iTempMonth]];
            [m_pPickerView selectRow:iYearRow inComponent:0 animated:NO];
            [m_pPickerView selectRow:iMonthRow inComponent:1 animated:NO];
        }
            break;
        case ZHTimeSelectTypeYear:
        {
            NSInteger iYearRow = [m_arrYear indexOfObject:[NSString stringWithFormat:@"%04li",m_iTempYear]];
            [m_pPickerView selectRow:iYearRow inComponent:0 animated:NO];
        }
            break;
            
        default:
            break;
    }
    

}

#pragma mark - 确认选择
- (void)SureSelectedTime
{
    NSString *strTimeStamp;
    NSString *strTimeFormatter;
    switch (self.timeSelectType) {
        case ZHTimeSelectTypeYearMonthDay:
        {
            strTimeStamp = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)m_iTempYear,(long)m_iTempMonth,(long)m_iTempDay];
            strTimeFormatter = @"yyyy-MM-dd";
        }
            break;
        case ZHTimeSelectTypeYearMonth:
        {
            strTimeStamp = [NSString stringWithFormat:@"%ld-%02ld",(long)m_iTempYear,(long)m_iTempMonth];
            strTimeFormatter = @"yyyy-MM";
        }
            break;
        case ZHTimeSelectTypeYear:
        {
            strTimeStamp = [NSString stringWithFormat:@"%ld",(long)m_iTempYear];
            strTimeFormatter = @"yyyy";
        }
            break;
            
        default:
            break;
    }
    
    if (self.SureSelect) {
        self.SureSelect([self GetTimeStampWithTimeFormat:strTimeFormatter argTime:strTimeStamp]);
    }
    [self ClosePickerView];
}

///返回时间戳
- (NSString *)GetTimeStampWithTimeFormat:(NSString *)timeFormat argTime:(NSString *)argTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:timeFormat];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:argTime];
    NSTimeInterval b = date.timeIntervalSince1970;
    return [NSString stringWithFormat:@"%.f",b];
}


#pragma mark - appearance
- (void)setTopBarbackgroundColor:(UIColor *)topBarbackgroundColor
{
    m_pContentView.backgroundColor = topBarbackgroundColor;
}
@end
