/*============================================================================
 PROJECT: SportLocker
 FILE:    MKHorizontalSlideView.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    7/14/14
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "MKFlowSlideView.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
#define kNumberOfItemsPerPage      20

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/


@implementation MKFlowSlideView

#pragma mark - Intialization

/*----------------------------------------------------------------------------
 Method:      baseInit
 Description Initiate subviews and variables
 -----------------------------------------------------------------------------*/
- (void)baseInit {
    
    /* create collection layout */
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    [collectionLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    collectionLayout.minimumLineSpacing = 0.0f; /* no padding */
    collectionLayout.minimumInteritemSpacing = 0.0f;
    
    /* create collection view */
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                                          collectionViewLayout:collectionLayout];
    collectionView.autoresizesSubviews = YES;
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.bounces = NO;
    
    self.collectionView = collectionView;
    [self addSubview:self.collectionView];
    
    /* initialize variables */
    self.selectedItemHandler = nil;
    self.numberOfItemsPerPage = kNumberOfItemsPerPage;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self baseInit];
}

#pragma mark - Accessors

- (UICollectionViewLayout *)collectionLayout {
    return self.collectionView.collectionViewLayout;
}

- (NSMutableArray *)items {
    if(!_items) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

- (NSInteger)pageIndex {
    return ceil(self.items.count) / self.numberOfItemsPerPage + 1;
}

- (NSString *)identify {
    /* Will be overridden in subclasses */
    return [self.class description];
}

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    [self.collectionView selectItemAtIndexPath:selectedIndexPath
                                      animated:YES
                                scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:selectedIndexPath];
}

#pragma mark - Public methods

- (void)reloadData {
    
    /* query new data */
    [self reloadDataWithDataHandler:^(id response, id error) {
        
        if(!error) {
            if([response isKindOfClass:[NSArray class]]) {
                
                if(self.enabledPagingFeature) {
                    [self.items addObjectsFromArray:response];
                } else {
                    self.items = response;
                }
                
                /* reload with new data */
                [self.collectionView reloadData];
            }
        } else {
            /* handle errors */
            [self handleError:error];
        }
    }];
}

- (void)reloadDataWithDataHandler:(void(^)(id response, id error))dataHandler {
    /* Will be overridden in subclasses */
}

- (void)handleError:(id)error {
    /* Will be overridden in subclasses */
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource slideView:self cellForItemAtIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource slideView:self sizeForItemAtIndexPath:indexPath];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if([self.dataSource respondsToSelector:@selector(slideView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        return [self.dataSource slideView:self viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - UIcollectionDelegate

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if([self.delegate respondsToSelector:@selector(slideView:didSelectItemAtIndexPath:)]) {
        [self.delegate slideView:self didSelectItemAtIndexPath:indexPath];
    }
    
    if(indexPath.row < self.items.count) {
        
        _selectedIndexPath = indexPath;
        
        if(self.selectedItemHandler != NULL && self.selectedItemHandler) {
            id item = self.items[indexPath.row];
            self.selectedItemHandler(item);
        }
    }
}

- (void)changeScrollBarColorFor:(UIScrollView *)scrollView {
    for ( UIView *view in scrollView.subviews) {
        if (view.tag == 0 && [view isKindOfClass:UIImageView.class]) {
            UIImageView *imageView = (UIImageView *)view;
            imageView.backgroundColor = self.scrollIndicatorColor;
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self changeScrollBarColorFor:scrollView];
}

@end
