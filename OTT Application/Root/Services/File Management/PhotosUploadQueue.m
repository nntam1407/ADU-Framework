/*============================================================================
 PROJECT: SportLocker
 FILE:    PhotosUploadQueue.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    12/12/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "PhotosUploadQueue.h"
#import "FileRequest.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation PhotosUploadQueue

- (void)configureRequestHeader {

}

- (NSMutableURLRequest *)createUploadRequestForFileRequest:(FileRequest *)fileRequest asset:(ALAsset *)asset {
    fileRequest.name = [asset name];
    NSData *data = UIImagePNGRepresentation([asset originalImage]);
    
    /* create params */
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    /* create operation request */
    NSString *path = [NSString stringWithFormat:@"/v1/places/%@/upload_photo.json", fileRequest.parentId];
    NSMutableURLRequest *request = nil;
//    NSMutableURLRequest *request = nil;[self.requestQueue multipartFormRequestWithMethod:@"POST"
//                                                                                path:path
//                                                                          parameters:params
//                                                           constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
//                                                               if(data.length > 0) {
//                                                                   [formData appendPartWithFileData:data
//                                                                                               name:@"image"
//                                                                                           fileName:fileRequest.name
//                                                                                           mimeType:@"image/jpeg"];
//                                                               }
//                                                           }];
    return request;
}

@end
