//
//  error.h
//  SportLocker
//
//  Created by Khoai Nguyen on 6/11/13.
//
//

#ifndef SportLocker_error_h
#define SportLocker_error_h

#define Error(d, n, dict) [NSError errorWithDomain:d code:n userInfo:dict]

/* for particular app */
#define kAuthenticationFailedCode   403
#define kOtherFailedCode            101
#define kErrorMessageKey            @"message"

#define MKError(n, m)               Error([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"], n, @{kErrorMessageKey:m})
#define MKAFError(m)                MKError(kAuthenticationFailedCode, m)
#define MKOtherError(m)             MKError(kOtherFailedCode, m)

#endif
