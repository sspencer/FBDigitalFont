//
//  FBViewController.m
//  FBDigitalFontDemo
//
//  Created by Lyo Kato on 2013/11/26.
//  Copyright (c) 2013年 OCTUDIO. All rights reserved.
//

#import "FBViewController.h"
#import <FBDigitalFont/FBBitmapFontView.h>
#import <FBDigitalFont/FBLCDFontView.h>
#import <FBDigitalFont/FBSquareFontView.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 blue:((float)((rgbValue) & 0xFF))/255.0 alpha:1.0]

@implementation UIView (FBViewController)
- (void)centerizeInWidth:(CGFloat)width
{
    self.frame = CGRectMake((width - self.frame.size.width)/2.0,
                            self.frame.origin.y,
                            self.frame.size.width,
                            self.frame.size.height);
}
@end

@interface FBViewController ()
@property(strong,nonatomic)FBBitmapFontView *bfv;
@end

@implementation FBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    [self setupBitmapFont];
    /*
    [self setupLCDFont];
    [self setupSquareFont];
    [self setupSquareFont2];
     */
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(tick:)
                                   userInfo:nil
                                    repeats:YES];
}

-(void)tick:(NSTimer *)timer {
    self.bfv.text = [self time];
}

-(NSString*)time {
    //do smth
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@">hh:mm:ss"];
    NSDate *date = [[NSDate alloc]init];
    
    return [dateFormatter stringFromDate:date];
}


- (void)setupBitmapFont
{
    CGRect frame = CGRectMake(10, 60, 300, 50);

    static unichar solidRightArrow[5] = { 0x7f,0x3e,0x1c,0x08,0x00 };
    [FBBitmapFont setCustomSymbol:62 bitmask:solidRightArrow];

    self.bfv = [[FBBitmapFontView alloc] initWithFrame:frame];
    self.bfv.text = [self time];
    self.bfv.dotType = FBFontDotTypeSquare;
    self.bfv.numberOfBottomPaddingDot = 1;
    self.bfv.numberOfTopPaddingDot    = 1;
    self.bfv.numberOfLeftPaddingDot   = 2;
    self.bfv.numberOfRightPaddingDot  = 2;
    self.bfv.margin = 1;
    self.bfv.spacing = FBFontSpacingNumbers;
    self.bfv.glowSize = 20.0;
    self.bfv.innerGlowSize = 3.0;
    self.bfv.edgeLength = 4.0;
    self.bfv.textAlignment = NSTextAlignmentRight;


    [self.view addSubview:self.bfv];
    [self.bfv resetSize];
    [self.bfv centerizeInWidth:320];
}

- (void)setupLCDFont
{
    CGRect frame = CGRectMake(40, 150, 300, 50);
    FBLCDFontView *v = [[FBLCDFontView alloc] initWithFrame:frame];
    v.text = @"20141231";
    v.lineWidth = 4.0;
    v.drawOffLine = NO;
    v.edgeLength = 20;
    v.margin = 10.0;
    v.backgroundColor = [UIColor blackColor];
    v.horizontalPadding = 20;
    v.verticalPadding = 14;
    v.glowSize = 10.0;
    v.glowColor = UIColorFromRGB(0x00ffff);
    v.innerGlowColor = UIColorFromRGB(0x00ffff);
    v.innerGlowSize = 3.0;
    [self.view addSubview:v];
    [v resetSize];
    [v centerizeInWidth:320];
}

- (void)setupSquareFont
{
    CGRect frame = CGRectMake(10, 240, 300, 50);
    FBSquareFontView *v = [[FBSquareFontView alloc] initWithFrame:frame];
    v.text = @"SQUARE";
    v.lineWidth = 3.0;
    v.lineCap = kCGLineCapRound;
    v.lineJoin = kCGLineJoinRound;
    v.margin = 12.0;
    v.backgroundColor = [UIColor blackColor];
    v.horizontalPadding = 30;
    v.verticalPadding = 14;
    v.glowSize = 10.0;
    v.glowColor = UIColorFromRGB(0x00ffff);
    v.innerGlowColor = UIColorFromRGB(0x00ffff);
    v.lineColor = UIColorFromRGB(0xffffff); // 0xffdd66
    v.innerGlowSize = 2.0;
    v.verticalEdgeLength = 12;
    v.horizontalEdgeLength = 14;
    [self.view addSubview:v];
    [v resetSize];
    [v centerizeInWidth:320];
}

- (void)setupSquareFont2
{
    CGRect frame = CGRectMake(10, 320, 300, 50);
    FBSquareFontView *v = [[FBSquareFontView alloc] initWithFrame:frame];
    v.text = @"0123456789";
    v.lineWidth = 3.0;
    v.margin = 12.0;
    v.lineCap = kCGLineCapSquare;
    v.lineJoin = kCGLineJoinMiter;
    v.backgroundColor = [UIColor blackColor];
    v.horizontalPadding = 10;
    v.verticalPadding = 10;
    v.glowSize = 10.0;
    v.glowColor = UIColorFromRGB(0x00ffff);
    v.innerGlowColor = UIColorFromRGB(0x00ffff);
    v.innerGlowSize = 2.0;
    v.horizontalEdgeLength = 6.0;
    v.verticalEdgeLength = 12.0;
    [self.view addSubview:v];
    [v resetSize];
    [v centerizeInWidth:320];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
