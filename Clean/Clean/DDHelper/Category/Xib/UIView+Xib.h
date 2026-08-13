#import <UIKit/UIKit.h>

@interface UIView (Xib)

@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

- (void)viewWithCornerRadius:(CGFloat)cornerRadius AndBorderColor:(UIColor *)color;
- (void)viewWithCornerRadius:(CGFloat)cornerRadius AndBorderColor:(UIColor *)color AndborderWidth:(CGFloat)borderWidth;

@end
