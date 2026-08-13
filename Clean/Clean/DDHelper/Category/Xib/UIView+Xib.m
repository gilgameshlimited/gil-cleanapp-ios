#import "UIView+Xib.h"

@implementation UIView (Xib)

@dynamic borderColor;
@dynamic borderWidth;
@dynamic cornerRadius;

- (void)setBorderWidth:(CGFloat)borderWidth {
    if (borderWidth >= 0) {
        self.layer.borderWidth = borderWidth;
    }
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (void)viewWithCornerRadius:(CGFloat)cornerRadius AndBorderColor:(UIColor *)color {
    [self viewWithCornerRadius:cornerRadius AndBorderColor:color AndborderWidth:1];
}

- (void)viewWithCornerRadius:(CGFloat)cornerRadius AndBorderColor:(UIColor *)color AndborderWidth:(CGFloat)borderWidth {
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
}

@end
