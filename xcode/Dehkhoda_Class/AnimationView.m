

#import "AnimationView.h"


@implementation AnimationView 
@synthesize animator = _animator;
@synthesize t1 = _t1;
@synthesize t2 = _t2;

- (id) initWithFrame:(CGRect)frame 
{

  if ((self = [super initWithFrame:frame])) {
    self.animator = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 100.0f, 100.0f)];
    //self.animator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo.JPG"] highlightedImage:nil];
    self.animator.backgroundColor = [UIColor redColor];
    self.animator.frame = CGRectMake(10.0f, 10.0f, 100.0f, 100.0f);
    [self addSubview:self.animator];

    self.backgroundColor = [UIColor lightGrayColor];
    self.multipleTouchEnabled = YES;

    _t1 = nil;
    _t2 = nil;
  }

  return self;
}

#define MAX_WIDTH 400.0f

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
  return CGPointMake((p1.x + p2.x)/2.0f, (p1.y + p2.y)/2.0f);
}
CGFloat distance(CGPoint p1, CGPoint p2)
{
  // distance formula => sqrt (Deltax^2 + DeltaY^2) 
  return sqrt ( pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2) );
}
CGFloat slope(CGPoint p1, CGPoint p2)
{
  if (p1.x > p2.x) {
    CGPoint temp = p1;
    p1 = p2;
    p2 = temp;
  }
  //return negative because the higher point on iOS screen has smaller y value, which differs from traditional cartesian coordinates
  return -((p2.y - p1.y) / (p2.x - p1.x));  
}
CGFloat angle (CGPoint p1, CGPoint p2)
{
  return -atan(slope(p1, p2));
}

- (void) setTouches:(NSArray *)touches
{
  if (!self.t1) {
    self.t1 = [touches count] >= 1 ? [touches objectAtIndex:0] : nil;
  }
  if (!self.t2 && [touches count] >= 2) {
    self.t2 = [touches indexOfObject:self.t1] == 0 ? [touches objectAtIndex:1] : [touches objectAtIndex:0];
  }
}

- (void) logMathematicalFormulas
{
  CGPoint p1 = [self.t1 locationInView:self]
    , p2 = [self.t2 locationInView:self]
    ;

  CGPoint mid = midPoint(p1, p2);
  NSLog(@"midPoint: (%f, %f)\ndistance:%f\nslope: %f\nAngle: %f"
                         , mid.x, mid.y
                         , distance(p1, p2) 
                         , slope(p1, p2)
                         , angle(p1, p2)
               );

}



- (void)touchesBegan:(NSSet *)touches 
           withEvent:(UIEvent *)event
{
  //NSLog(@"Touches Began");
  [self setTouches:[touches allObjects]];
  if (self.t1.tapCount == 2) {
    [self.animator.layer addAnimation:[self rotateForever] forKey:@"RotateForever"];
  } else {
    [self.animator.layer removeAnimationForKey:@"RotateForever"];
    if (self.t1 && self.t2) {
      [self logMathematicalFormulas];
    }
    [self performAnimationsWithDuration:0.4f];
  }
}

- (void)touchesMoved:(NSSet *)touches
            withEvent:(UIEvent *)event
{
  [self setTouches:[touches allObjects]];
  if (self.t1 && self.t2) {
    [self logMathematicalFormulas];
  }
  [self performAnimationsWithDuration:0.01f];
}
- (void)touchesEnded:(NSSet *)touches
            withEvent:(UIEvent *)event
{
  NSLog(@"Touches Ended");
  self.t1 = self.t2 = nil;
}


#pragma mark - Animations
- (CABasicAnimation *)animateBounds
{
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
  animation.fromValue = [NSValue valueWithCGRect:(((CALayer *)self.animator.layer.presentationLayer).bounds)];
  if (self.t2) {
    CGPoint p1 = [self.t1 locationInView:self];
    CGRect newB;
    CGPoint p2 = [self.t2 locationInView:self];
    CGPoint mid = midPoint(p1, p2);
    CGFloat dist = distance(p1, p2);
    newB = CGRectMake(mid.x - dist/2.0f, mid.y - dist/2.0f, dist, dist);
    animation.toValue = [NSValue valueWithCGRect:newB];
  } else {
    animation.toValue = animation.fromValue;  //stay same size
  }

  return animation;
}

- (CABasicAnimation *)animatePosition
{
  CABasicAnimation *animation;
  animation = [CABasicAnimation animationWithKeyPath:@"position"];
  CGPoint curpoint = ((CALayer *)self.animator.layer.presentationLayer).position;
  CGPoint new = (self.t1 && self.t2 ? midPoint([self.t1 locationInView:self], [self.t2 locationInView:self]) : [self.t1 locationInView:self]);
  animation.fromValue = [NSValue valueWithCGPoint:curpoint];
  animation.toValue = [NSValue valueWithCGPoint:new];

  return animation;
}
-(CABasicAnimation *) animateAngle
{  
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  animation.fromValue = [self.animator.layer.presentationLayer valueForKeyPath:@"transform.rotation.z"];
  if (self.t2) {
    CGPoint p1 = [self.t1 locationInView:self];
    CGPoint p2 = [self.t2 locationInView:self];
    animation.toValue = [NSNumber numberWithFloat:angle(p1, p2)];
  } else {
    animation.toValue = animation.fromValue; //stay the same angle of rotation
  }

  
  return animation;
}
- (CABasicAnimation *)rotateForever
{
  CABasicAnimation *animation;
  animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  animation.cumulative = YES;
  animation.duration = 0.70f;
  animation.repeatCount = (unsigned int)~0;
//  animation.repeatCount = NSIntegerMax;
  NSLog(@"repCount: %f", animation.repeatCount);
  animation.fromValue = [self.animator.layer.presentationLayer valueForKeyPath:@"transform.rotation.z"];
  animation.toValue = [NSNumber numberWithFloat:M_PI * 2.0f];

  return animation;
}
-(void) performAnimationsWithDuration:(CFTimeInterval)t
{
  if (!self.t1 && !self.t2) return; 
  CAAnimationGroup *gr = [CAAnimationGroup animation];
  gr.removedOnCompletion = NO;
  gr.fillMode = kCAFillModeForwards;
  gr.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  gr.duration = t;

  NSMutableArray *arr = [NSMutableArray array];
  [arr addObject:[self animatePosition]];
  [arr addObject:[self animateBounds]];
  [arr addObject:[self animateAngle]];

  gr.animations = arr;
  [self.animator.layer addAnimation:gr forKey:@"groupAnimation"];
  
}



@end



