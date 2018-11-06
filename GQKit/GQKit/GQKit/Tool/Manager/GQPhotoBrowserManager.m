//
//  GQPhotoBrowserManager.m
//  GQKit
//
//  Created by Apple on 3/10/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "GQPhotoBrowserManager.h"
@interface GQPhotoBrowserManager()
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) UINavigationController *photoNavigationController;
@end
@implementation GQPhotoBrowserManager

- (NSMutableArray *)photos {
    if (_photos == nil) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

- (MWPhotoBrowser *)photoBrowser {
    if (_photoBrowser == nil) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = NO;
        _photoBrowser.displayNavArrows = YES;
        _photoBrowser.displaySelectionButtons = NO;
        _photoBrowser.alwaysShowControls = NO;
        _photoBrowser.zoomPhotosToFill = YES;
        _photoBrowser.enableGrid = NO;
        _photoBrowser.startOnGrid = NO;
        [_photoBrowser setCurrentPhotoIndex:0];
    }
    return _photoBrowser;
}

- (UINavigationController *)photoNavigationController {
    if (_photoNavigationController == nil) {
        _photoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
        _photoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    [self.photoBrowser reloadData];
    return _photoNavigationController;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [self.photos count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

-(void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    __weak __typeof(&*self)weakSelf = self;
    [self.gq_fromVC dismissViewControllerAnimated:YES completion:^{
        // to release data;
        [weakSelf.photos removeAllObjects];
        [photoBrowser reloadData];
        
        weakSelf.photoBrowser.delegate = nil;
        weakSelf.photos = nil;
        weakSelf.photoNavigationController = nil;
        weakSelf.photoBrowser = nil;
    }];
}


#pragma mark - public

- (void)gq_showBrowserWithImages:(NSArray *)imageArray {
    if (imageArray && [imageArray count] > 0) {
        NSMutableArray *photoArray = [NSMutableArray array];
        for (id object in imageArray) {
            MWPhoto *photo;
            if ([object isKindOfClass:[UIImage class]]) {
                photo = [MWPhoto photoWithImage:object];
                [photoArray addObject:photo];
            } else if ([object isKindOfClass:[NSURL class]]) {
                photo = [MWPhoto photoWithURL:object];
                [photoArray addObject:photo];
            } else if ([object isKindOfClass:NSString.class]) {
                photo = [MWPhoto photoWithURL:[NSURL URLWithString:object]];
                [photoArray addObject:photo];
            }
        }
        self.photos = photoArray;
    }
    
    UIViewController *rootController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    //    UIViewController *rootController ;
    if (self.gq_fromVC) {
        rootController = self.gq_fromVC;
    } else {
        self.gq_fromVC = rootController;
    }
    [rootController presentViewController:self.photoNavigationController animated:YES completion:nil];
}

- (void)gq_showBrowserWithImages:(NSArray*)imageArray currentIndex:(NSInteger)index{
    [self gq_showBrowserWithImages:imageArray];
    [self.photoBrowser setCurrentPhotoIndex:index];
}

@end
