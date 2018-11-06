//
//  GQChooseImageViewController.m
//  GQChooseImage
//
//  Created by Qun on 16/9/30.
//  Copyright © 2016年 Qun. All rights reserved.
//

#import "GQChooseImageViewController.h"
#import "TZImagePickerController.h"
#import "GQPhotoCell.h"
#import "GQActionSheetView.h"
#import "GQPhotoBrowserManager.h"
#import "GQAlertController.h"
#import "GQKit.h"
@interface GQChooseImageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, GQPhotoCellDelegate, TZImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) GQActionSheetView *action;
@property (nonatomic, strong) GQPhotoBrowserManager *manger;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

/**
 点击的第几个item
 */
@property (nonatomic, strong) NSIndexPath *selectIndexPath;

/**
 每一行多少个
 */
@property (nonatomic, assign) NSInteger rowCount;
/**
 itemSize
 */
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat itemSpace;
/**
 collectionView宽度
 */
@property (nonatomic, assign) CGFloat viewW;

/**
 图片是否上传中数组
 */
@property (nonatomic, strong) NSMutableArray *loadingArr;
/**
 图片上传成功失败状态数组
 */
@property (nonatomic, strong) NSMutableArray *uploadStatesArr;

/**
 是否是回显
 */
@property (nonatomic, assign) BOOL isShowPhotos;
@end

@implementation GQChooseImageViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout = layout;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.layout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.scrollEnabled = NO;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GQPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"GQPhotoCell"];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.frame;
}

#pragma mark - collect数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.gq_dataArr.count >= self.gq_maxImageCount) {
        return self.gq_maxImageCount;
    }
    if (self.isShowPhotos == YES) {
        return self.gq_dataArr.count;
    }
    return self.gq_dataArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GQPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GQPhotoCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    if(self.gq_dataArr.count == 0){
        cell.photoImg = nil;
    } else {
        cell.photoImg = indexPath.item <= self.gq_dataArr.count - 1 ? self.gq_dataArr[indexPath.item] : nil;
        if (self.isShowPhotos == NO) {
            cell.isLoading = indexPath.item <= self.loadingArr.count - 1 ? [self.loadingArr[indexPath.item] boolValue] : NO;
            cell.showUploadMsg = indexPath.item <= self.uploadStatesArr.count - 1 ? [self.uploadStatesArr[indexPath.item] boolValue] : NO;
        } else {
            cell.closeBtn.hidden = YES;
        }
    }
    return cell;
}

#pragma mark - 打开相机 相册
- (void)openCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied) {
            GQAlertController *ale = [GQAlertController gq_alertWithMessage:@"请在设备的\"设置-隐私-相机\"中允许访问相机。" buttonTitle:nil buttonsColor:nil completion:^(NSInteger clickedButtonTag) {
                if (clickedButtonTag == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
            [ale gq_show];
            return;
        }
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.delegate = self;
        [self presentViewController:ipc animated:YES completion:nil];
    } else {

    }
}
- (void)openAlbum {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.gq_maxImageCount - self.selectIndexPath.item delegate:self];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }else{
        GQAlertController *ale = [GQAlertController gq_alertWithMessage:@"请在设备的\"设置-隐私-照片\"中允许访问相册。" buttonTitle:nil buttonsColor:nil completion:^(NSInteger clickedButtonTag) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [ale gq_show];
    }
}
#pragma mark - GQPhotoCellDelegate
- (void)photoCellRemovePhotoBtnClickForCell:(GQPhotoCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (self.gq_dataArr.count > 0) {
        [self.gq_dataArr removeObjectAtIndex:indexPath.item];
        [self.loadingArr removeObjectAtIndex:indexPath.item];
        [self.uploadStatesArr removeObjectAtIndex:indexPath.item];
    }
    if (self.gq_removePhotoBlock) {
        self.gq_removePhotoBlock(indexPath.item);
    }
    [self.collectionView reloadData];
    
    [self resetHeight];
}
- (void)photoCellAddImageBtnClickForCell:(GQPhotoCell *)cell hasChooseImg:(BOOL)hasChooseImg {
    self.selectIndexPath = [self.collectionView indexPathForCell:cell];
    if (hasChooseImg == NO) {
        [self.action gq_show];
    } else {
        [self.manger gq_showBrowserWithImages:self.gq_dataArr currentIndex:self.selectIndexPath.row];
    }
}
#pragma mark - UIImagePickerControllerDelegate
//相机选的图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.gq_dataArr addObject:info[UIImagePickerControllerOriginalImage]];
    [self.loadingArr addObject:@"1"];
    [self.uploadStatesArr addObject:@"0"];
    if (self.gq_chooseImgBlock) {
        self.gq_chooseImgBlock(@[info[UIImagePickerControllerOriginalImage]]);
    }
    [self reloadData];
}
//取消按钮
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picke {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 相册选的图片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self.gq_dataArr addObjectsFromArray:photos];
    for (int i = 0; i < photos.count; i++) {
        [self.loadingArr addObject:@"1"];
        [self.uploadStatesArr addObject:@"0"];
    }
    if (self.gq_chooseImgBlock) {
        self.gq_chooseImgBlock(photos);
    }
    [self reloadData];
}


