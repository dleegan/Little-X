//
//  UserProfileCell.swift
//  Little X
//
//  Created by dleegan on 24/01/2025.
//

import SwiftUI

struct UserProfileCell: View {
    let user: User
    let isSelected: Bool

    var body: some View {
        VStack {
            VStack {
                AsyncImage(url: user.imageUrl) { image in
                    image
                        .resizable()
                } placeholder: {
                    Rectangle()
                        .foregroundStyle(.gray)
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(
                Circle()
            )
            .padding(6)
            .overlay { pictureBorder }

            Text(user.userName ?? "No userName")
                .bold()
                .foregroundStyle(
                    isSelected ?
                        .primary :
                        Color(
                            white: 0.9
                        )
                )
        }
    }

    private var pictureBorder: some View {
        VStack {
            Circle()
                .strokeBorder(
                    borderStyle,
                    lineWidth: 4
                )
        }
    }

    private var borderStyle: AnyShapeStyle {
        switch isSelected {
            case false:
                return AnyShapeStyle(Color(white: 0.9))
            case true:
                return AnyShapeStyle(
                    AngularGradient(
                        colors: [.red, .pink, .purple, .yellow, .red],
                        center: .center
                    )
                )
        }
    }
}

#Preview {
    HStack(spacing: 50) {
        UserProfileCell(
            user: User.preview,
            isSelected: true
        )
        UserProfileCell(
            user: User.preview,
            isSelected: false
        )
    }
    .environment(
        \.managedObjectContext,
        DataController.preview.container.viewContext
    )
}
