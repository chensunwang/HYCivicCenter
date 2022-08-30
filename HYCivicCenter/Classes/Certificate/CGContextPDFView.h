//
//  CGContextPDFView.h
//  HelloFrame
//
//  Created by nuchina on 2021/8/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGContextPDFView : UIView {
    CGPDFDocumentRef pdfDocument;
    int pageNo;
}

- (instancetype)initWithFrame:(CGRect)frame atPage:(int)index withPDFDoc:(CGPDFDocumentRef)pdfDoc;

@end

NS_ASSUME_NONNULL_END
