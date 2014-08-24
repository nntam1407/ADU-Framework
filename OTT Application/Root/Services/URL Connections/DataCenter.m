
/*============================================================================
 PROJECT: SportLocker
 FILE:    DataCenter.m
 AUTHOR:  Nguyen Minh Khoai
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/

#import "DataCenter.h"
#import "GoogleGeocodingResult.h"
#import "GooglePlaceDetailItem.h"
#import "GooglePrediction.h"
#import "DirectionInfo.h"

/*============================================================================
 MACRO
 =============================================================================*/

#define kGoogleMapAPIHost               @"https://maps.googleapis.com/"
#define kGoogleAPIPlaceSearchPath       @"maps/api/place/autocomplete/json"
#define kGoogleAPIPlaceDetailPath       @"maps/api/place/details/json"
#define kGoogleAPIKey                   @"AIzaSyDviEQ_rkCCFJzwyrbtFREw39Cwu-oAIcg"
#define kGetRoutesBetweenTwoPoints      @"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&mode=%@&sensor=false&language=%@"

/* define cached key */
#define kCookieKey                      @"kCookieKey"

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

/*----------------------------------------------------------------------------
 Interface:   DataCenter
 -----------------------------------------------------------------------------*/
@interface DataCenter() {
    
}

@property (nonatomic, strong) LocationService *service;

@end

@implementation DataCenter
//@synthesize activeUser;

- (id)init {
    self = [super init];
    if (self) {
        /* load previous user information */
        //        self.activeUser = [appDelegate.dataHelper onlineUser];
    }
    return self;
}

#pragma mark - Support WSDL Requests


/*----------------------------------------------------------------------------
 Method:      updateCookies
 Description: Update cookies for http request
 ----------------------------------------------------------------------------*/
- (void)updateCookies {
    NSArray *cookies = [FileHelper restoreArrayForKey:kCookieKey];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies forURL:[BaseNetwork service].networkEngine.baseURL mainDocumentURL:nil];
}

/*----------------------------------------------------------------------------
 Method:      callServiceWithBody
 Description: call a service with body and headers
 ----------------------------------------------------------------------------*/
- (void)callServiceWithBody:(NSString *)body
                httpHeaders:(NSMutableDictionary *)headers
                 httpMethod:(NSString *)method
               successBlock:(void (^)(id))successBlock
                 errorBlock:(void (^)(id))errorBlock {
    
    /* set default headers */
    BaseNetwork *baseService = [BaseNetwork service];
    baseService.enableDebugLog = NO;
    
    /* call service with parameter */
    [baseService requestWithHttpBody:body
                        headerFields:headers
                        successBlock:^(id data) {
                            successBlock(data);
                        } errorBlock:^(NSString *error) {
                            /* handle error */
                            NSString *errorMsg = error;
                            if (errorMsg) {
                                errorMsg = kServiceNotAvailableMessage;
                            }
                            errorBlock(errorMsg);
                        } httpMethod:method];
}

/*----------------------------------------------------------------------------
 Method:      callPOSTServiceWithBody
 Description: call a post request with body, headers
 ----------------------------------------------------------------------------*/
- (void)callPOSTServiceWithBody:(NSString *)body
                    httpHeaders:(NSMutableDictionary *)headers
                   successBlock:(void (^)(id))successBlock
                     errorBlock:(void (^)(id))errorBlock {
    [self callServiceWithBody:body
                  httpHeaders:headers
                   httpMethod:@"POST"
                 successBlock:successBlock
                   errorBlock:errorBlock];
}

#pragma mark - Support Normal Request
/*----------------------------------------------------------------------------
 Method:      callServiceWithURL
 Description: call a service with url, parameters and method name
 ----------------------------------------------------------------------------*/
- (void)callServiceWithURL:(NSString *)url
                    params:(NSMutableDictionary *)params
                httpMethod:(NSString *)method
              successBlock:(void (^)(id))successBlock
                errorBlock:(void (^)(id))errorBlock {
    
    /* set default headers */
    BaseNetwork *baseService = [BaseNetwork service];
    baseService.enableDebugLog = NO;
    
    /* call service with parameter */
    [baseService requestWithURL:url
                         params:params
                   successBlock:^(NSDictionary *data) {
                       successBlock(data);
                   }
                     errorBlock:^(NSString *error) {
                         errorBlock(error);
                     }
                     httpMethod:method];
}

/*----------------------------------------------------------------------------
 Method:      callGETServiceWithURL
 Description: call a get request with url and parameters
 ----------------------------------------------------------------------------*/
