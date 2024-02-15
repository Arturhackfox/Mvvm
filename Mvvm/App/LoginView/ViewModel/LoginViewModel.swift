//
//  LoginViewModel.swift
//  Mvvm
//
//  Created by Arthur Sh on 12.02.2024.
//

import UIKit
import Combine

// ViewModel
class UserViewModel {
    @Published var username: String = "Test"
    
    private var cancellables = Set<AnyCancellable>()
    
    func changeUsername(to name: String) {
        username = name
    }
}
