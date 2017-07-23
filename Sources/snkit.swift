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
    open func respondToActions(_ actions:[String]) {
        loadView()
        viewDidLoad()
        viewWillAppear()
        view.respondToActions(actions)
    }
    public func renderHTML() -> SNResponse{
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
    open func dispatch(query: [String:String]) -> String {
        var actions:[String] = []
        for k in query.values {
            actions.append(k)
        }
        self.rootViewController?.respondToActions(actions)
        let body = self.rootViewController?.renderHTML() ?? ""
        print(body)
        let response = "<html><body>\(body)</body></html>"
        return response
    }

    open func restore_session(fromParams params:[String:String]) {
        print(params)
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

    open func respondToActions(_ actions:[String]) {
        subviews.forEach {
            $0.respondToActions(actions)
        }
    }

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

#if os(iOS)
open class SNButton : UILabel {
}
#elseif os(OSX)
public struct SNControlState : OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    public static let Normal = SNControlState(rawValue: 1)
}

public struct SNControlEvents : OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    public static let TouchUpInside = SNControlEvents(rawValue: 1)
}

open class SNButton : SNView {
    public required init(frame: CGRect) {
        super.init(frame: frame)
    }
    var normalTitle = "Button"
    open func setTitle(_ title: String, forState state: SNControlState) {
        self.normalTitle = title
    }

    open var target:AnyObject?
    open var action: Selector?
    open var actionStr : String {
        guard let action = action else {return ""}
        return NSStringFromSelector(action)
    }

    open func addTarget(_ target: AnyObject?, action: Selector, forControlEvents controlEvents: SNControlEvents) {
        self.target = target
        self.action = action
    }

    //extra methods
    open func onClickString() -> String { return "location.search = 'action=\(actionStr)'" }

    open override func respondToActions(_ actions:[String]) {
        if actions.contains(actionStr) {
            let _ = target?.perform(action!)
        }
    }
    open override func renderHTML() -> SNResponse {
        return SNResponse("<button style=\"\(cssString())\" onclick=\"\(onClickString())\">\(normalTitle)</button>")
    }
}
#endif
