//
//  BirthdayView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 17.12.2025.
//

import SwiftUI

struct BirthdayView: View {
    var body: some View {
        ZStack {
            Assets.image(named: .background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    BirthdayView()
}
