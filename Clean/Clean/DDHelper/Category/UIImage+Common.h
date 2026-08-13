#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Common)

/**
 *  多张图片合成视频
 *
 */
+ (void)compressImages:(NSArray <UIImage *> *)images completion:(void(^)(NSURL *outurl))block;
+ (void)compressionSessionWithImgArr:(NSArray *)imgArr CGSize:(CGSize)size completion:(void(^)(NSURL *outurl))block;


+ (void)changeMOVVideoTypeToMp4WithVideoUrl:(NSURL *)viedoUrl completion:(void(^)(NSURL * _Nullable outputUrl))block;

// 获取照片的模糊程度 小于500认为是模糊图，这个值可以自己看情况定义
+ (double)getImageDimValue:(UIImage *)sourceImage;

@end

NS_ASSUME_NONNULL_END
