//
//  CalendarViewController.m
//  SB_XIB_CODE
//
//  Created by KIMHEE JAE on 10/30/14.
//  Copyright (c) 2014 KIMHEE JAE. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()
{
    UIButton* year;
    UIButton* month;
    NSMutableArray* days;
    
    UIButton *prev;
    UIButton *next;
    
    int currentYear;
    int currentMonth;
}
@end

@implementation CalendarViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    days = [[NSMutableArray alloc] init];

    self.view.backgroundColor = [UIColor whiteColor];

    // 요일 표시 추가
    [self addDayButton];
    
    [self addControlButton];
    
    [self createYearAndMonthViews];
    [self createRawDateViews];
    
    currentYear = 2014;
    currentMonth = 10;
    
    [self setCurrentCalendarOnYear:currentYear andMonth:currentMonth];
}
- (void) addControlButton {
    float unitWidth = self.view.frame.size.width/7;
    int unitHeight = 50;
    UIColor* defaultDateColor = [UIColor redColor];
    
    prev = [[UIButton alloc] init];
    [prev setTitle:NSLocalizedString(@"<", nil) forState:UIControlStateNormal];
    [prev setTitleColor:defaultDateColor forState:UIControlStateNormal];
    [prev setBackgroundColor:[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:.3]];
    [prev setFrame:CGRectMake((0) * unitWidth, 0 * unitHeight + 22, unitWidth , unitHeight)];
    [self.view addSubview:prev];
 
    next = [[UIButton alloc] init];
    [next setTitle:NSLocalizedString(@">", nil) forState:UIControlStateNormal];
    [next setTitleColor:defaultDateColor forState:UIControlStateNormal];
    [next setBackgroundColor:[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:.3]];
    [next setFrame:CGRectMake((6) * unitWidth, 0 * unitHeight + 22, unitWidth , unitHeight)];
    [self.view addSubview:next];
 
    [prev addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [next addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];


    UIButton* back = [[UIButton alloc] init];
    [back setTitle:NSLocalizedString(@"back", nil) forState:UIControlStateNormal];
    [back setTitleColor:defaultDateColor forState:UIControlStateNormal];
    [back setBackgroundColor:[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:.3]];
    [back setFrame:CGRectMake((1) * unitWidth, 8 * unitHeight + 22, unitWidth*2 , unitHeight)];
    [self.view addSubview:back];
    [back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* today = [[UIButton alloc] init];
    [today setTitle:NSLocalizedString(@"today", nil) forState:UIControlStateNormal];
    [today setTitleColor:defaultDateColor forState:UIControlStateNormal];
    [today setBackgroundColor:[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:.3]];
    [today setFrame:CGRectMake((4) * unitWidth, 8 * unitHeight + 22, unitWidth*2 , unitHeight)];
    [self.view addSubview:today];
    [today addTarget:self action:@selector(goToday) forControlEvents:UIControlEventTouchUpInside];

}
- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)goToday {
   // 오늘 년 월 일을 구한다
    NSDate *curDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:curDate]; // Get necessary date components

    currentYear = [comps year];
    currentMonth = [comps month];
    [self setCurrentCalendarOnYear:currentYear andMonth:currentMonth];
}
- (void)buttonClicked:(UIButton *)button {
    if(button == prev) {
        if(currentMonth == 1) {
            currentYear--;
            currentMonth = 12;
        } else {
            currentMonth--;
        }
    } else if( button == next) {
        if(currentMonth == 12) {
            currentYear++;
            currentMonth = 1;
        } else {
            currentMonth++;
        }
    }
    [self setCurrentCalendarOnYear:currentYear andMonth:currentMonth];
}


- (void) setCurrentCalendarOnYear:(NSInteger)year_ andMonth:(NSInteger)month_ {
    [year setTitle:[NSString stringWithFormat:@"%d", year_] forState:UIControlStateNormal];
    [month setTitle:[NSString stringWithFormat:@"%d", month_] forState:UIControlStateNormal];
    // 날짜들의 위치를 설정한다.
    float unitWidth = self.view.frame.size.width/7;
    int unitHeight = 50;
    NSInteger numOfDate = [self getNumberOfDateWithYear:year_ andMonth:month_];
    NSInteger weekdayIndex = [self getWeekdayOfFirstDayWithYear:year_ andMonth:month_];
    int date = 1;
    for(;date<=numOfDate;date++){
        int xPosition = ((date+weekdayIndex-2)%7) * unitWidth;
        int yPosition = ((date+(weekdayIndex)-2)/7+2) * unitHeight + 22;
        UIButton* btn = [days objectAtIndex:(date-1)];
        [UIView animateWithDuration:0.3
                              delay:0
                            options: UIViewAnimationCurveEaseIn
                         animations:^{
                             [btn setFrame:CGRectMake(xPosition,yPosition, unitWidth, unitHeight)];
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                         }];
        
        //[btn setFrame:CGRectMake(xPosition,yPosition, unitWidth, unitHeight)];
    }
    for(;date<=31;date++){
        // 최소 28일 최대 31일
        //// 28일 이라면 3개의 날짜가 남는다.
        // 위치는 5번째 줄 화면 오른쪽
        int xPosition = 7 * unitWidth;
        int yPosition = 6 * unitHeight + 22;
        UIButton* btn = [days objectAtIndex:(date-1)];
        [UIView animateWithDuration:0.3
                              delay:0
                            options: UIViewAnimationCurveEaseIn
                         animations:^{
                             [btn setFrame:CGRectMake(xPosition,yPosition, unitWidth, unitHeight)];
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                         }];
        //[btn setFrame:CGRectMake(xPosition,yPosition, unitWidth, unitHeight)];
    }
};

