







#import <UIKit/UIKit.h>
#import "UIImage+cornerRadius.h"

#import "UIImageView+WebCache.h"
#import "UIView+WebCacheOperation.h"
#import "objc/runtime.h"
#import "SDWebImageManager.h"
#import "SDWebImageCompat.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageError.h"


#define dispatch_main_sync_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_sync(dispatch_get_main_queue(), block);\
    }





NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (cornerRadius)

//本地图片快速切圆角
- (void)quickSetCornerRadius:(CGFloat)cornerRadius;


//根据imageView的大小,调整image的大小
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder size:(CGSize)picSize;

//网络图片切圆角
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder size:(CGSize)picSize cornerRadius:(CGFloat)cornerRadius fillColor:(UIColor *)fillColor;

@end


NS_ASSUME_NONNULL_END
