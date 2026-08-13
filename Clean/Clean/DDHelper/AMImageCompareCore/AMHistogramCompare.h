#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class UIImage;
@interface AMHistogramCompare : NSObject
- (double) handleImage:(UIImage*) image1 withImage:(UIImage*) image2;
@end

NS_ASSUME_NONNULL_END