- (void)callGETServiceWithURL:(NSString *)url
                       params:(NSMutableDictionary *)params
                 successBlock:(void (^)(id))successBlock
                   errorBlock:(void (^)(id))errorBlock {
    
    [self callServiceWithURL:url
                      params:params
                  httpMethod:@"GET"
                successBlock:^(id dataJson) {
                    successBlock(dataJson);
                } errorBlock:^(id dataJson) {
                    errorBlock(dataJson);
                }];
}

/*----------------------------------------------------------------------------
 Method:      callPOSTServiceWithURL
 Description: call a get request with url and parameters
 ----------------------------------------------------------------------------*/
- (void)callPUTServiceWithURL:(NSString *)url
                       params:(NSMutableDictionary *)params
                 successBlock:(void (^)(id))successBlock
                   errorBlock:(void (^)(id))errorBlock {
    [self callServiceWithURL:url
                      params:params
                  httpMethod:@"PUT"
                successBlock:successBlock
                  errorBlock:errorBlock];
}

/*----------------------------------------------------------------------------
 Method:      callPOSTServiceWithURL
 Description: call a post request with url and parameters
 ----------------------------------------------------------------------------*/
- (void)callPOSTServiceWithURL:(NSString *)url
                        params:(NSMutableDictionary *)params
                  successBlock:(void (^)(id))successBlock
                    errorBlock:(void (^)(id))errorBlock {
    [self callServiceWithURL:url
                      params:params
                  httpMethod:@"POST"
                successBlock:successBlock
                  errorBlock:errorBlock];
}

/*----------------------------------------------------------------------------
 Method:      callDELETEServiceWithURL
 Description: call a delete request with url and parameters
 ----------------------------------------------------------------------------*/
- (void)callDELETEServiceWithURL:(NSString *)url
                          params:(NSMutableDictionary *)params
                    successBlock:(void (^)(id))successBlock
                      errorBlock:(void (^)(id))errorBlock {
    [self callServiceWithURL:url
                      params:params
                  httpMethod:@"DELETE"
                successBlock:successBlock
                  errorBlock:errorBlock];
}

#pragma mark - Support form requests
/*----------------------------------------------------------------------------
 Method:      callFormRequestServiceWithPath
 Description: call a form request service with path, parameters and method name
 ----------------------------------------------------------------------------*/
- (void)callFormRequestServiceWithPath:(NSString *)path
                                params:(NSMutableDictionary *)params
                              filePath:(NSString *)filePath
                                  name:(NSString *)name
                         authenticated:(BOOL)status
                          successBlock:(void (^)(id))successBlock
                            errorBlock:(void (^)(id))errorBlock {
    if(!status) {
        /* set default headers */
        BaseNetwork *baseService = [BaseNetwork service];
        
        /* call service with parameter */
        [baseService formRequestWithURLPath:path
                                     params:params
                                   filePath:filePath
                                       name:name
                               successBlock:^(NSDictionary *data) {
                                   successBlock(data);
                               } errorBlock:^(NSString *error) {
                                   /* handle error */
                                   NSString *errorMsg = error;
                                   if(!error) {
                                       errorMsg = kServiceNotAvailableMessage;
                                   }
                                   errorBlock(errorMsg);
                               }];
    } else {
        errorBlock(kAuthenticationFailedMessage);
    }
}


/*----------------------------------------------------------------------------
 Method:      callFormRequestServiceWithPath
 Description: call a form request service with path, parameters and method name
 ----------------------------------------------------------------------------*/
