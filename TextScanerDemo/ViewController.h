//
//  ViewController.h
//  TextScanerDemo
//
//  Created by ARTOONMM0024 on 07/09/21.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<AVCaptureAudioDataOutputSampleBufferDelegate,AVCapturePhotoCaptureDelegate>
{
    AVCaptureVideoDataOutput *output;
    AVCaptureSession *captureSession;
    AVCaptureDevice *backCamera;
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *currentCamera;
    
    AVCapturePhotoOutput *photoOutput;
    AVCaptureVideoPreviewLayer *cameraPreviewLayer;
    
    UIImage *image;
}

@property (weak, nonatomic) IBOutlet UIView *screenshotBox;

- (IBAction)analyzeButtonPressed:(id)sender;

@end

