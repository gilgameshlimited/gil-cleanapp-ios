import UIKit

class DDPhotoDetailController: UIViewController, UIScrollViewDelegate {
    
    var model: DDSecretAlbumModel?
    
    var scrollView: UIScrollView?
    var imgView: UIImageView?

    @IBOutlet weak var shareBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView = UIScrollView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        self.scrollView?.backgroundColor = UIColor(hexString: "#EBF3FF")
        self.scrollView?.minimumZoomScale = 1.0
        self.scrollView?.maximumZoomScale = 4.0
        self.scrollView?.delegate = self
        self.scrollView?.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)
        self.view.insertSubview(self.scrollView!, at: 0)
        
        
        self.imgView = UIImageView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        self.scrollView?.addSubview(self.imgView!)
        self.imgView!.image = self.model?.image
        self.imgView!.contentMode = .scaleAspectFit

        self.shareBtn.setTitle(DDlocal("DDShare"), for: .normal)
        
    }

    @IBAction func closeClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func shareClick(_ sender: Any) {
        // 创建一个 UIActivityViewController 实例
        let activityViewController = UIActivityViewController(activityItems: [self.model?.image ?? UIImage()], applicationActivities: nil)
        
        // 显示分享视图控制器
        self.present(activityViewController, animated: true, completion: nil)

    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
    

}
