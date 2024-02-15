//
//  ViewController.swift
//  Mvvm
//
//  Created by Arthur Sh on 11.02.2024.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    /// UI находится внутри UIViewController, который является частью представления (View).
    /// В UIViewController создаются и настраиваются все пользовательские элементы (UI).
    
    // MARK: - Ui
    
    private lazy var button: UIButton = {
        var config = UIButton.Configuration.bordered()
        config.title = "Check"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .systemOrange
        config.cornerStyle = .capsule
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var loginTextField: UITextField = {
         let tf = UITextField()
         tf.placeholder = "Login.."
         tf.layer.cornerRadius = 17
         tf.layer.masksToBounds = true
         tf.backgroundColor = .systemGray6
         let padding: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 15))
         tf.leftView = padding
         tf.leftViewMode = .always
         tf.translatesAutoresizingMaskIntoConstraints = false
         
         return tf
     }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "SomeText"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    private var subscriptions = Set<AnyCancellable>()
    
    private let viewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        bindViewModelToView()
    }
    
    // MARK: - Setup
    
    // Bind ViewModel to View
    
    /// viewModel.$username - это способ доступа к издателю (Publisher), который автоматически отправляет новые значения   типа String? каждый раз, когда свойство username вашего UserViewModel изменяется.
    
    // ASSIGN
    // В конструкции .assign(to:on:):
    /// to: определяет, какое свойство будет обновлено. Это ключевой путь к свойству на объекте.
    /// on: указывает, на каком объекте будет происходить обновление. Это объект, у которого свойство находится по ключевому пути, определенному в to:.
    /// to: \.text указывает на свойство text объекта label, которое мы хотим обновить.
    /// on: label определяет объект, на котором будет происходить обновление, то есть текст  Лэйбла.
    /// Таким образом, каждый раз, когда в нашем UserViewModel изменяется свойство username и издатель отправляет новое значение, оно будет автоматически установлено в ЛЭЙБЛЕ
    /// тоесть я фактически говорю что Я ПОДПИСЫВАЮСЬ на рассылку $username я как только получу уведомление что там новое значение сразу это новое значение привяжи к тексту - лэйбла !!!!
    ///
    /// Когда вы используете $username в вашем коде, вы создаете издатель (Publisher), который отслеживает изменения свойства username в вашем UserViewModel. Как только значение этого свойства изменяется, издатель автоматически отправляет новое значение.
    /// Затем, используя оператор .assign(to:on:), вы говорите, что хотите привязать новые значения, отправленные издателем, к конкретному свойству объекта. В вашем случае, вы привязываете эти новые значения к свойству text вашего текстового поля (UITextField).
    /// Таким образом, каждый раз, когда значение username вашего UserViewModel изменяется, оно будет автоматически отображаться в тексте вашего текстового поля без необходимости вручную обновлять его значение.
   
    // STORE
    /// Когда вы создаете подписку на издатель (Publisher) в Combine, НУЖНО куда-то сохранить эту подписку, чтобы она не была автоматически уничтожена. В противном случае подписка будет освобождена, и обновления от издателя больше не будут получены!
    /// store(in:) используется для сохранения подписки. Когда контейнер, содержащий подписки, будет освобожден, все подписки внутри него также будут освобождены, что предотвращает утечку памяти.
    
    private func bindViewModelToView() {
        viewModel.$username
            .compactMap { $0 }
            .assign(to: \.text, on: label)
            .store(in: &subscriptions)
    }
    
    private func setupHierarchy() {
        view.addSubview(label)
        view.addSubview(loginTextField)
        view.addSubview(button)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            
            button.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func buttonTapped() {
        if let text = loginTextField.text {
            viewModel.changeUsername(to: text)
        }
    }
}

#Preview {
    ViewController()
}
