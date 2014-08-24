/*============================================================================
 PROJECT: SportLocker
 FILE:    MKHorizontalSlideView.h
 AUTHOR:  Khoai Nguyen Minh
 DATE:    7/14/14
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <UIKit/UIKit.h>


/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 BLOCKS
 =============================================================================*/

typedef void(^SelectedItemHandler)(id selectedItem);

/*============================================================================
 PROTOCOL
 =============================================================================*/

@class MKFlowSlideView;
@protocol MKFlowSlideViewDataSource <NSObject>
- (UICollectionViewCell *)slideView:(MKFlowSlideView *)slideView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)slideView:(MKFlowSlideView *)slideView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (UICollectionReusableView *)slideView:(MKFlowSlideView *)slideView
      viewForSupplementaryElementOfKind:(NSString *)kind
                            atIndexPath:(NSIndexPath *)indexPath;
@end

@protocol MKFlowSlideViewDelegate <NSObject>
@optional
- (void)slideView:(MKFlowSlideView *)slideView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end


/*============================================================================
 Interface:   MKHorizontalSlideView
 =============================================================================*/

@interface MKFlowSlideView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, weak)   UICollectionView *collectionView;
@property(nonatomic, weak)   id<MKFlowSlideViewDataSource> dataSource;
@property(nonatomic, weak)   id<MKFlowSlideViewDelegate> delegate;
@property(nonatomic, strong) UICollectionViewLayout *collectionLayout;

@property(nonatomic, copy)   SelectedItemHandler selectedItemHandler;
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, assign) NSInteger numberOfItemsPerPage;
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, assign) BOOL enabledPagingFeature;
@property(nonatomic, strong) NSIndexPath *selectedIndexPath;
@property(nonatomic, strong) ProgressView *loadingView;
@property(nonatomic, assign) id parentObject;
@property(nonatomic, strong) UIColor *scrollIndicatorColor;

- (void)reloadData;
- (void)reloadDataWithDataHandler:(void(^)(id response, id error))dataHandler;
- (void)handleError:(id)error;
- (NSString *)identify;

@end
