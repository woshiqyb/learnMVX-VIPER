import UIKit
import PlaygroundSupport

/**
 Apple的UIViewController其实是View + Controller。
 MVC模式下：controller持有model和view，并负责两者的通信，有时为了瘦身ViewController，会将model传入view中，来让view渲染页面，这就导致了三者之间难舍难分；
 MVP模式：在MVC的基础上，引入presenter并淡化controller，presenter持有model并直接与model进行通信，同时presenter和view通过接口/协议的方式进行通信，presenter只知道通过何种方式更新view，而不会知道具体的view是谁，而view跟model直接也将完全隔离，不直接通信；
 MVVM模式：在MVP的基础上，将presenter转化成viewModel，与MVP的区别是将view和viewModel进行双向绑定，使得viewModel对于view一无所知，view不仅需要将事件传递给viewModel，还需要更新自身。view与model、viewModel与model间的关系同MVP没什么区别；
 VIPER模式：IPER模式划分更细，边界更清晰。entity仅表示数据接口，获取逻辑由interactor管理；presenter仅处理UI相关逻辑，模块间数据传递交由router处理。
 */

// MVC BEGIN
//
//struct Person { // Model
//    let firstName: String
//    let lastName: String
//}
//
//class GreetingViewController: UIViewController { // View + Controller
//    var person: Person!
//    let showGreetingButton = UIButton()
//    let greetingLabel = UILabel()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.showGreetingButton.addTarget(self, action: #selector(tapButtonAction), for: .touchUpInside)
//        viewLayoutInitial()
//    }
//
//    @objc func tapButtonAction() {
//        self.greetingLabel.text = "Hello \(self.person.firstName) \(self.person.lastName)"
//    }
//
//    func viewLayoutInitial() {
//        self.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
//        self.view.backgroundColor = UIColor(white: 1.0, alpha: 1.0);
//
//        self.showGreetingButton.frame = CGRect(x: 10.0, y: 10.0, width: 90.0, height: 30.0)
//        self.showGreetingButton.layer.cornerRadius = 6.0
//        self.showGreetingButton.backgroundColor = .blue
//
//        self.greetingLabel.frame = CGRect(x: 10.0, y: 60.0, width: 200.0, height: 20.0)
//        self.greetingLabel.textColor = .blue
//        self.greetingLabel.text = "Say hello to who?"
//
//        self.view.addSubview(self.showGreetingButton);
//        self.view.addSubview(self.greetingLabel);
//    }
//}
//
//// Assembing of MVC
//let viewController = GreetingViewController()
//let person = Person(firstName: "Qian", lastName: "Yang Biao")
//viewController.person = person;
//
//PlaygroundPage.current.liveView = viewController.view;
//
// MVC END


// MVP BEGIN
//
//struct Person {     // Model
//    let firstName: String
//    let lastName: String
//}
//
//protocol GreetingView {
//    func setGreeting(greeting: String)
//}
//
//protocol GreetingViewPresenter {
//    init (view: GreetingView, person: Person)
//    func showGreeting()
//}
//
//class GreetingPresenter : GreetingViewPresenter {   // Presenter
//    let view : GreetingView
//    var person : Person
//
//    required init(view: GreetingView, person: Person) {
//        self.view = view
//        self.person = person
//    }
//
//    @objc func showGreeting() {
//        let greeting = "Hello \(person.firstName) \(person.lastName)"
//        view.setGreeting(greeting: greeting)
//    }
//}
//
//class GreetingViewController: UIViewController, GreetingView {  // View + 弱Controller
//    var presenter: GreetingPresenter!
//    let showGreetingButton = UIButton()
//    let greetingLabel = UILabel()
//
//    override func viewDidLoad() {
//        self.showGreetingButton.addTarget(presenter, action: #selector(GreetingPresenter.showGreeting), for: .touchUpInside)
//
//        viewLayoutInitial()
//    }
//
//    func setGreeting(greeting: String) {
//        self.greetingLabel.text = greeting
//    }
//
//    func viewLayoutInitial() {
//        self.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
//        self.view.backgroundColor = UIColor(white: 1.0, alpha: 1.0);
//
//        self.showGreetingButton.frame = CGRect(x: 10.0, y: 10.0, width: 90.0, height: 30.0)
//        self.showGreetingButton.layer.cornerRadius = 6.0
//        self.showGreetingButton.backgroundColor = .blue
//
//        self.greetingLabel.frame = CGRect(x: 10.0, y: 60.0, width: 200.0, height: 20.0)
//        self.greetingLabel.textColor = .blue
//        self.greetingLabel.text = "Say hello to who?"
//
//        self.view.addSubview(self.showGreetingButton);
//        self.view.addSubview(self.greetingLabel);
//    }
//}
//
//// Assembing of MVP
//let viewController = GreetingViewController()
//let person = Person(firstName: "Qian", lastName: "Yang Biao")
//let presenter = GreetingPresenter(view: viewController, person: person)
//viewController.presenter = presenter
//
//PlaygroundPage.current.liveView = viewController.view;
//
 // MVP END

