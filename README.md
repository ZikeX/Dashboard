# Dashboard


## Description

<img src="https://github.com/ZeroFengLee/Dashboard/blob/master/Example/demo.gif" width="233" height="166">


## How To Use

### Init
```swift
    private lazy var panelView: PanelView = {
        var panelView = PanelView(frame: CGRectMake(0, 0, 240, 120))
        panelView.center = CGPointMake(self.view.bounds.width / 2, 96)
        panelView.circlecolors = [UIColor.redColor(), UIColor.greenColor(), UIColor.yellowColor(), UIColor.brownColor(), UIColor.blueColor()]
        panelView.scales = [0, 50, 60, 100, 120, 220]
        panelView.showView()
        panelView.textFont = UIFont.systemFontOfSize(10)
        panelView.circlewidth = 25
        panelView.scaleLineNormalLength = 5
        panelView.scaleLineSpecialLength = 13
        panelView.watchCenterImage = "ecg_pic_pointer01"
        panelView.watchHandImage = "ecg_pic_pointer"
        return panelView
    }()
```

### Add subView

```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(panelView)
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(valueChange), userInfo: nil, repeats: true)
    }

    func valueChange() {
        panelView.value = CGFloat(arc4random() % 220)
    }
```