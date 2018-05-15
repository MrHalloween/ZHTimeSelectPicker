//
//  ViewController.m
//  ZHTimeSelectPicker
//
//  Created by zhanghe on 2018/5/11.
//  Copyright © 2018年 1bu2bu. All rights reserved.
//

#import "ViewController.h"
#import "ZHTimeSelectPickerView.h"

@interface ViewController ()
{
    ZHTimeSelectPickerView *m_pTimeSelectPickerView;
}

@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///时间选择
- (IBAction)TimeSelect:(id)sender {
    if (!m_pTimeSelectPickerView) {
        __weak typeof(_TimeLabel) weakTimeLabel = _TimeLabel;
        m_pTimeSelectPickerView = [[ZHTimeSelectPickerView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) TimeSelectType:ZHTimeSelectTypeYearMonth TimeSlotType:ZHTimeSlotTypeFuture];
        m_pTimeSelectPickerView.SureSelect = ^(NSString *timeStamp) {
            NSLog(@"确认选择 %@",timeStamp);
            weakTimeLabel.text = timeStamp;
        };
        [[UIApplication sharedApplication].keyWindow addSubview:m_pTimeSelectPickerView];
    }
    [m_pTimeSelectPickerView ShowPickerView];
}

@end
