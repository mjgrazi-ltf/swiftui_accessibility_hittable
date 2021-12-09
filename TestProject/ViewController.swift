//
//  ViewController.swift
//  TestProject
//
//  Created by Mike Graziano on 12/7/21.
//

import UIKit
import Combine
import SwiftUI

class ViewController: UIViewController {
    var itemTracker: ItemTracker = ItemTracker()

    /// The View hosting a SwiftUI Controller that mimics the filterbar
    lazy var hostingController = {
        UIHostingController(rootView: AnyView(ItemsView().environmentObject(self.itemTracker)))
    }()

    /// The view that's shown modally to select animal names
    lazy var modalController: UIViewController = {
        let rootView = UIHostingController(rootView: AnyView(ModalView().environmentObject(self.itemTracker)))
        let navController = UINavigationController(rootViewController: rootView)
        rootView.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissModal))
        rootView.navigationItem.rightBarButtonItem?.accessibilityIdentifier = "cancelbutton"
        return navController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()


        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)

        let button = UIButton()
        button.setTitle("Show Modal", for: .normal)
        button.addTarget(self, action: #selector(modalButtonTapped), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .cyan
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "modalbutton"
        view.addSubview(button)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            hostingController.view.bottomAnchor.constraint(equalTo: button.topAnchor, constant: 10),
            hostingController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    @objc func modalButtonTapped() {
        present(self.modalController, animated: true, completion: nil)
    }

    @objc func dismissModal() {
        self.modalController.dismiss(animated: true, completion: nil)
    }
}

/// Main view showing selected items
struct ItemsView: View {
    @EnvironmentObject var itemTracker: ItemTracker

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(itemTracker.stringItems, id: \.self) { item in
                    FilterPill(displayText: item)
                }
            }
        }
    }
}

struct ModalView: View {
    @EnvironmentObject var itemTracker: ItemTracker

    var body: some View {
        VStack(spacing: 10) {
            ForEach(["Dog", "Cat", "Lizard", "Parrot", "Horse", "Ferret"], id: \.self) { animal in
                FilterPill(removable: false, displayText: "\(itemTracker.stringItems.contains(animal) ? "Remove" : "Add") \(animal)")
                    .accessibilityIdentifier("\(animal)button".lowercased())
                    .onTapGesture {
                        if !itemTracker.stringItems.contains(animal) {
                            itemTracker.stringItems.append(animal)
                        } else {
                            itemTracker.stringItems.removeAll(where: { $0 == animal })
                        }
                    }
            }
        }
    }
}

/// Simulates a viewModel being passed around that contains the animal names
class ItemTracker: ObservableObject {
    @Published var stringItems = [String]()
}

/// The view for an individual filter "pill" view
struct FilterPill: View {
    @EnvironmentObject var itemTracker: ItemTracker
    var removable: Bool = true
    var displayText: String

    var body: some View {
        HStack(spacing: 10) {
            Text(displayText)
                .font(.subheadline)
                .lineLimit(1)
                .accessibilityIdentifier("\(displayText)_selected")
            if removable {
                Button {
                    withAnimation {
                        itemTracker.stringItems.removeAll(where: { $0 == displayText })
                    }
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .aspectRatio(1.0, contentMode: .fit)
                }
                .accessibilityIdentifier("\(displayText)_dismiss")
            }
        }
        .padding(20)
        .foregroundColor(.black)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.teal)
        )
    }
}
