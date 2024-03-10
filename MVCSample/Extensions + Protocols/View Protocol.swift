import UIKit

protocol ViewProtocol: AnyObject {
    var viewState: ViewData { get set }
}

typealias View = ViewProtocol & UIView
