//
//  ViewController.m
//  GestureProblem
//
//  Created by KIMHEE JAE on 10/23/14.
//  Copyright (c) 2014 KIMHEE JAE. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CGPoint initialPhotoViewPosition;

    CGSize initialPhotoViewSize;
    
    CGPoint pinchPointRatio;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPanGesture:)];
    [self.view addGestureRecognizer:panRecognizer];
 
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToTapGesture:)];
    tapRecognizer.numberOfTapsRequired = 2;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];

    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPinchGesture:)];
    [self.view addGestureRecognizer:pinchRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void)respondToPanGesture:(UIPanGestureRecognizer*)panRecognizer {
    
    if(panRecognizer.state == UIGestureRecognizerStateBegan) {
        // 시작점을 기록합니다.
        initialPhotoViewPosition = [_photoView frame].origin;
    }
    else if(panRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint deltaPosition = [panRecognizer translationInView:nil];
        [_photoView setFrame:CGRectMake(initialPhotoViewPosition.x + deltaPosition.x, initialPhotoViewPosition.y + deltaPosition.y, [_photoView frame].size.width, [_photoView frame].size.height)];
        
    }
    else if(panRecognizer.state == UIGestureRecognizerStateEnded) {
        // 시작점을 복원합니다.
        [_photoView setFrame:CGRectMake(initialPhotoViewPosition.x, initialPhotoViewPosition.y, [_photoView frame].size.width, [_photoView frame].size.height)];
    }
}
- (void)respondToTapGesture:(UITapGestureRecognizer*)tapRecognizer {
    [_photoView setCenter:[tapRecognizer locationInView:self.view]];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
        [_photoView setCenter:self.view.center];
    }
}

// Pinch Zoom 을 시작하는 위치 비율을 기억해서 확대되는 지점을 손가락 중앙에 유지시켜줍니다.
- (void)respondToPinchGesture:(UIPinchGestureRecognizer*)pinchRecognizer {
    if ([pinchRecognizer numberOfTouches] < 2)
        return;
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan) {
        initialPhotoViewSize = [_photoView frame].size;
        CGPoint _pinchPoint = [pinchRecognizer locationInView:self.view];
        pinchPointRatio = CGPointMake((_pinchPoint.x - [_photoView frame].origin.x)/initialPhotoViewSize.width,(_pinchPoint.y -[_photoView frame].origin.y)/initialPhotoViewSize.height);
    }
    if (pinchRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat scale = ( pinchRecognizer.scale);
        CGPoint point = [pinchRecognizer locationInView:self.view];
        CGSize currentSize = [_photoView frame].size;
        [_photoView setFrame:CGRectMake(point.x - currentSize.width * pinchPointRatio.x , point.y - currentSize.height * pinchPointRatio.y , scale * initialPhotoViewSize.width, scale * initialPhotoViewSize.height)];
    }
}
@end
