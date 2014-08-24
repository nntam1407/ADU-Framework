/*============================================================================
 PROJECT: SportLocker
 FILE:    macro.h
 AUTHOR:  Bao Nhan
 =============================================================================*/

#ifndef SportLocker_macro_h
#define SportLocker_macro_h

#import "Constants.h"
#import "notification.h"
#import "Font.h"
#import "image.h"
#import "array.h"
#import "number.h"
#import "string.h"
#import "files.h"
#import "error.h"
#endif

#define UserBool4Key(key) [[NSUserDefaults standardUserDefaults] boolForKey:key]
#define SetBool4Key(value, key) {\
[[NSUserDefaults standardUserDefaults] setBool:value forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

#define UserDfl4Key(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define SetObj4Key(value, key) {\
[[NSUserDefaults standardUserDefaults] setObject:value forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

#define RemoveObj4Key(key) {\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

/* layer macro */
#define LayerShadow(l, color, r) {\
l.shadowColor = color.CGColor;\
l.shadowOffset = CGSizeMake(0, 0);\
l.shadowRadius = r;\
l.shadowOpacity = 0.75;\
l.rasterizationScale = [[UIScreen mainScreen] scale];\
l.shouldRasterize = YES;\
}

#define LayerShadowOfView(v, color, s) {\
UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:v.bounds];\
v.layer.masksToBounds = NO;\
v.layer.shadowColor = color.CGColor;\
v.layer.shadowOffset = s;\
v.layer.shadowOpacity = 1;\
v.layer.shadowPath = shadowPath.CGPath;\
v.layer.rasterizationScale = [[UIScreen mainScreen] scale];\
v.layer.shouldRasterize = YES;\
}

#define LayerCorner(l, r, color) {\
l.cornerRadius = r;\
l.borderColor = color.CGColor;\
l.borderWidth = 0.5f;\
l.rasterizationScale = [[UIScreen mainScreen] scale];\
l.shouldRasterize = NO;\
}

#define LayerCircle(l) {\
[l setMasksToBounds:YES];\
[l setCornerRadius:l.frame.size.height/2];\
}

#define LayerConer(l) {\
[l setMasksToBounds:YES];\
[l setCornerRadius:(IS_IPAD ? 10 : 5.0)];\
}

#define LayerBorder(l) {\
[l setBorderWidth:1.0];\
[l setBorderColor:[[UIColor darkGrayColor] CGColor]];\
}

#define LayerBorderWithSizeColor(l, s, c) {\
[l setBorderWidth:s];\
[l setBorderColor:c.CGColor];\
}

#define LayerRound(l) {\
LayerConer(l);\
LayerBorder(l);\
}

#define DropShadow(l, c) {\
[l setShadowColor:c.CGColor];\
[l setShadowOpacity:0.8];\
[l setShadowRadius:3.0];\
[l setShadowOffset:CGSizeMake(2.0, 2.0)];\
}\


#define ButtonBorder(b) {                   \
b.layer.masksToBounds = YES;                \
b.layer.cornerRadius  = 5.0;               \
b.layer.borderWidth   = 2.0;                \
b.layer.borderColor   = ColorBlack.CGColor; \
}

#define LayerBorderActive(l) {\
[l setBorderWidth:2.0];\
[l setBorderColor:ColorBorderActive.CGColor];\
}

#define LayerBorderInactive(l) {\
[l setBorderWidth:1.0];\
[l setBorderColor:ColorBorderInactive.CGColor];\
}

#define DrawLine4View(v,f) {            \
CALayer *l        = [CALayer layer];    \
l.frame           = f;                  \
l.contentsGravity  = kCAGravityCenter;  \
l.backgroundColor = ColorLine.CGColor;  \
[v.layer insertSublayer:l atIndex:0];   \
}

#define BottomLine4View(v)  DrawLine4View(v,CGRectMake(0, ViewH(v)-1, ViewW(v), 1))
#define TopLine4View(v)     DrawLine4View(v,CGRectMake(0, 0, ViewW(v), 1))
#define LeftLine4View(v)    DrawLine4View(v,CGRectMake(0, 0, 1, ViewH(v)))
#define RightLine4View(v)   DrawLine4View(v,CGRectMake(ViewW(v), 0, 1, ViewH(v)-1))
#define IsKindOfClass(o,c)  [o isKindOfClass:[c class]]

/*=============================================================================
 Main macro
 =============================================================================*/
#define ReturnFromCallTarget(t,s,o)  [((NSObject*)t) performSelector:s withObject:o]
#define ReturnFromCallTargetWith2Objs(t,s,o1,o2)  [((NSObject*)t) performSelector:s withObject:o1 withObject:o2]

#define CallTarget(t,s,o)         if (((NSObject*)t) && [((NSObject*)t) respondsToSelector:s]) { [((NSObject*)t) performSelector:s withObject:o]; }
#define CallTargetWith2Obj(t,s,o1,o2)         if (((NSObject*)t) && [((NSObject*)t) respondsToSelector:s]) { [((NSObject*)t) performSelector:s withObject:o1 withObject:o2]; }
#define CallTargetAfter(t,s,o,d)  if (((NSObject*)t) && [((NSObject*)t) respondsToSelector:s]) { [((NSObject*)t) performSelector:s withObject:o afterDelay:d]; }
#define RunAfter(s,o)             CallTargetAfter(self,s,o,0.0)

#define NSDictionaryGetValueForKey(dict, a) ([dict objectForKey:a] == [NSNull null] ? nil : [dict objectForKey:a])

#define NSStringFromInt(i) [NSString stringWithFormat:@"%d", i]

/* For detecting UI style */
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568) ? NO:YES)
#define kScreenFrame [UIScreen mainScreen].bounds
#define IS_WIDESCREEN (kScreenFrame.size.height - 568 >= 0)
#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

/* For check data */
#define NotNullValue(a) (!a || a == (id)[NSNull null] ? nil : a)
#define NotNullString(a) (!a || a == (id)[NSNull null] ? @"" : a)
#define NotNullInteger(a) [NotNullValue(a) integerValue]
#define IsNullValue(a) (a == (id)[NSNull null])

#if DEBUG
#        define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#        define DLog(...)
#endif

#define appDelegate ((SLAppDelegate *)[[UIApplication sharedApplication] delegate])
#define lastWindow  ((UIWindow *)[[UIApplication sharedApplication].windows lastObject])
#define SafeRelease(o)       {if(nil!=o) {id d=o;  [d release]; d=nil;}}
#define LocStr(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]


/* color */
#define ColorRGBA(R,G,B,A)          [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define ColorRGB(R,G,B)             ColorRGBA(R,G,B,1.0)
#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


