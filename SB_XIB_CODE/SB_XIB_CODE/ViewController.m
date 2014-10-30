//
//  ViewController.m
//  SB_XIB_CODE
//
//  Created by KIMHEE JAE on 10/30/14.
//  Copyright (c) 2014 KIMHEE JAE. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

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
- (IBAction)gotoSecondSB:(id)sender {
    UIStoryboard* second = [UIStoryboard storyboardWithName:@"Second" bundle:nil];
    NSLog(@"%@",second);
  //  [second instantiateViewControllerWithIdentifier:@""];
    UIViewController* vc = [second instantiateInitialViewController];
    NSLog(@"%@",vc);
    [self presentViewController:vc animated:YES completion:nil];
}

@end
