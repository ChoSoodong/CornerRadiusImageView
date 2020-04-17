





#import "UIImageView+cornerRadius.h"

static char imageURLKey;
static char TAG_ACTIVITY_INDICATOR;
static char TAG_ACTIVITY_STYLE;
static char TAG_ACTIVITY_SHOW;

@implementation UIImageView (cornerRadius)

- (void)quickSetCornerRadius:(CGFloat)cornerRadius{
    
    [self.image cornerImageWithSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height) fillColor:[UIColor whiteColor] cornerRadius:cornerRadius completion:^(UIImage * _Nonnull img) {
        self.image = img;
    }];
}




- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder size:(CGSize)picSize{
    [self sd_setImageWithURL:url placeholderImage:placeholder size:picSize options:0 progress:nil completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder size:(CGSize)picSize cornerRadius:(CGFloat)cornerRadius fillColor:(UIColor *)fillColor;{
    [self sd_setImageWithURL:url placeholderImage:placeholder size:picSize cornerRadius:cornerRadius fillColor:fillColor options:0 progress:nil completed:nil];
    
}





- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder size:(CGSize)picSize options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completedBlock {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            
            self.image = placeholder;
        });
    }
    
    if (url) {
        
        // check if activityView is enabled or not
        if ([self showActivityIndicatorView]) {
            [self addActivityIndicator];
        }
        
        __weak __typeof(self)wself = self;
        id <SDWebImageOperation> operation =
        [[SDWebImageManager sharedManager] loadImageWithURL:url options:options progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
           [wself removeActivityIndicator];
                       if (!wself) return;
                       dispatch_main_sync_safe(^{
                           if (!wself) return;
                           if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock)
                           {
                               
                               completedBlock(image, error, cacheType, url);
                               return;
                           }
                           else if (image) {
           #warning    //-----------------------
                           
                           [image rightSizeImage:image andSize:picSize completion:^(UIImage *img) {
                                 wself.image  = img;
                               NSLog(@"----->  %f",img.size.height);
                               [wself setNeedsLayout];

                               }];
                               
                           } else {
                               if ((options & SDWebImageDelayPlaceholder)) {
                                   wself.image = placeholder;
                                   [wself setNeedsLayout];
                               }
                           }
                           if (completedBlock && finished) {
                               completedBlock(image, error, cacheType, url);
                           }
                       });
            
            
        }];
        
        
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            [self removeActivityIndicator];
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}





- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder size:(CGSize)picSize cornerRadius:(CGFloat)cornerRadius fillColor:(UIColor *)fillColor options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completedBlock {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            
            self.image = placeholder;
        });
    }
    
    if (url) {
        
        // check if activityView is enabled or not
        if ([self showActivityIndicatorView]) {
            [self addActivityIndicator];
        }
        
        __weak __typeof(self)wself = self;
        id <SDWebImageOperation> operation =
        [[SDWebImageManager sharedManager] loadImageWithURL:url options:options progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
             [wself removeActivityIndicator];
                        if (!wself) return;
                        dispatch_main_sync_safe(^{
                            if (!wself) return;
                            if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock)
                            {
                                
                                completedBlock(image, error, cacheType, url);
                                return;
                            }
                            else if (image) {
            #warning    //-----------------------
                                
            //                    [image rightSizeImage:image andSize:picSize completion:^(UIImage *img) {
            //                        wself.image  = img;
            //                        NSLog(@"----->  %f",img.size.height);
            //                        [wself setNeedsLayout];
                                [image cornerImageWithSize:picSize fillColor:fillColor cornerRadius:cornerRadius completion:^(UIImage *img) {
                                    wself.image  = img;
                                    //                        NSLog(@"----->  %f",img.size.height);
                                                            [wself setNeedsLayout];
            //                    }];
                                
                                }];
                                
                            } else {
                                if ((options & SDWebImageDelayPlaceholder)) {
                                    wself.image = placeholder;
                                    [wself setNeedsLayout];
                                }
                            }
                            if (completedBlock && finished) {
                                completedBlock(image, error, cacheType, url);
                            }
                        });
            
        }];
        

        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            [self removeActivityIndicator];
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}




- (BOOL)showActivityIndicatorView{
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_SHOW) boolValue];
}

- (void)addActivityIndicator {
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[self getIndicatorStyle]];
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;

        dispatch_main_async_safe(^{
            [self addSubview:self.activityIndicator];

            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0.0]];
        });
    }

    dispatch_main_async_safe(^{
        [self.activityIndicator startAnimating];
    });

}

- (void)removeActivityIndicator {
    if (self.activityIndicator) {
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }
}






- (UIActivityIndicatorView *)activityIndicator {
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &TAG_ACTIVITY_INDICATOR);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, &TAG_ACTIVITY_INDICATOR, activityIndicator, OBJC_ASSOCIATION_RETAIN);
}

- (void)setShowActivityIndicatorView:(BOOL)show{
    objc_setAssociatedObject(self, &TAG_ACTIVITY_SHOW, [NSNumber numberWithBool:show], OBJC_ASSOCIATION_RETAIN);
}



- (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)style{
    objc_setAssociatedObject(self, &TAG_ACTIVITY_STYLE, [NSNumber numberWithInt:style], OBJC_ASSOCIATION_RETAIN);
}

- (int)getIndicatorStyle{
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_STYLE) intValue];
}


@end
