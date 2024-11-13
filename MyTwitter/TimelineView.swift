// TimelineView.swift
import SwiftUI

struct TimelineView: View {
    @ObservedObject var viewModel = PostViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var isDarkMode = false

    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                List {
                    ForEach(viewModel.posts) { post in
                        PostRowView(post: post,
                                    onDelete: {
                                        viewModel.deletePost(post)
                                    },
                                    onSuperDelete: {
                                        viewModel.superDeletePost(post)
                                    })
                                    .id(post.id)
                    }

                    // Scroll to top
                    Button(action: {
                        if let firstPostID = viewModel.posts.first?.id {
                            withAnimation {
                                proxy.scrollTo(firstPostID, anchor: .top)
                            }
                        }
                    }) {
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.up.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        .padding(.vertical)
                    }
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
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = windowScene.windows.first
                            {
                                window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                            }
                        }) {
                            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                        }
                    }
                }
                .onAppear {
                    isDarkMode = colorScheme == .dark
                }
            }
        }
    }
}
