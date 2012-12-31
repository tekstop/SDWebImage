//
//  UISegmentedControl+WebCache.m
//  SDWebImage
//
//  Created by Chirag Gupta on 12/24/12.
//

#import "UISegmentedControl+WebCache.h"
#import "objc/runtime.h"

static char operationKey;

@implementation UISegmentedControl (WebCache)

- (void)setImageWithURL:(NSURL *)url forSegmentAtIndex:(NSUInteger)segment
{
    [self setImageWithURL:url forSegmentAtIndex:segment placeholderImage:nil options:0 completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forSegmentAtIndex:(NSUInteger)segment placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url forSegmentAtIndex:segment placeholderImage:placeholder options:0 completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forSegmentAtIndex:(NSUInteger)segment placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    [self setImageWithURL:url forSegmentAtIndex:segment placeholderImage:placeholder options:options completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forSegmentAtIndex:(NSUInteger)segment completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url forSegmentAtIndex:segment placeholderImage:nil options:0 completed:completedBlock];
}
- (void)setImageWithURL:(NSURL *)url forSegmentAtIndex:(NSUInteger)segment placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url forSegmentAtIndex:segment placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url forSegmentAtIndex:(NSUInteger)segment placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock
{
    //[self cancelCurrentImageLoad];
    
    [self setImage:placeholder forSegmentAtIndex:segment];
    
    if (url)
    {
        __weak UISegmentedControl *wself = self;
        id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
                                             {
                                                 __strong UISegmentedControl *sself = wself;
                                                 if (!sself) return;
                                                 if (image)
                                                 {
                                                     [sself setImage:image forSegmentAtIndex:segment];
                                                 }
                                                 if (completedBlock && finished)
                                                 {
                                                     completedBlock(image, error, cacheType);
                                                 }
                                             }];
        objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)cancelCurrentImageLoad
{
    // Cancel in progress downloader from queue
    id<SDWebImageOperation> operation = objc_getAssociatedObject(self, &operationKey);
    if (operation)
    {
        [operation cancel];
        objc_setAssociatedObject(self, &operationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
@end
