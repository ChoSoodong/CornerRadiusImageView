






#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIImage (cornerRadius)

// 根据 imageView 的大小，重新调整 image 的大小
- (UIImage *)rightSizeImage:(UIImage *)image andSize:(CGSize)imgeSize;

- (void)rightSizeImage:(UIImage *)image andSize:(CGSize)imgeSize completion:(void (^)(UIImage *))completion;

/// 根据当前图像，和指定的尺寸，生成圆角图像并且返回 ,不存在混合图层
- (void)cornerImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor cornerRadius:(CGFloat)cornerRadius completion:(void (^)(UIImage *))completion;






@end

NS_ASSUME_NONNULL_END