#pragma mark - 方法
- (void)setGq_showPhotos:(NSArray *)gq_showPhotos {
    _gq_showPhotos = gq_showPhotos;
    self.isShowPhotos = YES;
    [self.gq_dataArr addObjectsFromArray:gq_showPhotos];
    [self.collectionView reloadData];
    [self resetHeight];
}
- (void)gq_setNoLoadingAndUploadStates:(UIImage *)img States:(BOOL)success {
    [self.loadingArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isEqualToString:@"1"]){
            self.loadingArr[idx] = @"0";
        }
    }];

    if(success == NO){
        [self.gq_dataArr enumerateObjectsUsingBlock:^(UIImage * obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if (img == obj1) {
                self.uploadStatesArr[idx1] = @"1";
            }
        }];
    }
    [self.collectionView reloadData];
}
#pragma mark - set方法
- (void)gq_setOrigin:(CGPoint)origin ItemSize:(CGSize)itemSize rowCount:(NSInteger)rowCount {
    if (itemSize.width == 0 || itemSize.height == 0) {
        itemSize.width = (GQ_WindowW - (rowCount + 1) * self.itemSpace) / rowCount;
        itemSize = CGSizeMake(itemSize.width, itemSize.width);
    } else {
        self.itemSpace = (GQ_WindowW - itemSize.width * rowCount) / (rowCount + 1);
    }
    if (rowCount == 0) {
        rowCount = 4;
    }
    self.rowCount = rowCount;
    self.itemSize = itemSize;
    
    self.layout.itemSize = itemSize;
    self.layout.minimumLineSpacing = self.itemSpace;
    self.layout.minimumInteritemSpacing = self.itemSpace;
    self.layout.sectionInset = UIEdgeInsetsMake(self.itemSpace, self.itemSpace, self.itemSpace, self.itemSpace);
    CGFloat viewW = self.itemSpace * (rowCount + 1) + itemSize.width * rowCount;
    self.view.frame = CGRectMake(origin.x, origin.y, viewW, itemSize.height + 2 * self.itemSpace);
    self.viewW = viewW;
}
- (void)setGq_maxImageCount:(NSInteger)gq_maxImageCount {
    _gq_maxImageCount = gq_maxImageCount;
    [self.collectionView reloadData];
}

- (void)reloadData {
    // 大于gq_maxImageCount条的删除
    if (self.gq_dataArr.count > self.gq_maxImageCount) {
        NSRange range = NSMakeRange(self.gq_maxImageCount, self.gq_dataArr.count - self.gq_maxImageCount);
        [self.gq_dataArr removeObjectsInRange:range];
    }
    [self.collectionView reloadData];
    
    [self resetHeight];
    
}
// 重置高度
- (void)resetHeight {
    NSInteger count; // 行数
    if (self.gq_showPhotos) {
        count = self.gq_dataArr.count / self.rowCount;
    } else {
        count = self.gq_dataArr.count / self.rowCount + 1;
    }
    CGFloat height = (count + 1) *  self.itemSpace + count * self.itemSize.height;
    if (self.gq_dataArr.count == self.gq_maxImageCount) {
        height = height - self.itemSize.height - self.itemSpace;
    }
    if ([self.gq_delegate respondsToSelector:@selector(gq_chooseImageViewControllerDidChangeCollectionViewWidth:Heigh:)]) {
        [self.gq_delegate gq_chooseImageViewControllerDidChangeCollectionViewWidth:self.viewW Heigh:height];
    }
    self.collectionView.gq_height = height;
}

#pragma mark - 懒加载
- (GQActionSheetView *)action {
    if (_action == nil) {
        _action = [[GQActionSheetView alloc] gq_initWithTitles:@[@"打开相机",@"打开相册"] withCancleTitle:@"取消" cancelColor:GQ_BlueColor];
        __weak __typeof(self) weakSelf = self;
        _action.gq_chooseBlock = ^(NSString *text ,NSInteger idx) {
            if (idx == 0) {
                [weakSelf openCamera];
            } else if (idx == 1){
                [weakSelf openAlbum];
            }
        };
    }
    return _action;

}
- (GQPhotoBrowserManager *)manger {
    if (_manger == nil) {
        _manger = [[GQPhotoBrowserManager alloc] init];
    }
    return _manger;
}
- (NSMutableArray *)gq_dataArr {
    if (_gq_dataArr == nil) {
        _gq_dataArr = [[NSMutableArray alloc] init];
    }
    return _gq_dataArr;
}
- (NSMutableArray *)loadingArr {
    if (_loadingArr == nil) {
        _loadingArr = [[NSMutableArray alloc] init];
    }
    return _loadingArr;
}
- (NSMutableArray *)uploadStatesArr {
    if (_uploadStatesArr == nil) {
        _uploadStatesArr = [[NSMutableArray alloc] init];
    }
    return _uploadStatesArr;
}
@end
