//
//  ViewController.m
//  PanGesture
//
//  Created by KIMHEE JAE on 10/23/14.
//  Copyright (c) 2014 KIMHEE JAE. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CGPoint viewStartCenter;
    
    CGSize initialSize;
    CGFloat lastScale;
    CGPoint pinchPoint;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPanGesture:)];
    [self.view addGestureRecognizer:panRecognizer];
 
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToTapGesture:)];
    tapRecognizer.numberOfTapsRequired = 2;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPinchGesture:)];
    [self.view addGestureRecognizer:pinchRecognizer];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)respondToPanGesture:(UIPanGestureRecognizer*)panRecognizer {
    
    if(panRecognizer.state == UIGestureRecognizerStateBegan) {
        // 시작점을 기록합니다.
        viewStartCenter = [_smoothies frame].origin;

    }
    else if(panRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint deltaPosition = [panRecognizer translationInView:nil];
        [_smoothies setFrame:CGRectMake(viewStartCenter.x + deltaPosition.x, viewStartCenter.y + deltaPosition.y, [_smoothies frame].size.width, [_smoothies frame].size.height)];

    }
    else if(panRecognizer.state == UIGestureRecognizerStateEnded) {
        // 시작점을 복원합니다.
        [_smoothies setFrame:CGRectMake(viewStartCenter.x, viewStartCenter.y, [_smoothies frame].size.width, [_smoothies frame].size.height)];
        
    }
}
- (void)respondToTapGesture:(UITapGestureRecognizer*)tapRecognizer {
    [_smoothies setCenter:[tapRecognizer locationInView:self.view]];
}
- (void)respondToPinchGesture:(UIPinchGestureRecognizer*)pinchRecognizer {
    if ([pinchRecognizer numberOfTouches] < 2)
        return;
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
  //      pinchPoint = [pinchRecognizer locationInView:self.view];

//        pinchPoint = CGPointMake([_smoothies frame].origin.x - pinchPoint.x,[_smoothies frame].origin.Y - pinchPoint.y);
//        initialSize = [_smoothies frame].size;
        
//        NSLog(@"initialSize -- %f,%f",initialSize);

    }
    if (pinchRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat scale = 1.0 - (lastScale - pinchRecognizer.scale);
        CGPoint point = [pinchRecognizer locationInView:self.view];
        CGSize currentSize = [_smoothies frame].size;
        [_smoothies setFrame:CGRectMake(point.x - currentSize.width/2, point.y - currentSize.height/2, scale * initialSize.width, scale * initialSize.height)];

        NSLog(@"%@",pinchRecognizer);
    }
    // Scale
    
    /*
    [_smoothies setAffineTransform:
     CGAffineTransformScale([_smoothies affineTransform],
                            scale,
                            scale)];
    lastScale = sender.scale;
    
 Ω
     */
    //[_smoothies setCenter:[tapRecognizer locationInView:self.view]];
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
        [_smoothies setCenter:self.view.center];
    }
}
@end
