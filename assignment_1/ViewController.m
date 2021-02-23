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
@property (nonatomic, retain) IBOutlet UILabel *posText;
@property (nonatomic, retain) IBOutlet UILabel *rotText;
@property (nonatomic, retain) IBOutlet UILabel *val;
@property (nonatomic, retain) IBOutlet MixTest *theObj;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    glesRenderer = [[Renderer alloc] init];
    GLKView *view = (GLKView *)self.view;
    [glesRenderer setup:view];
    [glesRenderer loadModels];
    _theObj = [[MixTest alloc] init];
    
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
    [button2 setTitle:@"Toggle Obj-C / C++" forState:UIControlStateNormal];
    [button2 sizeToFit];
    button2.center = CGPointMake(320/2 - 80, 450);
    [button2 addTarget:self action:@selector(button2Pressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _posText = [[UILabel alloc] initWithFrame:CGRectMake(10, 480, 200, 40)];
    [_posText setBackgroundColor:[UIColor clearColor]];
    NSString *posText = [NSString stringWithFormat:@"Position: %.1f, %.1f, %.1f", glesRenderer.posX, glesRenderer.posY, glesRenderer.zoomScale];
    _posText.text = posText;
    [_posText setTextColor:[UIColor whiteColor]];
    
    _rotText = [[UILabel alloc] initWithFrame:CGRectMake(10, 500, 200, 40)];
    [_rotText setBackgroundColor:[UIColor clearColor]];
    NSString *rotText = [NSString stringWithFormat:@"Rotation: %.1f, %.1f, %.1f", glesRenderer.rotVecX, glesRenderer.rotVecY * glesRenderer.rotAngle,  glesRenderer.rotVecZ];
    _rotText.text = rotText;
    [_rotText setTextColor:[UIColor whiteColor]];
    
    _val = [[UILabel alloc] initWithFrame:CGRectMake(320/2 + 40, 431, 200, 40)];
    [_val setBackgroundColor:[UIColor clearColor]];
    _val.text = @"Int: ";
    [_val setTextColor:[UIColor blueColor]];
    
    [self.view addGestureRecognizer:tapRecognizer];
    [self.view addGestureRecognizer:panRecognizer];
    [self.view addGestureRecognizer:pinchRecognizer];
    [self.view addSubview:button1];
    [self.view addSubview:button2];
    [self.view addSubview:_posText];
    [self.view addSubview:_rotText];
    [self.view addSubview:_val];
}

- (void)update
{
    [glesRenderer update];
    _posText.text = [NSString stringWithFormat:@"Position: %.1f, %.1f, %.1f", glesRenderer.posX, glesRenderer.posY, glesRenderer.zoomScale];
    _rotText.text = [NSString stringWithFormat:@"Rotation: %.1f, %.1f, %.1f", glesRenderer.rotVecX * glesRenderer.rotAngle, glesRenderer.rotVecY * glesRenderer.rotAngle, glesRenderer.rotVecZ * glesRenderer.rotAngle];
    
    if(_theObj.useObjC)
    {
        _val.text = [NSString stringWithFormat:@"Obj-C Int: %.1d", _theObj.val];
    } else
    {
        _val.text = [NSString stringWithFormat:@"C++ Int: %.1d", _theObj.val];
    }
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [glesRenderer draw:rect];
}

- (void)tapResponder: (UITapGestureRecognizer *) sender
{
    //Double tap will start/stop rotation
    glesRenderer.isRotating = !glesRenderer.isRotating;
    if (glesRenderer.isRotating)
    {
        glesRenderer.rotVecY = 1;
    }
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
        }
        if (fabs(velocity.y) > fabs(velocity.x))
        {
            glesRenderer.rotVecX = 1.0;
            glesRenderer.rotVecY = 0.0;
            glesRenderer.rotVecZ = 0.0;
            glesRenderer.rotAngle += 0.001f * velocity.y;
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
    _theObj.useObjC = !_theObj.useObjC;
    _theObj.IncrementValue;
    NSLog(@"Value: %.1d", _theObj.val);
}

@end
