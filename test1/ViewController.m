//
//  ViewController.m
//  test1
//
//  Created by Jaedin Dhatt on 2021-02-09.
//

#import "ViewController.h"

@interface ViewController () {
    Renderer *glesRenderer; // ###
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapResponder:)];
    
    tapRecognizer.numberOfTapsRequired = 2;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
    
    glesRenderer = [[Renderer alloc] init];
    GLKView *view = (GLKView *)self.view;
    [glesRenderer setup:view];
    [glesRenderer loadModels];
}

- (void)update
{
    [glesRenderer update];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [glesRenderer draw:rect];
}

- (void)tapResponder: (UITapGestureRecognizer *) sender
{
    glesRenderer.isRotating = !glesRenderer.isRotating;
    NSLog(glesRenderer.isRotating ? @"rotating" : @"not rotating");
}


@end
