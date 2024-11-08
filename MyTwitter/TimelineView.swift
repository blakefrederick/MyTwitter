// TimelineView.swift
import SwiftUI

struct TimelineView: View {
    @ObservedObject var viewModel = PostViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var isDarkMode = false

    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                List(viewModel.posts) { post in
                    PostRowView(post: post)
                        .id(post.id)
                }
                .refreshable {
                    viewModel.fetchPosts()
                }
                .listStyle(PlainListStyle())
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Button(action: {
                            // Scroll to top 
                            if let firstPostID = viewModel.posts.first?.id {
                                withAnimation {
                                    proxy.scrollTo(firstPostID, anchor: .top)
                                }
                            }
                        }) {
                            Text("Home")
                                .font(.headline)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isDarkMode.toggle()
                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                        }) {
                            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                        }
                    }
                }
            }
        }
    }
}
