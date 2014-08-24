/*=============================================================================
 PROJECT: SportLocker
 FILE:    notification.h
 AUTHOR:  Mai Trung Tin
 =============================================================================*/
#ifndef _NOTIFICATION_H_H_
#define _NOTIFICATION_H_H_

/*=============================================================================
 DEFINITION
 =============================================================================*/

/*=============================================================================
 MACRO DEFINITION
 =============================================================================*/
#define NotifCenter                     [NSNotificationCenter defaultCenter]

#define NotifReg(o,s,n)                 [NotifCenter addObserver:o selector:s name:n object:nil]
#define NotifRegMe(o,s,n)               [NotifCenter addObserver:o selector:s name:n object:o]
#define NotifUnreg(o,n)                 [NotifCenter removeObserver:o name:n object:nil]
#define NotifUnregAll(o)                [NotifCenter removeObserver:o]

#define NotifPost2Obj4Info(n,o,i)       [NotifCenter postNotificationName:n object:o userInfo:i]
#define NotifPost2Obj(n,o)              NotifPost2Obj4Info(n,o,nil)
#define NotifPost(n)                    NotifPost2Obj(n,nil)

#define NotifPostNotif(n)               [NotifCenter postNotification:n]

#endif  /* _NOTIFICATION_H_H_ */