
#import "StoreKit/StoreKit.h"

#define kProductsLoadedNotification         @"ProductsLoaded"
#define kProductPurchasedNotification       @"ProductPurchased"
#define kProductPurchaseFailedNotification  @"ProductPurchaseFailed"

typedef void (^requestProductsResponseBlock)(SKProductsRequest* request , SKProductsResponse* response);
typedef void (^buyProductCompleteResponseBlock)(SKPaymentTransaction* transcation);
typedef void (^buyProductFailResponseBlock)(SKPaymentTransaction* transcation);
typedef void (^resoreProductsCompleteResponseBlock) (SKPaymentQueue* payment);
typedef void (^resoreProductsFailResponseBlock) (SKPaymentQueue* payment,NSError* error);

@interface IAPHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    NSSet * _productIdentifiers;
    NSArray * _products;
    NSMutableSet * _purchasedProducts;
    SKProductsRequest * _request;
}

@property (strong) NSSet *productIdentifiers;
@property (strong) NSArray * products;
@property (strong) NSMutableSet *purchasedProducts;
@property (strong) SKProductsRequest *request;

- (void)requestProducts:(NSSet *)products WithCompletion:(requestProductsResponseBlock)completion;
- (void)requestProductsWithCompletion:(requestProductsResponseBlock)completion;
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)buyProduct:(SKProduct *)productIdentifier
      onCompletion:(buyProductCompleteResponseBlock)completion
            OnFail:(buyProductFailResponseBlock)fail;
- (void)restoreProductsWithCompletion:(resoreProductsCompleteResponseBlock)completion
                               OnFail:(resoreProductsFailResponseBlock)fail;
- (BOOL)isPurchasedProductsIdentifier:(NSString *)productID;

@end
