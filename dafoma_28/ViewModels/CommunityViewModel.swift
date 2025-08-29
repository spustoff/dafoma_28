//
//  CommunityViewModel.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import Foundation
import Combine

class CommunityViewModel: ObservableObject {
    @Published var challenges: [Challenge] = []
    @Published var activeChallenges: [Challenge] = []
    @Published var userChallenges: [Challenge] = []
    @Published var communityPosts: [CommunityPost] = []
    @Published var currentChallenge: Challenge?
    @Published var leaderboard: [LeaderboardEntry] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let communityService: CommunityService
    
    init(communityService: CommunityService = CommunityService()) {
        self.communityService = communityService
        loadChallenges()
        loadCommunityPosts()
    }
    
    func loadChallenges() {
        isLoading = true
        errorMessage = nil
        
        communityService.getAllChallenges()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] challenges in
                    self?.challenges = challenges
                    self?.activeChallenges = challenges.filter { $0.isActive }
                }
            )
            .store(in: &cancellables)
    }
    
    func loadUserChallenges(userId: UUID) {
        communityService.getUserChallenges(userId: userId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] challenges in
                    self?.userChallenges = challenges
                }
            )
            .store(in: &cancellables)
    }
    
    func joinChallenge(_ challenge: Challenge, userId: UUID) {
        isLoading = true
        
        communityService.joinChallenge(challengeId: challenge.id, userId: userId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] _ in
                    self?.loadUserChallenges(userId: userId)
                    self?.loadChallenges() // Refresh to update participant count
                }
            )
            .store(in: &cancellables)
    }
    
    func loadLeaderboard(for challengeId: UUID) {
        communityService.getLeaderboard(challengeId: challengeId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] leaderboard in
                    self?.leaderboard = leaderboard.sorted { $0.score > $1.score }
                    // Update ranks
                    for (index, _) in self?.leaderboard.enumerated() ?? [].enumerated() {
                        self?.leaderboard[index].rank = index + 1
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func loadCommunityPosts() {
        communityService.getCommunityPosts()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] posts in
                    self?.communityPosts = posts.sorted { $0.createdAt > $1.createdAt }
                }
            )
            .store(in: &cancellables)
    }
    
    func createPost(_ post: CommunityPost) {
        communityService.createPost(post)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] createdPost in
                    self?.communityPosts.insert(createdPost, at: 0)
                }
            )
            .store(in: &cancellables)
    }
    
    func likePost(_ post: CommunityPost, userId: UUID) {
        guard let postIndex = communityPosts.firstIndex(where: { $0.id == post.id }) else { return }
        
        if communityPosts[postIndex].likes.contains(userId) {
            communityPosts[postIndex].likes.removeAll { $0 == userId }
        } else {
            communityPosts[postIndex].likes.append(userId)
        }
        
        communityService.toggleLike(postId: post.id, userId: userId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                        // Revert the optimistic update
                        if self?.communityPosts[postIndex].likes.contains(userId) == true {
                            self?.communityPosts[postIndex].likes.removeAll { $0 == userId }
                        } else {
                            self?.communityPosts[postIndex].likes.append(userId)
                        }
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
    }
    
    func addComment(to post: CommunityPost, comment: Comment) {
        guard let postIndex = communityPosts.firstIndex(where: { $0.id == post.id }) else { return }
        
        communityPosts[postIndex].comments.append(comment)
        
        communityService.addComment(postId: post.id, comment: comment)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                        // Remove the optimistic comment
                        self?.communityPosts[postIndex].comments.removeAll { $0.id == comment.id }
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
    }
    
    func updateChallengeScore(challengeId: UUID, userId: UUID, score: Int) {
        communityService.updateChallengeScore(challengeId: challengeId, userId: userId, score: score)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] _ in
                    self?.loadLeaderboard(for: challengeId)
                }
            )
            .store(in: &cancellables)
    }
}