// MVVM BEGIN
//
//struct Person {     // Model
//    let firstName: String
//    let lastName: String
//}
//
//protocol GreetingViewModelProtocol {
//    var greeting: String? { get }
//    var greeingDidChanged:( (GreetingViewModelProtocol) -> ())? { get set }
//
//    init(person: Person)
//    func showGreeting()
//}
//
//class GreetingViewModel: GreetingViewModelProtocol {
//    let person: Person
//
//    var greeting: String? {
//        didSet {
//            self.greeingDidChanged?(self)
//        }
//    }
//
//    var greeingDidChanged: ((GreetingViewModelProtocol) -> ())?
//
//    required init(person: Person) {
//        self.person = person
//        greeting = ""
//    }
//
//    @objc func showGreeting() {
//        self.greeting = "Hello \(person.firstName) \(person.lastName)"
//    }
//}
//
//class GreetingViewController: UIViewController {  // View + 弱Controller
//    var viewModel: GreetingViewModel! {
//        didSet {
//            self.viewModel.greeingDidChanged = { [unowned self] viewModel in
//                self.greetingLabel.text = viewModel.greeting
//            }
//        }
//    }
//
//    let showGreetingButton = UIButton()
//    let greetingLabel = UILabel()
//
//    override func viewDidLoad() {
//        self.showGreetingButton.addTarget(viewModel, action: #selector(viewModel.showGreeting), for: .touchUpInside)
//
//        viewLayoutInitial()
//    }
//
//    func viewLayoutInitial() {
//        self.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
//        self.view.backgroundColor = UIColor(white: 1.0, alpha: 1.0);
//
//        self.showGreetingButton.frame = CGRect(x: 10.0, y: 10.0, width: 90.0, height: 30.0)
//        self.showGreetingButton.layer.cornerRadius = 6.0
//        self.showGreetingButton.backgroundColor = .blue
//
//        self.greetingLabel.frame = CGRect(x: 10.0, y: 60.0, width: 200.0, height: 20.0)
//        self.greetingLabel.textColor = .blue
//        self.greetingLabel.text = "Say hello to who?"
//
//        self.view.addSubview(self.showGreetingButton);
//        self.view.addSubview(self.greetingLabel);
//    }
//}
//
//// Assembing of MVVM
//let person = Person(firstName: "Qian", lastName: "Yang Biao")
//let viewModel = GreetingViewModel(person: person)
//let viewController = GreetingViewController()
//viewController.viewModel = viewModel
//PlaygroundPage.current.liveView = viewController.view;
//
 // MVVM END


// VIPER（View + Interactor + Presenter + Entity + Router） BEGIN

struct Person {   // Entity (usually more complex e.g. NSManagedObject)
    let firstName: String
    let lastName: String
}

struct GreetingData {  // Transport data structure (not Entity)
    let greeting: String
    let subject: String
}

protocol GreetingProvider {
    func provideGreetingData()
}

protocol GreetingOutput: AnyObject {
    func receiveGreetingData(greetingData: GreetingData)
}

class GreetingInteractor : GreetingProvider {
    weak var output: GreetingOutput!
    
    // 获取数据并解析成entity，然后通知presenter更新
    func provideGreetingData() {
        let person = Person(firstName: "Qian", lastName: "Yang Biao") // usually comes from data access layer
        let subject = "\(person.firstName) \(person.lastName)"
        let greeting = GreetingData(greeting: "Hello", subject: subject)
        self.output.receiveGreetingData(greetingData: greeting)
    }
}

protocol GreetingViewEventHandler {
    func didTapShowGreetingButton()
}

protocol GreetingView: class {
    func setGreeting(greeting: String)
}

class GreetingPresenter : GreetingOutput, GreetingViewEventHandler {
    weak var view: GreetingView!
    var greetingProvider: GreetingProvider!
    
    @objc func didTapShowGreetingButton() {
        // 同interactor交互，而不会直接操作entity
        self.greetingProvider.provideGreetingData()
    }
    
    func receiveGreetingData(greetingData: GreetingData) {
        let greeting = "\(greetingData.greeting) \(greetingData.subject)"
        // presenter通知view更新
        self.view.setGreeting(greeting: greeting)
    }
}

class GreetingViewController : UIViewController, GreetingView {
    var eventHandler: GreetingViewEventHandler!
    let showGreetingButton = UIButton()
    let greetingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showGreetingButton.addTarget(self, action: #selector(didTapButton(button:)), for: .touchUpInside)
        
        viewLayoutInitial()
    }
    
    @objc func didTapButton(button: UIButton) {
        // 传递事件给presenter
        self.eventHandler.didTapShowGreetingButton()
    }
    
    func setGreeting(greeting: String) {
        self.greetingLabel.text = greeting
    }
    
    // layout code goes here
    func viewLayoutInitial() {
        self.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        self.view.backgroundColor = UIColor(white: 1.0, alpha: 1.0);
        
        self.showGreetingButton.frame = CGRect(x: 10.0, y: 10.0, width: 90.0, height: 30.0)
        self.showGreetingButton.layer.cornerRadius = 6.0
        self.showGreetingButton.backgroundColor = .blue
        
        self.greetingLabel.frame = CGRect(x: 10.0, y: 60.0, width: 200.0, height: 20.0)
        self.greetingLabel.textColor = .blue
        self.greetingLabel.text = "Say hello to who?"
        
        self.view.addSubview(self.showGreetingButton);
        self.view.addSubview(self.greetingLabel);
    }
}

// Assembling of VIPER module, without Router
let view = GreetingViewController()
let presenter = GreetingPresenter()
let interactor = GreetingInteractor()
view.eventHandler = presenter
presenter.view = view
presenter.greetingProvider = interactor
interactor.output = presenter

PlaygroundPage.current.liveView = view.view;

//  VIPER END

