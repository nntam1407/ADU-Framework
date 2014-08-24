/*============================================================================
 PROJECT: SportLocker
 FILE:    image.h
 AUTHOR:  Bao Nhan
 =============================================================================*/

#ifndef SportLocker_image_h
#define SportLocker_image_h

/*=============================================================================
 MACRO DEFINITION
 =============================================================================*/

#define ImgWithName(name)               [UIImage imageNamed:name]
#define ImgStretch(n, w, h)             [[UIImage imageNamed:n] stretchableImageWithLeftCapWidth:w topCapHeight:h]
#define ImgWithUrlStr(o, u, n)          [o setImageWithURL:[NSURL URLWithString:u] placeholderImage:ImgWithName(n)]

#endif
