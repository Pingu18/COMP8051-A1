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
    NSObject *theObj = [[MixTest alloc] init];
    
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
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"Increment Count" forState:UIControlStateNormal];
    [button2 sizeToFit];
    button2.center = CGPointMake(320/2, 450);
    [button2 addTarget:self action:@selector(button2Pressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *cubePosTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 480, 200, 40)];
    [cubePosTitle setBackgroundColor:[UIColor clearColor]];
    NSString *posText = [NSString stringWithFormat:@"Position: %.1f, %.1f, %.1f", glesRenderer.posX, glesRenderer.posY, glesRenderer.zoomScale];
    cubePosTitle.text = posText;
    [cubePosTitle setTextColor:[UIColor whiteColor]];
    
    UILabel *cubeRotTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 500, 200, 40)];
    [cubeRotTitle setBackgroundColor:[UIColor clearColor]];
    NSString *rotText = [NSString stringWithFormat:@"Rotation: %.1f, %.1f, %.1f", glesRenderer.rotVecX, glesRenderer.rotVecY * glesRenderer.rotAngle,  glesRenderer.rotVecZ];
    cubeRotTitle.text = rotText;
    [cubeRotTitle setTextColor:[UIColor whiteColor]];
    
    [self.view addGestureRecognizer:tapRecognizer];
    [self.view addGestureRecognizer:panRecognizer];
    [self.view addGestureRecognizer:pinchRecognizer];
    [self.view addSubview:button1];
    [self.view addSubview:button2];
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
    //Double tap will start/stop rotation
    glesRenderer.isRotating = !glesRenderer.isRotating;
    NSLog(glesRenderer.isRotating ? @"rotating" : @"not rotating");
}

- (void)panResponder: (UIPanGestureRecognizer *) sender
{
    if (!glesRenderer.isRotating && sender.numberOfTouches == 1)
    {
        //Single finger drag will rotate about x/y axis
        CGPoint velocity = [sender velocityInView:self.view];
        
        if (fabs(velocity.x) > fabs(velocity.y))
        {
            //rotate
            glesRenderer.rotVecX = 0.0;
            glesRenderer.rotVecY = 1.0;
            glesRenderer.rotVecZ = 0.0;
            glesRenderer.rotAngle += 0.001f * velocity.x;
            if (glesRenderer.rotAngle >= 360.0f)
                glesRenderer.rotAngle = 0.0f;
        }
        if (fabs(velocity.y) > fabs(velocity.x))
        {
            glesRenderer.rotVecX = 1.0;
            glesRenderer.rotVecY = 0.0;
            glesRenderer.rotVecZ = 0.0;
            glesRenderer.rotAngle += 0.001f * velocity.y;
            if (glesRenderer.rotAngle >= 360.0f)
                glesRenderer.rotAngle = 0.0f;
        }
        NSLog(@"X Velocity: %.1f, Y Velocity: %.f", velocity.x, velocity.y);
    }
    if (!glesRenderer.isRotating && sender.numberOfTouches == 2)
    {
        //Double finger drag will move the cube around
        CGPoint velocity = [sender velocityInView:self.view];
        
        glesRenderer.posX += (velocity.x * 0.0005f);
        glesRenderer.posY += (velocity.y * -0.0005f);
        
        NSLog(@"X Vel: %.1f, Y Vel: %.1f", velocity.x, velocity.y);
    }
}

- (void)pinchResponder: (UIPinchGestureRecognizer *) sender
{
    //Pinching will zoom in and out
    if (!glesRenderer.isRotating) {
        float scale = [sender scale];
        scale = (5 - scale);
        glesRenderer.zoomScale = -scale;
        NSLog(@"Zoom %.1f", scale);
    }
}

- (void)button1Pressed: (UIButton *) button1 {
    //Pressing the button will reset cube position and orientation
    glesRenderer.posX = 0.0f;
    glesRenderer.posY = 0.0f;
    glesRenderer.zoomScale = -5.0f;
    glesRenderer.rotVecX = 0.0f;
    glesRenderer.rotVecY = 1.0f;
    glesRenderer.rotVecZ = 0.0f;
    glesRenderer.rotAngle = 0.0f;
    glesRenderer.isRotating = true;
    NSLog(@"Reset cube");
}

- (void)button2Pressed: (UIButton *) button2 {
    NSLog(@"Value: " );
}

@end
