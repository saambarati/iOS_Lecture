//
//  ViewController.m
//  Dehkhoda_Class
//
//  Created by Saam Barati on 5/16/12.
//  Copyright (c) 2012 Saam Barati Inc. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//  self.view = [[AnimationView alloc] initWithFrame:self.view.frame];
  [self.view becomeFirstResponder];
//  ((AnimationView *)self.view).animator.alpha = 0.0f;
}
-(void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
//  [UIView beginAnimations:@"FADE_IN" context:NULL];
//  ((AnimationView *)self.view).animator.alpha = 1.0f;
//  [UIView commitAnimations];
  __block UIView *me = self.view;
  __block AnimationView *new = [[AnimationView alloc] initWithFrame:self.view.frame];
  new.animator.alpha = 0.0f;
  [UIView transitionFromView:self.view 
                      toView:new
                    duration:1.0f
                     options:UIViewAnimationOptionTransitionCurlDown
                  completion:^(BOOL completed) {
                    NSLog(@"transition completed, success: %d", completed);
                    me = new;
                    [UIView beginAnimations:@"FADE_IN" context:NULL];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                    [UIView setAnimationDuration:4.0f];
                    new.animator.alpha = 1.0f;
                    [UIView commitAnimations];
                  }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
