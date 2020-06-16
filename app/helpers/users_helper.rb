module UsersHelper
    def getFollowingId(follower,followed)
        Follow.where(follower: follower, followed: followed)[0].id
    end
end
