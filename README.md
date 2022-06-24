# APObjCKit

This package, provide Objective-C part of share code in Apple Platform helper utility.

## Support Platform

- iOS = v12
- macOS = v10.15

### Notes

- "PreRequirement.h" not use in iOS
- "libresolv.tbd", "libresolv.9.tbd" need this. [REF](https://developer.apple.com/forums/thread/654882)

#### currently test on iOS-simulator ok. But fail on macOS for 2 reason

- 01 = struct rt_metrics
- 02 = Missing '#include <net/route.h>'; definition of 'rt_metrics' must be imported from module 'Darwin.net.route' before it is required
- This function compiler can define not see in macOS.

### History

- 0.7.0 : provide API for Network Interface Info. (both macOS , and iOS)
- 0.6.0 : provide API for Network Interface key.
- 0.5.0 : provide API for IPv4 Address validation.
- 0.4.0 : provide API for get number from NSDate.
- 0.3.0 : provide API for OS version, from APSysUtility.
- 0.2.0 : provide package version