- (void) createYearAndMonthViews {
    float unitWidth = self.view.frame.size.width/7;
    int unitHeight = 50;
    UIColor* defaultDateColor = [UIColor redColor];

    UIButton *yearView = [[UIButton alloc] init];
    [yearView setTitle:NSLocalizedString(@"1985", nil) forState:UIControlStateNormal];
    [yearView setTitleColor:defaultDateColor forState:UIControlStateNormal];
    [yearView setBackgroundColor:[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:.3]];
    [yearView setFrame:CGRectMake((3 -1) * unitWidth, 0 * unitHeight + 22, unitWidth * 2, unitHeight)];
    [self.view addSubview:yearView];

    year = yearView;
    
    UIButton *monthView = [[UIButton alloc] init];
    [monthView setTitle:NSLocalizedString(@"3", nil) forState:UIControlStateNormal];
    [monthView setTitleColor:defaultDateColor forState:UIControlStateNormal];
    [monthView setBackgroundColor:[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:.3]];
    [monthView setFrame:CGRectMake((5 -1) * unitWidth, 0 * unitHeight + 22, unitWidth , unitHeight)];
    [self.view addSubview:monthView];
  
    month = monthView;

}

- (void) createRawDateViews {
    // 1일 ~ 31일 까지의 날짜 뷰를 생성한다.
    // 초기 위치는 1 by 1
    UIColor* defaultDateColor = [UIColor redColor];
    int date = 1;
    for(;date<=31;date++){
        UIButton *dayButton = [[UIButton alloc] init];
        [dayButton setTitle:[NSString stringWithFormat:@"%d", date] forState:UIControlStateNormal];
        [dayButton setTitleColor:defaultDateColor forState:UIControlStateNormal];
        
        float unitWidth = self.view.frame.size.width/7;
        int unitHeight = 50;
        
        [dayButton setBackgroundColor:[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:.3]];
        [dayButton setFrame:CGRectMake((1-1) * unitWidth, 2 * unitHeight + 22, unitWidth, unitHeight)];
        [self.view addSubview:dayButton];
        //NSLog(@"%@",dayButton);
        [days addObject:dayButton];
    }
    //NSLog(@"%d",[days count]);

}
/*
- (void) createDatesAtYear:(NSInteger)year andMonth:(NSInteger)month {
    NSInteger numOfDate = [self getNumberOfDateWithYear:year andMonth:month];
    NSInteger weekdayIndex = [self getWeekdayOfFirstDayWithYear:year andMonth:month];

    int date = 1;
    for(;date<=numOfDate;date++){
        [self addButtonAt:CGPointMake((date+weekdayIndex)%7+1, (date+1)/7+2) withText:[NSString stringWithFormat:@"%d", date] withColor:[UIColor redColor]];
    }

}
*/
- (NSInteger) getNumberOfDateWithYear:(NSInteger)year_ andMonth:(NSInteger)month_ {
    NSDate *curDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday fromDate:curDate]; // Get necessary date components
 
    // set last of month
    [comps setYear:year_];
    [comps setMonth:month_+1];
    [comps setDay:0];
    NSDate *tDateMonth = [calendar dateFromComponents:comps];
    NSDateComponents* components = [calendar components:NSCalendarUnitDay fromDate:tDateMonth];
    NSInteger numberOfDate = [components day];
    return numberOfDate;
}

- (NSInteger) getWeekdayOfFirstDayWithYear:(NSInteger)year_ andMonth:(NSInteger)month_ {
     NSCalendar *calendar = [NSCalendar currentCalendar];
     NSDateComponents *comps = [[NSDateComponents alloc] init];
     [comps setDay:1];
     [comps setMonth:month_];
     [comps setYear:year_];
     // 해당 달의 1일로 세팅완료
    NSDate *tDateMonth = [calendar dateFromComponents:comps];
    NSDateComponents* components = [calendar components:NSCalendarUnitWeekday fromDate:tDateMonth];
    NSInteger weekday = [components weekday];
    return weekday;
}

- (void)addDayButton {
    [self addButtonAt:CGPointMake(1, 1) withText:@"일" withColor:[UIColor redColor]];
    [self addButtonAt:CGPointMake(2, 1) withText:@"월" withColor:[UIColor redColor]];
    [self addButtonAt:CGPointMake(3, 1) withText:@"화" withColor:[UIColor redColor]];
    [self addButtonAt:CGPointMake(4, 1) withText:@"수" withColor:[UIColor redColor]];
    [self addButtonAt:CGPointMake(5, 1) withText:@"목" withColor:[UIColor redColor]];
    [self addButtonAt:CGPointMake(6, 1) withText:@"금" withColor:[UIColor redColor]];
    [self addButtonAt:CGPointMake(7, 1) withText:@"토" withColor:[UIColor redColor]];
}
#pragma mark - Configuration
- (void)addButtonAt:(CGPoint)position withText:(NSString*)text withColor:(UIColor*)color {
    UIButton *systemTextButton = [[UIButton alloc] init];
    [systemTextButton setTitle:NSLocalizedString(text, nil) forState:UIControlStateNormal];
    [systemTextButton setTitleColor:color forState:UIControlStateNormal];
    float unitWidth = self.view.frame.size.width/7;
    int unitHeight = 50;
    
    [systemTextButton setBackgroundColor:[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:.3]];
    [systemTextButton setFrame:CGRectMake((position.x -1) * unitWidth, position.y * unitHeight + 22, unitWidth, unitHeight)];
    [self.view addSubview:systemTextButton];
}
@end
