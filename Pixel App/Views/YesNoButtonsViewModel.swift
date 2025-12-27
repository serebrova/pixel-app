//
//  YesNoButtonsViewModel.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 16.12.2025.
//

import SwiftUI

enum YesNoSelection {
    case none
    case yes
    case no
}

protocol YesNoButtonsViewModel: AnyObject {
    var showYesArrow: Bool { get }
    var showNoArrow: Bool { get }
    var isYesBlinking: Bool { get }
    var isNoBlinking: Bool { get }
    
    func selectYes()
    func selectNo()
}

