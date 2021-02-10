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
    glesRenderer = [[Renderer alloc] init];
    GLKView *view = (GLKView *)self.view;
    [glesRenderer setup:view];
    [glesRenderer loadModels];
    
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapResponder:)];
    
    tapRecognizer.numberOfTapsRequired = 2;
    tapRecognizer.numberOfTouchesRequired = 1;
    
    UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panResponder:)];
    
    UIPinchGestureRecognizer * pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchResponder:)];
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:@"Reset Cube" forState:UIControlStateNormal];
    [button1 sizeToFit];
    button1.center = CGPointMake(320/2, 60);
    [button1 addTarget:self action:@selector(button1Pressed:) forControlEvents: UIControlEventTouchUpInside];
    
    UILabel *cubePosTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 480, 200, 40)];
    [cubePosTitle setBackgroundColor:[UIColor clearColor]];
    [cubePosTitle setText:@"Position: "];
    [cubePosTitle setTextColor:[UIColor whiteColor]];
    
    UILabel *cubeRotTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 500, 200, 40)];
    [cubeRotTitle setBackgroundColor:[UIColor clearColor]];
    [cubeRotTitle setText:@"Rotation: "];
    [cubeRotTitle setTextColor:[UIColor whiteColor]];
    
    [self.view addGestureRecognizer:tapRecognizer];
    [self.view addGestureRecognizer:panRecognizer];
    [self.view addGestureRecognizer:pinchRecognizer];
    [self.view addSubview:button1];
    [self.view addSubview:cubePosTitle];
    [self.view addSubview:cubeRotTitle];
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

- (void)panResponder: (UIPanGestureRecognizer *) sender
{
    if(!glesRenderer.isRotating && sender.numberOfTouches == 1)
    {
        NSLog(@"Single finger drag");
    }
    else if (!glesRenderer.isRotating && sender.numberOfTouches == 2)
    {
        NSLog(@"Double finger drag");
    }
}

- (void)pinchResponder: (UIPinchGestureRecognizer *) sender
{
    if (!glesRenderer.isRotating) {
        NSLog(@"Pinch");
    }
}

- (void)button1Pressed: (UIButton *) button1 {
    NSLog(@"Reset cube");
}


@end