- (void)callFormRequestServiceWithPath:(NSString *)path
                                params:(NSMutableDictionary *)params
                                 image:image
                         authenticated:(BOOL)status
                          successBlock:(void (^)(id))successBlock
                            errorBlock:(void (^)(id))errorBlock
                         progressBlock:(void (^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock{
    if(!status) {
        /* call service with parameter */
        BaseNetwork *baseNetwork = [BaseNetwork service];
        baseNetwork.enableDebugLog = NO;
        [baseNetwork formRequestWithURLPath:path
                                     params:params
                                      image:image
                               successBlock:^(NSDictionary *data) {
                                   successBlock(data);
                               } errorBlock:^(NSString *error) {
                                   /* handle error */
                                   NSString *errorMsg = error;
                                   if(!error) {
                                       errorMsg = kServiceNotAvailableMessage;
                                   }
                                   errorBlock(errorMsg);
                               } progressBlock:^(long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                                   progressBlock(totalBytesWritten, totalBytesExpectedToWrite);
                               }];
    } else {
        errorBlock(kAuthenticationFailedMessage);
    }
}

/*----------------------------------------------------------------------------
 Method:      callFormRequestPOSTServiceWithPath
 Description: call a form request with path and parameters
 ----------------------------------------------------------------------------*/
- (void)callFormRequestPOSTServiceWithPath:(NSString *)path
                                    params:(NSMutableDictionary *)params
                              successBlock:(void (^)(id))successBlock
                                errorBlock:(void (^)(id))errorBlock {
    [self callFormRequestServiceWithPath:path
                                  params:params
                                filePath:nil
                                    name:nil
                           authenticated:YES
                            successBlock:successBlock
                              errorBlock:errorBlock];
}

/*----------------------------------------------------------------------------
 Method:      callFormRequestPOSTServiceWithPath
 Description: call a form request with path and parameters
 ----------------------------------------------------------------------------*/
- (void)callFormRequestPOSTServiceWithPath:(NSString *)path
                                    params:(NSMutableDictionary *)params
                                  filePath:(NSString *)filePath
                                      name:(NSString *)name
                              successBlock:(void (^)(id))successBlock
                                errorBlock:(void (^)(id))errorBlock {
    [self callFormRequestServiceWithPath:path
                                  params:params
                                filePath:filePath
                                    name:name
                           authenticated:NO
                            successBlock:successBlock
                              errorBlock:errorBlock];
}

#pragma mark - Google Service APIs

- (void)getCurrentLocationUsingBlock:(void (^)(id data, id error))block {
    
    if (!_service) {
        LocationService *service = [[LocationService alloc] init];
        self.service = service;
    }
    
    [_service getUpdateLocationWithCallback:^(CLLocation *location, NSError *error) {
        
        if(error) {
            block(nil, [error localizedFailureReason]);
            return;
        }
        
        GooglePlaceDetailItem *detailLocation = [[GooglePlaceDetailItem alloc] init];
        detailLocation.latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        detailLocation.longtitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        block(detailLocation, nil);
        
    }];
}

- (void)getHintListFromGoogle:(NSString *)keyword usingBlock:(void (^)(id data, id error))block {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:keyword forKey:@"input"];
    [params setObject:@"true" forKey:@"sensor"];
    [params setObject:kGoogleAPIKey forKey:@"key"];
    
    BaseNetwork *apiService = [[BaseNetwork alloc] initWithBaseURL:kGoogleMapAPIHost];
    [apiService requestWithURL:kGoogleAPIPlaceSearchPath params:params successBlock:^(NSDictionary *data) {
        NSMutableArray *googleHintList = [[NSMutableArray alloc] init];
        NSMutableArray *googlePredictions = [data objectForKey:@"predictions"];
        
        for (NSDictionary *prediction in googlePredictions){
            GooglePrediction *googlePredic = [[GooglePrediction alloc] init];
            googlePredic.description = [prediction objectForKey:@"description"];
            googlePredic.reference = [prediction objectForKey:@"reference"];
            [googleHintList addObject:googlePredic];
        }
        block(googleHintList, nil);
    } errorBlock:^(NSString *error) {
        block(nil, error);
    } httpMethod:@"GET"];
}

- (void) getPlaceDetailFromGoogle:(GooglePrediction *)prediction usingBlock:(void (^)(id data, id error))block {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:prediction.reference forKey:@"reference"];
    [params setObject:@"true" forKey:@"sensor"];
    [params setObject:kGoogleAPIKey forKey:@"key"];
    
    BaseNetwork *apiService = [[BaseNetwork alloc] initWithBaseURL:kGoogleMapAPIHost];
    [apiService requestWithURL:kGoogleAPIPlaceDetailPath params:params successBlock:^(NSDictionary *data) {
        NSDictionary *detail = [data objectForKey:@"result"];
        GooglePlaceDetailItem *detailItem = [[GooglePlaceDetailItem alloc] init];
        detailItem.name = [detail objectForKey:@"name"];
        detailItem.longtitude = [[[detail objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
        detailItem.latitude = [[[detail objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
        detailItem.iconUrl = [detail objectForKey:@"icon"];
        
        block(detailItem, nil);
    } errorBlock:^(NSString *error) {
        block(nil, error);
    } httpMethod:@"GET"];
}

/* get directions */
- (void)getRoutesBetweenA:(CLLocation *)locationA
                     andB:(CLLocation *)locationB
                   inMode:(NSString *)mode
               usingBlock:(void (^)(id data, id error))block {
    
    if (!_service) {
        self.service = [[LocationService alloc] init];
    }
    
    [_service getUpdateLocationWithCallback:^(CLLocation *location, NSError *error) {
        if(error) {
            block(nil, [error localizedFailureReason]);
            return;
        }
        NSString *origin = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
        NSString *destination = [NSString stringWithFormat:@"%f,%f", locationB.coordinate.latitude, locationB.coordinate.longitude];
        
        NSString *urlRequestString = [NSString stringWithFormat:kGetRoutesBetweenTwoPoints, origin, destination, mode, [[NSLocale preferredLanguages] objectAtIndex:0]];
        
        [[BaseNetwork service] requestWithURL:urlRequestString
                                       params:nil
                                 successBlock:^(NSDictionary *data) {
                                     NSDictionary *responseJSON = data;
                                     DirectionInfo *info = [[DirectionInfo alloc] init];
                                     
                                     /* get routes */
                                     NSArray *routes = [responseJSON objectForKey:@"routes"];
                                     
                                     if ([routes count] > 0) {
                                         NSDictionary *routeDict = [routes objectAtIndex:0];
                                         [info setupWithDictionary:routeDict];
                                     };
                                     block(info, nil);
                                 } errorBlock:^(NSString *error) {
                                     block(nil, error);
                                 } httpMethod:@"GET"];
        
    }];
}

#pragma mark - Cache APIs

- (void)checkCacheRevisions:(NSArray *)cacheVersions completeHandler:(void(^)(id data, id error))completeHandler {
    
    /* create params in JSON format */
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableArray *items = [NSMutableArray array];
    for (CacheRevision *version in cacheVersions) {
        [items addObject:[version dictionaryValue]];
    }
    
    params[@"items"] = items;
    
    /* call cache status */
    BaseNetwork *baseNetwork = [BaseNetwork service];
    [baseNetwork jsonBodyInRequestWithURLPath:@"public/v1/cache/status"
                                       params:params
                                 successBlock:^(NSDictionary *response) {
                                     completeHandler(response, nil);
                                 } errorBlock:^(NSString *error) {
                                     completeHandler(nil, error);
                                 }];
}

- (void)getCacheForRevision:(CacheRevision *)revision
                 withParams:(NSMutableDictionary *)params
                     method:(NSString *)method
            completeHandler:(void(^)(id data, id error))completeHandler {
    
    [appDelegate.dataCenter callServiceWithURL:revision.servicePath
                                        params:params
                                    httpMethod:method
                                  successBlock:^(id response) {
                                      completeHandler(response, nil);
                                  } errorBlock:^(id error) {
                                      completeHandler(nil, error);
                                  }];
}

#pragma mark - Home screen APIs

- (void)getScoreItemsUsingBlock:(void (^)(id data, id error))block {
    
    /* create params */
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    /* call API */
    [self callGETServiceWithURL:@"public/v1/home/scores"
                         params:params
                   successBlock:^(id response) {
                       
                       NSArray *info = response[@"items"];
                       NSMutableArray *items = [NSMutableArray array];
                       if([info isKindOfClass:[NSArray class]]) {
                           for (NSDictionary *itemInfo in info) {
                               @autoreleasepool {
                                   NSError *error = nil;
                                   SLScoreItem *score = [[SLScoreItem alloc] initWithDictionary:itemInfo error:&error];
                                   if(!error) {
                                       [items addObject:score];
                                   }
                               }
                           }
                       }
                       block(items, nil);
                   } errorBlock:^(id error) {
                       block(nil, error);
                   }];
}

- (void)getHomeCarouselItemsUsingBlock:(void (^)(id data, id error))block {
    /* call API */
    [self callGETServiceWithURL:@"public/v1/home/carousel"
                         params:nil
                   successBlock:^(id response) {
                       
                       NSArray *info = response[@"items"];
                       NSMutableArray *items = [NSMutableArray array];
                       if([info isKindOfClass:[NSArray class]]) {
                           for (NSDictionary *itemInfo in info) {
                               @autoreleasepool {
                                   NSError *error = nil;
                                   SLCoverItem *news = [[SLCoverItem alloc] initWithDictionary:itemInfo error:&error];
                                   if(!error) {
                                       [items addObject:news];
                                   }
                               }
                           }
                       }
                       block(items, nil);
                   } errorBlock:^(id error) {
                       block(nil, error);
                   }];
}
- (void)getHomeTrendingItemsUsingBlock:(void (^)(id data, id error))block {
    /* call API */
    [self callGETServiceWithURL:@"public/v1/home/trending"
                         params:nil
                   successBlock:^(id response) {
                       
                       NSArray *info = response[@"items"];
                       NSMutableArray *items = [NSMutableArray array];
                       if([info isKindOfClass:[NSArray class]]) {
                           for (NSDictionary *itemInfo in info) {
                               @autoreleasepool {
                                   NSError *error = nil;
                                   SLTrendingItem *trending = [[SLTrendingItem alloc] initWithDictionary:itemInfo error:&error];
                                   if(!error) {
                                       [items addObject:trending];
                                   }
                               }
                           }
                       }
                       block(items, nil);
                   } errorBlock:^(id error) {
                       block(nil, error);
                   }];
}

- (void)getHomeFavoriteItemsUsingBlock:(void (^)(id data, id error))block {
    /* call API */
    [self callGETServiceWithURL:@"public/v1/home/favorites"
                         params:nil
                   successBlock:^(id response) {
                       
                       NSArray *info = response[@"items"];
                       NSMutableArray *items = [NSMutableArray array];
                       if([info isKindOfClass:[NSArray class]]) {
                           for (NSDictionary *itemInfo in info) {
                               @autoreleasepool {
                                   NSError *error = nil;
                                   SLFavoriteItem *favorite = [[SLFavoriteItem alloc] initWithDictionary:itemInfo error:&error];
                                   if(!error) {
                                       [items addObject:favorite];
                                   }
                               }
                           }
                       }
                       block(items, nil);
                   } errorBlock:^(id error) {
                       block(nil, error);
                   }];
}

- (void)getHomeLeagueItemsUsingBlock:(void (^)(id data, id error))block {
    /* call API */
    [self callGETServiceWithURL:@"public/v1/home/leagues"
                         params:nil
                   successBlock:^(id response) {
                       
                       NSArray *info = response[@"items"];
                       NSMutableArray *items = [NSMutableArray array];
                       if([info isKindOfClass:[NSArray class]]) {
                           for (NSDictionary *itemInfo in info) {
                               @autoreleasepool {
                                   NSError *error = nil;
                                   SLLeagueItem *league = [[SLLeagueItem alloc] initWithDictionary:itemInfo error:&error];
                                   if(!error) {
                                       [items addObject:league];
                                   }
                               }
                           }
                       }
                       block(items, nil);
                   } errorBlock:^(id error) {
                       block(nil, error);
                   }];
}

- (void)getHomeNewsItemsUsingBlock:(void (^)(id, id))block {
    /* call API */
    [self callGETServiceWithURL:@"public/v1/home/news"
                         params:nil
                   successBlock:^(id response) {
                       
                       NSArray *info = response[@"items"];
                       NSMutableArray *items = [NSMutableArray array];
                       if([info isKindOfClass:[NSArray class]]) {
                           for (NSDictionary *itemInfo in info) {
                               @autoreleasepool {
                                   NSError *error = nil;
                                   SLNewsItem *news = [[SLNewsItem alloc] initWithDictionary:itemInfo error:&error];
                                   if(!error) {
                                       [items addObject:news];
                                   }
                               }
                           }
                       }
                       block(items, nil);
                   } errorBlock:^(id error) {
                       block(nil, error);
                   }];
}

- (void)getHomeBornTodayItemsUsingBlock:(void (^)(id data, id error))block {
    /* call API */
    [self callGETServiceWithURL:@"public/v1/home/bornToday"
                         params:nil
                   successBlock:^(id response) {
                       
                       NSArray *info = response[@"items"];
                       NSMutableArray *items = [NSMutableArray array];
                       if([info isKindOfClass:[NSArray class]]) {
                           for (NSDictionary *itemInfo in info) {
                               @autoreleasepool {
                                   NSError *error = nil;
                                   SLBornTodayItem *item = [[SLBornTodayItem alloc] initWithDictionary:itemInfo error:&error];
                                   if(!error) {
                                       [items addObject:item];
                                   }
                               }
                           }
                       }
                       block(items, nil);
                   } errorBlock:^(id error) {
                       block(nil, error);
                   }];
}

- (void)getHomeOnThisdDayItemsUsingBlock:(void (^)(id data, id error))block
{
    /* call API */
    [self callGETServiceWithURL:@"public/v1/home/onThisDay"
                         params:nil
                   successBlock:^(id response) {
                       
                       NSArray *info = response[@"items"];
                       NSMutableArray *items = [NSMutableArray array];
                       if([info isKindOfClass:[NSArray class]]) {
                           for (NSDictionary *itemInfo in info) {
                               @autoreleasepool {
                                   NSError *error = nil;
                                   SLOnThisDayItem *item = [[SLOnThisDayItem alloc] initWithDictionary:itemInfo error:&error];
                                   if(!error) {
                                       [items addObject:item];
                                   }
                               }
                           }
                       }
                       block(items, nil);
                   } errorBlock:^(id error) {
                       block(nil, error);
                   }];
}

@end