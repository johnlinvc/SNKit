struct snkit {

    var text = "Hello, World!"
}

#if os(iOS)
  import UIKit
#elseif os(OSX)
  import Foundation
#endif


public typealias SNResponse = String

#if os(iOS)
open class SNViewController : UIViewController {
}
#elseif os(OSX)
open class SNViewController {
    open var view:SNView!
    open func loadView() {
        self.view = SNView(frame: .zero)
    }
    open func viewDidLoad() {}
    open func viewWillAppear() {}
    public init() {}

    //extra methods
    public func renderHTML() -> SNResponse{
        loadView()
        viewDidLoad()
        viewWillAppear()
        return self.view.renderHTML()
    }
}
#endif

#if os(iOS)
open class SNWindow : UIWindow {
}
#elseif os(OSX)
open class SNWindow {

    open var rootViewController : SNViewController?

    //extra methods
    open func dispatch() -> String {
        let body = self.rootViewController?.renderHTML() ?? ""
        print(body)
        let response = "<html><body>\(body)</body></html>"
        return response
    }

    public init() {
    }
}
#endif

#if os(iOS)
open class SNView : UIView {
}
#elseif os(OSX)
open class SNView {
    var _subviews : [SNView] = []
    public var subviews : [SNView] {
        return _subviews
    }

    public var cssAttributes:[String : String] = [ : ]

    public required init(frame: CGRect) {
        cssAttributes["position"] = "absolute"
        cssAttributes["left"] = "\( frame.origin.x)"
        cssAttributes["top"] = "\( frame.origin.y)"
        cssAttributes["width"] = "\( frame.size.width)"
        cssAttributes["height"] = "\( frame.size.height)"
    }

    open func cssString() -> String{
        return cssAttributes.map {
            "\($0): \($1)"
        }.joined(separator:";")
    }

    public func addSubview(_ view: SNView){
        self._subviews.append(view)
    }

    //extra methods
    open func renderHTML() -> SNResponse {
        let response = subviews.map {
            $0.renderHTML()
        }.joined(separator: "\n")
        return response
    }
}
#endif

#if os(iOS)
open class SNLabel : UILabel {
}
#elseif os(OSX)
open class SNLabel : SNView {
    public required init(frame: CGRect) {
        super.init(frame: frame)
    }
    open var text = ""

    //extra methods
    open override func renderHTML() -> SNResponse {
        return SNResponse("<div style=\"\(cssString())\">\(text)</div>")
    }
}
#endif
