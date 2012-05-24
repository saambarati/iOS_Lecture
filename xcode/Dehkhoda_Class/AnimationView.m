

#import "AnimationView.h"


@implementation AnimationView 
@synthesize animator = _animator;
@synthesize t1 = _t1;
@synthesize t2 = _t2;

- (id) initWithFrame:(CGRect)frame 
{

  if ((self = [super initWithFrame:frame])) {
    self.animator = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 100.0f, 100.0f)];
//    self.animator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo.JPG"] highlightedImage:nil];
    
    self.animator.frame = CGRectMake(10.0f, 10.0f, 100.0f, 100.0f);
    [self addSubview:self.animator];
//    self.animator.backgroundColor = [UIColor redColor];
//    self.animator.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"photo.JPG"]];
    self.animator.layer.contents = (__bridge id)[[UIImage imageNamed:@"photo.JPG"] CGImage];
    self.animator.layer.contentsGravity = kCAGravityResizeAspect;
    self.backgroundColor = [UIColor whiteColor];
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
  return -((p2.y - p1.y) / (p2.x - p1.x));  //return negative because the higher point on iOS screen has smaller y value, which is different than traditional cartesian coordinates
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
  //NSLog(@"Touches Count :%d", [touches count]);
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
//  self.t1 = [touches member:self.t1];
//  self.t2 = [touches member:self.t2];
//  if (!self.t1 && self.t2){
//    self.t1 = self.t2; 
//    self.t2 = nil;
//  }
  self.t1 = self.t2 = nil;
}


#pragma mark - Animations
- (CABasicAnimation *)animateBounds
{
  if (!self.t1 || !self.t2) return nil;

  CABasicAnimation *animation;
  CGPoint p1 = [self.t1 locationInView:self];
  CGPoint p2 = [self.t2 locationInView:self];
  CGPoint mid = midPoint(p1, p2);
  animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
  CGFloat dist = distance(p1, p2);
  CGRect newB = CGRectMake(mid.x - dist/2.0f, mid.y - dist/2.0f, dist, dist);
  //CGRect newB = CGRectMake(mid.x, mid.y, dist, dist);
  //NSLog(@"%f %f", newB.origin.x, newB.origin.y);
  animation.fromValue = [NSValue valueWithCGRect:(((CALayer *)self.animator.layer.presentationLayer).frame)];
  animation.toValue = [NSValue valueWithCGRect:newB];

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
  if (!self.t1 || !self.t2) return nil;
  
  CABasicAnimation *animation;
  animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//  CATransform3D old = ((CALayer *)self.animator.layer.presentationLayer).transform;
  CGPoint p1 = [self.t1 locationInView:self];
  CGPoint p2 = [self.t2 locationInView:self];
//  CGPoint mid = midPoint(p1, p2);
  animation.fromValue = [self.animator.layer.presentationLayer valueForKeyPath:@"transform.rotation.z"];
  animation.toValue = [NSNumber numberWithFloat:angle(p1, p2)];
//  CATransform
  
  return animation;
}
- (CABasicAnimation *)rotateForever
{
  CABasicAnimation *animation;
  animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  animation.cumulative = YES;
  animation.duration = 0.70f;
  //animation.repeatCount = (unsigned long)(~(0 << 31)); //huge number, close to NSIntegerMax
  animation.repeatCount = NSIntegerMax;
  NSLog(@"%f", animation.repeatCount);
  animation.fromValue = [self.animator.layer.presentationLayer valueForKeyPath:@"transform.rotation.z"];
  animation.toValue = [NSNumber numberWithFloat:M_PI * 2.0f];

  return animation;
}
-(void) performAnimationsWithDuration:(CFTimeInterval)t
{
  CAAnimationGroup *gr = [CAAnimationGroup animation];
  gr.removedOnCompletion = NO;
  gr.fillMode = kCAFillModeForwards;
  gr.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  gr.duration = t;

  NSMutableArray *arr = [NSMutableArray array];
  [arr addObject:[self animatePosition]];
  if (self.t1 && self.t2) {
    [arr addObject:[self animateBounds]];
    [arr addObject:[self animateAngle]];
  }
  gr.animations = arr;
  [self.animator.layer addAnimation:gr forKey:@"groupAnimation"];
  
}



@end



