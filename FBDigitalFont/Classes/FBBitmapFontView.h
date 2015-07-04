#import <UIKit/UIKit.h>
#import "FBBitmapFont.h"

@interface FBBitmapFontView : UIView
@property (nonatomic, assign) FBFontDotType dotType;
@property (nonatomic, assign) FBFontSpacing spacing;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) float edgeLength;
@property (nonatomic, assign) float vmargin;
@property (nonatomic, assign) float hmargin;
@property (nonatomic, assign) float glowSize;
@property (nonatomic, assign) float innerGlowSize;
@property (nonatomic, assign) NSInteger numberOfLeftPaddingDot;
@property (nonatomic, assign) NSInteger numberOfTopPaddingDot;
@property (nonatomic, assign) NSInteger numberOfBottomPaddingDot;
@property (nonatomic, assign) NSInteger numberOfRightPaddingDot;
@property (nonatomic, assign) NSInteger numberOfPaddingDotsBetweenDigits;
@property (nonatomic, strong) UIColor *offColor;
@property (nonatomic, strong) UIColor *onColor;
@property (nonatomic, strong) UIColor *glowColor;
@property (nonatomic, strong) UIColor *innerGlowColor;
@property (nonatomic, strong) NSString *text;
- (CGSize)sizeOfContents;
- (void)resetSize;
@end
