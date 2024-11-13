// PostViewModel.swift
import FirebaseFirestore
import Foundation

class PostViewModel: ObservableObject {
    @Published var posts = [Post]()
    private var db = Firestore.firestore()

    init() {
        fetchPosts()
    }

    func fetchPosts() {
        let randomValue = Double.random(in: 0 ... 1)

        db.collection("posts")
            .whereField("randomValue", isGreaterThanOrEqualTo: randomValue)
            .limit(to: 55)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching posts: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }
                let posts = documents.compactMap { try? $0.data(as: Post.self) }

                DispatchQueue.main.async {
                    self.posts = posts
                }
            }
    }

    func deletePost(_ post: Post) {
        guard let id = post.id else { return }
        db.collection("posts").document(id).delete { error in
            if let error = error {
                print("Error deleting post: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.posts.removeAll { $0.id == id }
                }
            }
        }
    }

    func superDeletePost(_ post: Post) {
        let username = post.username

        db.collection("posts")
            .whereField("username", isEqualTo: username)
            .getDocuments { snapshot, error in

                guard let documents = snapshot?.documents else { return }

                let batch = self.db.batch()

                for document in documents {
                    batch.deleteDocument(document.reference)
                }

                batch.commit { error in
                    if let error = error {
                        print("Error performing super delete: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            // Remove the posts from the "Timeline"
                            self.posts.removeAll { $0.username == username }
                        }
                    }
                }
            }

        // Keep a record of deleted URLs
        db.collection("deletedUrls").addDocument(data: ["url": username]) { error in
            if let error = error {
                print("Error adding URL to deletedUrls: \(error)")
            } else {
                print("URL added to deletedUrls: \(username)")
            }
        }
    }
}
